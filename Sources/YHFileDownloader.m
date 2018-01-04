//
//  YHFileDownloader.m
//  YHNetworking
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 玉河川. All rights reserved.
//

#import "YHFileDownloader.h"
#import <CommonCrypto/CommonDigest.h>

#ifndef NSFoundationVersionNumber_iOS_8_0
#define NSFoundationVersionNumber_With_Fixed_5871104061079552_bug 1140.11
#else
#define NSFoundationVersionNumber_With_Fixed_5871104061079552_bug NSFoundationVersionNumber_iOS_8_0
#endif

typedef void (^YHURLSessionTaskProgressBlock)(NSProgress *);
typedef void (^YHURLSessionTaskCompletionHandler)(NSURLResponse *response, NSURL *filePath, NSError *error);

static dispatch_queue_t url_session_manager_creation_queue() {
    static dispatch_queue_t af_url_session_manager_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        af_url_session_manager_creation_queue = dispatch_queue_create("com.alamofire.networking.session.manager.creation", DISPATCH_QUEUE_SERIAL);
    });
    
    return af_url_session_manager_creation_queue;
}

static void url_session_manager_create_task_safely(dispatch_block_t block) {
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_With_Fixed_5871104061079552_bug) {
        dispatch_sync(url_session_manager_creation_queue(), block);
    } else {
        block();
    }
}

static NSString *YHRequestDownloadMd5String(NSString *key) {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return filename;
}

@interface YHFileDownloader ()<NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (readwrite, nonatomic, strong) NSURLSession *session;
@property (readwrite, nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, copy) YHURLSessionTaskProgressBlock downloadProgressBlock;
@property (nonatomic, copy) YHURLSessionTaskCompletionHandler completionHandler;
@property (readwrite, nonatomic, assign) long totalUnitCount;

@end

@implementation YHFileDownloader

+ (instancetype)downloader {
    return [[self alloc]init];
}

- (instancetype)init {
    return [self initWithSessionConfiguration:nil];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    return [self initWithSessionConfiguration:configuration isBrokenPointLoading:YES destinationPath:nil];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration
                        isBrokenPointLoading:(BOOL)isBrokenPointLoading
                             destinationPath:(NSString *)destinationPath {
    self = [super init];
    if (!self) {
        return nil;
    }
    if (!configuration) {
        configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    _destinationPath = (destinationPath && destinationPath.length > 0)? destinationPath : [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _isBrokenPointLoading = YES;
    _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    return self;
}

- (void)setIsBrokenPointLoading:(BOOL)isBrokenPointLoading {
    _isBrokenPointLoading = isBrokenPointLoading;
}

- (void)setDestinationPath:(NSString *)destinationPath {
    _destinationPath = destinationPath;
}

- (NSURLSessionTask *)downloadFile:(NSString *)URLString
                                  progress:(YHDownloadProgressBlock)progress
                                   success:(YHDownloadSuccessBlock)success
                                   failure:(YHDownloadFailureBlock)failure {
    NSURLSessionTask *downloadTask = nil;
    NSURLRequest *request = [self requestBySerializingDownloadURLString:URLString];
    downloadTask = [self downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
         progress((NSUInteger)downloadProgress.totalUnitCount, (NSUInteger)downloadProgress.completedUnitCount);
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            failure(response, error);
        } else {
            success(response, filePath);
        }
    }];
    [downloadTask resume];
    return downloadTask;
}

- (NSURLSessionTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                             progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                    completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler {
    __block NSURLSessionTask *downloadTask = nil;
    url_session_manager_create_task_safely(^{
        downloadTask = [self.session dataTaskWithRequest:request];
    });
    [self addForUploadTaskProgress:downloadProgressBlock completionHandler:completionHandler];
    return downloadTask;
}

- (void)addForUploadTaskProgress:(void (^)(NSProgress *uploadProgress))downloadProgressBlock
               completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler {
    _downloadProgressBlock = downloadProgressBlock;
    _completionHandler = completionHandler;
}

- (NSMutableURLRequest *)requestBySerializingDownloadURLString:(NSString *)URLString {
    
     NSString *tmpPath = [self requestDownloadTmpPathsURLString:URLString];
    // 配置流路径 打开写入流
    _outputStream = [[NSOutputStream alloc] initToFileAtPath:tmpPath append:self.isBrokenPointLoading];
    [_outputStream open];
    
    // 读取是否此url 是否存在断点文件
    NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:tmpPath error:nil];
    long filesize = [[fileInfo objectForKey:NSFileSize] longValue];
    
    NSURL *url = [NSURL URLWithString:URLString];
    NSParameterAssert(url);
    
    // 配置请求头
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [mutableRequest setHTTPMethod:@"GET"];
    
    [mutableRequest setValue:[NSString stringWithFormat:@"bytes=%ld-", filesize] forHTTPHeaderField:@"Range"];
    return mutableRequest;
}

- (NSString *)requestDownloadTmpPathsURLString:(NSString *)URLString {
   // 获取临时储存路径
   NSString *fileName = YHRequestDownloadMd5String(URLString);
   NSString *filePathTmp = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
   return filePathTmp;
}

- (NSString *)requestDownloadDestinationPathsURLSting:(NSString *)URLString {
    // 获取下载完后后的 储存路径
    NSString *fileName = YHRequestDownloadMd5String(URLString);
    NSString *filePath = self.destinationPath;
    NSString * filePathDocument = [filePath stringByAppendingPathComponent:fileName];
    return filePathDocument;
}

// 1 响应头  这次网络数据的属性（下载的总数据大小 content-Length, Content-Type）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    _totalUnitCount = response.expectedContentLength;
    completionHandler(NSURLSessionResponseAllow);
}

// 2 数据接收
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 回传 进度
    NSProgress *downloadProgress = [[NSProgress alloc]init];
    downloadProgress.totalUnitCount = _totalUnitCount;
    downloadProgress.completedUnitCount = [data length];
    _downloadProgressBlock(downloadProgress);
    
    // 流写入
    [self.outputStream write:[data bytes] maxLength:data.length];
}

// 3 网络任务结束
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    // 把tmp文件的图片数据移动document下面（目标路径）
    NSString *URLString = [task.currentRequest.URL absoluteString];
    NSString *tmpPath = [self requestDownloadTmpPathsURLString:URLString];
    NSString *destination = [self requestDownloadDestinationPathsURLSting:URLString];
   
    [self.outputStream close];
     self.outputStream = nil;
     NSError *fileError = nil;
    [[NSFileManager defaultManager] moveItemAtPath:tmpPath toPath:destination error:&fileError];
    
    // 成功返回数据
    NSURL *fliePath = [NSURL URLWithString:destination];
    _completionHandler(task.response,fliePath,error);
}

@end
