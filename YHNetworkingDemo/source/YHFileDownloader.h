//
//  YHFileDownloader.h
//  YHNetworking
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 玉河川. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^YHDownloadProgressBlock)(NSUInteger total, NSUInteger completed);
typedef void (^YHDownloadSuccessBlock)(NSURLResponse * _Nullable response, NSURL * _Nullable filePath);
typedef void (^YHDownloadFailureBlock)(NSURLResponse * _Nullable response, NSError * _Nullable error);

@interface YHFileDownloader : NSObject

/**
 Whether the breakpoint download function is enabled.`YES` by default.
 */

@property (readwrite ,nonatomic, assign) BOOL isBrokenPointLoading;

/**
 The path to store file, when file was downloaded.
 */

@property (readwrite ,nonatomic, copy) NSString * _Nullable destinationPath;

/**
 Creates and returns a manager for a FileDownloader created with the specified configuration. This is the designated initializer.
 
 @param configuration The configuration used to create the managed NSURLSession.
 
 @return A manager for a newly-created Downloader.
 */
- (instancetype _Nullable )initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration;

- (instancetype _Nullable )initWithSessionConfiguration:(NSURLSessionConfiguration *_Nullable)configuration
                                   isBrokenPointLoading:(BOOL)isBrokenPointLoading
                                        destinationPath:(NSString *_Nullable)destinationPath;

/**
 *  断点下载文件
 *
 *  @param URLString   下载路径
 *  @param progress    进度回调
 *  @param success     成功回调
 *  @param failure     失败回调
 *
 *  @return NSURLSessionTask对象
 */
- (NSURLSessionTask *_Nullable)downloadFile:(NSString *_Nullable)URLString
                                   progress:(YHDownloadProgressBlock _Nullable )progress
                                    success:(YHDownloadSuccessBlock _Nullable )success
                                    failure:(YHDownloadFailureBlock _Nullable )failure;

@end
