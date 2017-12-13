//
//  PHNetWork.m
//  Seller
//
//  Created by 胖虎 on 2017/12/12.
//  Copyright © 2017年 胖虎. All rights reserved.
//

#import "PHNetWork.h"
#import "PHNetWorkManager.h"
#import "PHNetWorkHandler.h"
#import <SVProgressHUD.h>
@interface PHNetWork()
@property (nonatomic,assign) RequestType requestType;
@end

@implementation PHNetWork

- (instancetype)initWithRequestType:(RequestType)requestType{
    if (self = [super init]) {
        self.requestType = requestType;
    }
    return self;
}

- (void)getWithParameters:(NSDictionary *)parameters showLoading:(BOOL)showLoading success:(RequestSuccess)success{
    if (showLoading) {
        [SVProgressHUD showWithStatus:nil];
    }
    NSString *url = [PHNetWorkHandler getURLStringWithRequestType:self.requestType];
    [[PHNetWorkManager defaultManager] GET:url parameters:parameters finished:^(NSInteger code, NSString *responseMSG, NSDictionary *responseDict) {
        if (code == NetWork_Success_Code) {
            id data = [responseDict objectForKey:NET_DATA];
            if (success) {
                success(data);
            }
        }
        if (showLoading) {
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)getWithParameters:(NSDictionary *)parameters showLoading:(BOOL)showLoading finished:(RequestFinishedHandler)finish{
    if (showLoading) {
        [SVProgressHUD showWithStatus:nil];
    }
    NSString *url = [PHNetWorkHandler getURLStringWithRequestType:self.requestType];
    [[PHNetWorkManager defaultManager] GET:url parameters:parameters finished:^(NSInteger code, NSString *responseMSG, NSDictionary *responseDict) {
        if (finish) {
            finish(code,responseMSG,responseDict);
        }
        
        if (showLoading) {
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)postWithParameters:(NSDictionary *)parameters showLoading:(BOOL)showLoading success:(RequestSuccess)success{
    if (showLoading) {
        [SVProgressHUD showWithStatus:nil];
    }
    NSString *url = [PHNetWorkHandler getURLStringWithRequestType:self.requestType];
    [[PHNetWorkManager defaultManager] POST:url parameters:parameters finished:^(NSInteger code, NSString *responseMSG, NSDictionary *responseDict) {
        if (code == NetWork_Success_Code) {
            id data = [responseDict objectForKey:NET_DATA];
            if (success) {
                success(data);
            }
        }
        if (showLoading) {
            [SVProgressHUD dismiss];
        }
    }];
}


- (void)postWithParameters:(NSDictionary *)parameters showLoading:(BOOL)showLoading finished:(RequestFinishedHandler)finish{
    if (showLoading) {
        [SVProgressHUD showWithStatus:nil];
    }
    NSString *url = [PHNetWorkHandler getURLStringWithRequestType:self.requestType];
    [[PHNetWorkManager defaultManager] POST:url parameters:parameters finished:^(NSInteger code, NSString *responseMSG, NSDictionary *responseDict) {
        if (finish) {
            finish(code,responseMSG,responseDict);
        }
        
        if (showLoading) {
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)postFileWithData:(NSArray<NSData *>*)datas parameters:(NSDictionary *)parameters showLoading:(BOOL)showLoading Name:(NSString *)name FileName:(NSString *)fileName MimeType:(NSString *)mimeType finish:(RequestFinishedHandler)finish{
    if (showLoading) {
        [SVProgressHUD showWithStatus:nil];
    }
    NSString *url = [PHNetWorkHandler getURLStringWithRequestType:self.requestType];
    [[PHNetWorkManager defaultManager] POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSData *data in datas) {
            [formData appendPartWithFileData:data name:name fileName:fileName?:@"image.png" mimeType:mimeType?:@"image/png"];
        }
    } finished:^(NSInteger code, NSString *responseMSG, NSDictionary *responseDict) {
        if (finish) {
            finish(code,responseMSG,responseDict);
        }
        if (showLoading) {
            [SVProgressHUD dismiss];
        }
    }];
}

+ (void)downloadTaskWithURL:(NSString *)url showLoading:(BOOL)showLoading filePath:(NSString *)filePath disk:(BOOL)disk progress:(void(^)(double progre))progress downLoadFinishedHandler:(downLoadFinishedHandler)downLoadFinish{
    
    
}


@end


