//
//  DVNetFetcher.h
//  Devond
//
//  Created by Devond on 15/11/6.
//  Copyright (c) 2015年 Horace. All rights reserved.
//  用来异步下载文件

#import <Foundation/Foundation.h>

typedef void(^DVNetFetcherFinishDownlowdHandler)(NSData *downData, NSError *error);
typedef void(^DVNetFetcherDownloadingProgressHandeler)(float progress);

@interface DVNetFetcher : NSObject

@property (nonatomic, strong, readonly)NSURL    *URL;

- (instancetype)initWithUrl:(NSURL *)URL;

- (void)finishDownlowd:(DVNetFetcherFinishDownlowdHandler)finishHandler;

- (void)downloadingProgress:(DVNetFetcherDownloadingProgressHandeler)progressHandler;

- (void)startAsynchronous;

- (void)startAsynchronousWithPlaceHolder:(UIImage *)placeHolder;

- (void)storeLocalImageToCacheWith:(UIImage *)image andKey:(NSString *)key;

@end
