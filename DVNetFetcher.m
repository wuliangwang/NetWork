//
//  DVNetFetcher.m
//  Devond
//
//  Created by Devond on 15/11/6.
//  Copyright (c) 2015年 Horace. All rights reserved.
//

#import "DVNetFetcher.h"


@interface DVNetFetcher ()<NSURLConnectionDataDelegate>
{
    NSString            *_cacheDirectory;
    NSFileManager       *_fileManager;
    NSCache             *_cache;
}

@property (nonatomic, strong)NSURLConnection    *connection;
@property (nonatomic, strong, readwrite)NSURL   *URL;

@property (nonatomic, strong)NSMutableData      *fileData;

@property (nonatomic, copy)DVNetFetcherFinishDownlowdHandler             finishHandler;
@property (nonatomic, copy)DVNetFetcherDownloadingProgressHandeler       progressHandler;

@end

@implementation DVNetFetcher


#pragma mark - Life Cycle

- (instancetype)initWithUrl:(NSURL *)URL{
    if (self = [super init]) {
        _URL = URL;
        _cacheDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Cache"];
        _fileManager = [NSFileManager defaultManager];
        _cache = [[NSCache alloc]init];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        _cacheDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Cache"];
        _fileManager = [NSFileManager defaultManager];
        _cache = [[NSCache alloc]init];
    }
    return self;
}

#pragma mark - Getter

- (NSMutableData *)fileData{
    if (!_fileData) {
        _fileData = [NSMutableData data];
    }
    return _fileData;
}

- (NSURLConnection *)connection{
    if (!_connection) {
        _connection = [[NSURLConnection alloc]init];
    }
    return _connection;
}


- (void)downloadingProgress:(DVNetFetcherDownloadingProgressHandeler)progressHandler{
    self.progressHandler = progressHandler;
}

- (void)finishDownlowd:(DVNetFetcherFinishDownlowdHandler)finishHandler{
    self.finishHandler = finishHandler;
}

- (void)startAsynchronous{
    NSData *cacheData = [_cache objectForKey:_URL];
    if (cacheData) {//先从缓存中
        if (_finishHandler) {
            _finishHandler(cacheData,nil);
        }
    }else{//从硬盘存储中
        NSData *diskData = [self extraDataWithKey:[self defaultKeyForURL:_URL]];
        if (diskData) {//从硬盘获取
            if (_finishHandler) {
                _finishHandler(diskData,nil);
            }
            [_cache setObject:diskData forKey:_URL cost:diskData.length];
        }else{
            [self downloadWithUrl:_URL];
        }
    }
}

- (void)startAsynchronousWithPlaceHolder:(UIImage *)placeHolder{
    NSData *cacheData = [_cache objectForKey:_URL];
    if (cacheData) {//先从缓存中
        if (_finishHandler) {
            _finishHandler(cacheData,nil);
        }
    }else{//从硬盘存储中
        NSData *diskData = [self extraDataWithKey:[self defaultKeyForURL:_URL]];
        if (diskData) {//从硬盘获取
            if (_finishHandler) {
                _finishHandler(diskData,nil);
            }
            [_cache setObject:diskData forKey:_URL cost:diskData.length];
        }else{//从网络下载，先返回占位图
            NSData *placeData = UIImageJPEGRepresentation(placeHolder, 1);
            if (_finishHandler) {
                _finishHandler(placeData,nil);
            }
            [self downloadWithUrl:_URL];
        }
    }
}

- (void)downloadWithUrl:(NSURL *)URL{
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self.connection start];
}

- (void)storeData:(NSData *)data WithKey:(NSString *)key{
    if (data) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (![_fileManager fileExistsAtPath:_cacheDirectory]) {
                [_fileManager createDirectoryAtPath:_cacheDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
            }
            NSString *filePath = [_cacheDirectory stringByAppendingPathComponent:key];
            [_fileManager createFileAtPath:filePath contents:data attributes:nil];
        });
    }
}

- (NSData *)extraDataWithKey:(NSString *)key{
    NSString *filePath = [_cacheDirectory stringByAppendingPathComponent:key];
    NSData *fileData;
    if ([_fileManager fileExistsAtPath:filePath]) {
        fileData = [_fileManager contentsAtPath:filePath];
    }
    return fileData;
}

- (NSString *)defaultKeyForURL:(NSURL *)URL{
    NSString *URLStr = URL.description;
    NSUInteger length = URLStr.length;
    NSString *keyStr;
    if (length > 11) {//去除http//和后缀名
        keyStr = [URLStr substringWithRange:NSMakeRange(7, length-11)];
    }
    //去除其他字符
    keyStr = [[keyStr componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet]] componentsJoinedByString:@""];
    return keyStr;
}

- (void)storeLocalImageToCacheWith:(UIImage *)image andKey:(NSString *)key{
    NSData *data = UIImageJPEGRepresentation(image, 1);
    [_cache setObject:data forKey:key cost:data.length];
    [self storeData:data WithKey:[self defaultKeyForURL:[NSURL URLWithString:key]]];
}

#pragma mark - ConnectionDelegate

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.fileData appendData:data];
}


-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error
{
    if (_finishHandler) {
        _finishHandler(nil,error);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (_finishHandler) {
        _finishHandler(self.fileData,nil);
    }
    [_cache setObject:self.fileData forKey:_URL cost:self.fileData.length];
    [self storeData:self.fileData WithKey:[self defaultKeyForURL:_URL]];
}

@end