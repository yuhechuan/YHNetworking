//
//  YHFileDownloader.h
//  YHNetworking
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 玉河川. All rights reserved.
//
// MIT License
//
// Copyright (c) 2017 yuhechuan( https://github.com/yuhechuan )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
