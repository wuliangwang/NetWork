//
//  PHNetWorkManager.m
//  Seller
//
//  Created by 胖虎 on 2017/12/12.
//  Copyright © 2017年 胖虎. All rights reserved.
//

#import "PHNetWorkManager.h"

@interface PHNetWorkManager()
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) AFSecurityPolicy     *httpsPolicy;
@end

@implementation PHNetWorkManager

+ (instancetype)defaultManager{
    static PHNetWorkManager *defaultSelf = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultSelf = [[PHNetWorkManager alloc] init];
    });
    return defaultSelf;
}
- (void)GET:(NSString *)URLString parameters:(id)parameters finished:(RequestFinishedHandler)finish{
    
    [self.manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseMSG = [responseObject objectForKey:NET_MSG];
        NSNumber *codeNumber = [responseObject objectForKey:NET_CODE];
        long code = codeNumber.longValue;
        if (!finish) {
            return ;
        }
        if (code == NetWork_Success_Code) {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:URLString];
            finish(code,responseMSG,responseObject);
        }else{
            NSInteger number = [[NSUserDefaults standardUserDefaults] integerForKey:URLString];
            NSLog(@"URL:%@ 链接成功请求失败 失败次数:%ld",URLString,number + 1);
            if (number >= RequestFinishedCount - 1) {
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:URLString];
                finish(code,responseMSG,responseObject);
            }else{
                // 链接成功 请求失败
                [self responseFailWithErrorCode:code msg:responseMSG targetSEL:@selector(GET:parameters:finished:) URLString:URLString parameters:parameters finished:finish];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finish) {
            NSInteger number = [[NSUserDefaults standardUserDefaults] integerForKey:URLString];
            NSLog(@"URL:%@ 链接失败 失败次数:%ld",URLString,number + 1);
            if (number >= RequestFinishedCount - 1) {
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:URLString];
                finish(error.code,[self getNetFailActionWithMsgWithError:error],nil);
            }else{
                [self netFailActionWitherror:error targetSEL:@selector(GET:parameters:finished:) URLString:URLString parameters:parameters finished:finish];
            }
           
        }
    }];
}

- (void)POST:(NSString *)URLString parameters:(id)parameters finished:(RequestFinishedHandler)finish{
    
    [self.manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseMSG = [responseObject objectForKey:NET_MSG];
        NSNumber *codeNumber = [responseObject objectForKey:NET_CODE];
        long code = codeNumber.longValue;
        if (!finish) {
            return ;
        }
        if (code == NetWork_Success_Code) {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:URLString];
            finish(code,responseMSG,responseObject);
        }else{
            NSInteger number = [[NSUserDefaults standardUserDefaults] integerForKey:URLString];
            NSLog(@"URL:%@ 链接成功 请求失败 失败次数:%ld",URLString,number + 1);
            if (number >= RequestFinishedCount - 1) {
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:URLString];
                finish(code,responseMSG,responseObject);
            }else{
                // 链接成功 请求失败
                [self responseFailWithErrorCode:code msg:responseMSG targetSEL:@selector(POST:parameters:finished:) URLString:URLString parameters:parameters finished:finish];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finish) {
            NSInteger number = [[NSUserDefaults standardUserDefaults] integerForKey:URLString];
            NSLog(@"URL:%@ 链接失败 失败次数:%ld",URLString,number + 1);
            if (number >= RequestFinishedCount - 1) {
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:URLString];
                finish(error.code,[self getNetFailActionWithMsgWithError:error],nil);
            }else{
                [self netFailActionWitherror:error targetSEL:@selector(POST:parameters:finished:) URLString:URLString parameters:parameters finished:finish];
            }
            
        }
    }];
}

- (void)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block finished:(RequestFinishedHandler)finish{
    [self.manager POST:URLString parameters:parameters constructingBodyWithBlock:block progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        NSLog(@"进度:%lf  已上传:%.2fMB , 总:%.2fMB",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount,(uploadProgress.completedUnitCount / 1024.0 / 1024.0),(uploadProgress.totalUnitCount / 1024.0 / 1024.0));
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseMSG = [responseObject objectForKey:NET_MSG];
        NSNumber *codeNumber = [responseObject objectForKey:NET_CODE];
        long code = codeNumber.longValue;
        if (finish) {
            finish(code,responseMSG,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        AFNetworkReachabilityStatus netStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
        NSString *msg = @"";
        if (netStatus == AFNetworkReachabilityStatusNotReachable){
            msg = @"Net error,please check your net";
        }else{
            msg = error.localizedDescription;
        }
        finish(error.code,msg,nil);
    }];
}

//请求失败处理
- (void)netFailActionWitherror:(NSError *)error targetSEL:(SEL)sel URLString:(NSString *)URLString parameters:(id)parameters finished:(RequestFinishedHandler)finish{
//    self.failureNumber += 1;
    // 是否是没网
    AFNetworkReachabilityStatus netStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (netStatus == AFNetworkReachabilityStatusNotReachable){
        NSLog(@"%@ 无网,不重新请求",URLString);
        finish(error.code,[self getNetFailActionWithMsgWithError:error],nil);
        return;
    }else{
        NSLog(@"%@ 重新请求",URLString);
        NSInteger number = [[NSUserDefaults standardUserDefaults] integerForKey:URLString];
        number += 1;
        [[NSUserDefaults standardUserDefaults] setInteger:number forKey:URLString];
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL, NSString*, NSDictionary*, RequestFinishedHandler) = (void *)imp;
        func(self, sel, URLString,parameters, finish);
    }
    
    // 可以做一些网络失败处理 例如保存网络请求的失败码，来检测前后端的问题
    
}

/// 链接成功 请求失败 处理
- (void)responseFailWithErrorCode:(NSInteger)code msg:(NSString *)msg targetSEL:(SEL)sel URLString:(NSString *)URLString parameters:(id)parameters finished:(RequestFinishedHandler)finish{
    // 可以做一些错误码的判断，根据后台给的错误码来决定是否要重新网络请求
    NSArray *noAgainCodes = @[];
    if (NoRequestAgainCodes.length > 0) {
        noAgainCodes = [NoRequestAgainCodes componentsSeparatedByString:@","];
    }
    
    if ([noAgainCodes containsObject:[NSString stringWithFormat:@"%ld",code]]) {
        NSLog(@"URL:%@ code:%ld,不重新请求",URLString,code);
        finish(code,msg,nil);
        return;
    }
    
    NSLog(@"%@ 重新请求",URLString);
    NSInteger number = [[NSUserDefaults standardUserDefaults] integerForKey:URLString];
    number += 1;
    [[NSUserDefaults standardUserDefaults] setInteger:number forKey:URLString];
    IMP imp = [self methodForSelector:sel];
    void (*func)(id, SEL, NSString*, NSDictionary*, RequestFinishedHandler) = (void *)imp;
    func(self, sel, URLString,parameters, finish);
    
    // 可以做一些网络失败处理 例如保存网络请求的失败码，来检测前后端的问题
}

- (NSString *)getNetFailActionWithMsgWithError:(NSError *)error{
    AFNetworkReachabilityStatus netStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    NSString *msg = @"";
    if (netStatus == AFNetworkReachabilityStatusNotReachable){
        msg = @"Net error,please check your net";
    }else{
        msg = error.localizedDescription;
    }
    return msg;
}


- (AFSecurityPolicy *)httpsPolicy{
    if (!_httpsPolicy) {
        _httpsPolicy = [AFSecurityPolicy defaultPolicy];
        //允许非权威机构颁发的证书
        _httpsPolicy.allowInvalidCertificates = YES;
        //不验证域名一致性
        _httpsPolicy.validatesDomainName = NO;
    }
    
    return _httpsPolicy;
}

-(AFHTTPSessionManager *)manager{
    if(!_manager){
        _manager = [AFHTTPSessionManager manager];
        _manager.securityPolicy  = self.httpsPolicy;
        //设置解析数据类型 默认就是JOSN 类型
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //设置请求的参数格式 (后台给类型)
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [_manager.requestSerializer setTimeoutInterval:NetTimeOut_20];
    }
    return _manager;
}

@end
