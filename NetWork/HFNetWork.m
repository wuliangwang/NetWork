//
//  HFNetWork.m
//  Qotaku
//
//  Created by 胖虎 on 2017/5/17.
//  Copyright © 2017年 胖虎. All rights reserved.
//

#import "HFNetWork.h"
#import "HFNetWorkHandler.h"
@interface HFNetWork ()

@property (nonatomic, assign)RequestType          requestType;
@property (nonatomic, strong)AFSecurityPolicy     *httpsPolicy;
@property (nonatomic, strong)AFHTTPSessionManager *manager;

@end

@implementation HFNetWork
-(instancetype)initWithRequestType:(RequestType)requestType{
    if (self = [super init]) {
        _requestType = requestType;
    }
    return self;
}


- (void)getWithParameters:(NSDictionary *)parameters showLoading:(BOOL)showLoading success:(RequestSuccess)success{
    if (showLoading) {
        [SVProgressHUD showWithStatus:nil];
//        [MBProgressHUD showHUDAddedTo:[HFUtil getHFSubCurrentVC].view animated:YES]
    }
    
    NSString *url = [HFNetWorkHandler getURLStringWithRequestType:_requestType];
    
    NSString *requestType = [HFNetWorkHandler matchURLWith:_requestType];
    NSLog(@"get: %@",requestType);    
    [self.manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showLoading) {
            [SVProgressHUD dismiss];
        }        
        id data = [responseObject exitObjectForKey:@"data"];
        NSString *responseMSG = [responseObject exitObjectForKey:@"msg"];
        NSNumber *codeNumber = [responseObject exitObjectForKey:NET_CODE];
        long code = codeNumber.longValue;
        NSLog(@"type: %@  code: %ld  msg: %@ ",requestType,code,responseMSG);
        
        if (success == NULL) {
            return;
        }
        
        if (code == 0) {//请求成功
            if (showLoading) {
                [SVProgressHUD showSuccessWithStatus:responseMSG];
            }
            success(data);
        }else{//连接成功，请求错误
//            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%ld\n%@",code,responseMSG]];
//            [MobClick event:@"errorCode" attributes:@{@"code":[NSString stringWithFormat:@"%ld",code],@"msg":responseMSG?:@""}];
            [self responseFailWithErrorCode:code responseMSG:responseMSG];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showLoading) {
            [SVProgressHUD dismiss];
        }
        [self netFailActionWitherror:error showLoading:showLoading];
    }];
    

    
}

- (void)getWithParameters:(NSDictionary *)parameters showLoading:(BOOL)showLoading finished:(RequestFinishedHandler)finish{
    if (showLoading) {
        [SVProgressHUD showWithStatus:nil];
    }
    
    NSString *url = [HFNetWorkHandler getURLStringWithRequestType:_requestType];
    NSString *requestType = [HFNetWorkHandler matchURLWith:_requestType];
    NSLog(@"get: %@",requestType);
    
    [self.manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showLoading) {
            [SVProgressHUD dismiss];
        }
//        NSLog(@"response:%@",responseObject);
        NSString *responseMSG = [responseObject exitObjectForKey:@"msg"];
        NSNumber *codeNumber = [responseObject exitObjectForKey:NET_CODE];
        long code = codeNumber.longValue;
        NSLog(@"type: %@  code: %ld  msg: %@ ",requestType,code,responseMSG);
        
        if (finish == NULL) {
            return;
        }
        if (code == 0) {//请求成功
            if (showLoading) {
                [SVProgressHUD showSuccessWithStatus:responseMSG];
            }
            finish(0,responseMSG,responseObject);
            
        }else{//连接成功，请求错误
            [SVProgressHUD showErrorWithStatus:responseMSG];
            [MobClick event:@"errorCode" attributes:@{@"code":[NSString stringWithFormat:@"%ld",code],@"msg":responseMSG?:@""}];
            finish(code,responseMSG,responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self netFailActionWitherror:error showLoading:showLoading];
        if (finish) {
            finish(-1,@"Request Error",nil);
        }
    }];
    
}


- (void)postWithParameters:(NSDictionary *)parameters showLoading:(BOOL)showLoading success:(RequestSuccess)success{
    if (showLoading) {
        [SVProgressHUD showWithStatus:nil];
    }
    
    NSString *url = [HFNetWorkHandler getURLStringWithRequestType:_requestType];
    NSString *requestType = [HFNetWorkHandler matchURLWith:_requestType];
    NSLog(@"post: %@",requestType);
    
    [self.manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showLoading) {
            [SVProgressHUD dismiss];
        }
        id data = [responseObject exitObjectForKey:@"data"];
        NSString *responseMSG = [responseObject exitObjectForKey:@"msg"];
        NSNumber *codeNumber = [responseObject exitObjectForKey:NET_CODE];
        long code = codeNumber.longValue;
        NSLog(@"type: %@  code: %ld  msg: %@ ",requestType,code,responseMSG);
        
        if (success == NULL) {
            return;
        }
        
        if (code == 0) {//请求成功
            if (showLoading) {
                [SVProgressHUD showSuccessWithStatus:responseMSG];
            }
            success(data);
        }else{//连接成功，请求错误
//            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%ld\n%@",code,responseMSG]];
//            [MobClick event:@"errorCode" attributes:@{@"code":[NSString stringWithFormat:@"%ld",code],@"msg":responseMSG?:@""}];
            [self responseFailWithErrorCode:code responseMSG:responseMSG];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self netFailActionWitherror:error showLoading:showLoading];
    }];
    

}
- (void)postWithParameters:(NSDictionary *)parameters showLoading:(BOOL)showLoading finished:(RequestFinishedHandler)finish{
    if (showLoading) {
        [SVProgressHUD showWithStatus:nil];
    }
    
    NSString *url = [HFNetWorkHandler getURLStringWithRequestType:_requestType];
    NSString *requestType = [HFNetWorkHandler matchURLWith:_requestType];
    NSLog(@"post: %@",requestType);
    [self.manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showLoading) {
            [SVProgressHUD dismiss];
        }
    
        NSString *responseMSG = [responseObject exitObjectForKey:@"msg"];
        NSNumber *codeNumber = [responseObject exitObjectForKey:NET_CODE];
        long code = codeNumber.longValue;
        NSLog(@"type: %@  code: %ld  msg: %@ ",requestType,code,responseMSG);
        
        if (finish == NULL) {
            return;
        }
        if (code == 0) {//请求成功
            if (showLoading) {
                [SVProgressHUD showSuccessWithStatus:responseMSG];
            }
            finish(0,responseMSG,responseObject);
            
        }else{//连接成功，请求错误
//            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%ld\n%@",code,responseMSG]];
//            [MobClick event:@"errorCode" attributes:@{@"code":[NSString stringWithFormat:@"%ld",code],@"msg":responseMSG?:@""}];
            [self responseFailWithErrorCode:code responseMSG:responseMSG];
            finish(code,responseMSG,responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self netFailActionWitherror:error showLoading:showLoading];
        if (finish) {
            finish(-1,@"Request Error",nil);
        }
    }];
  
    
}

- (void)postFileWithData:(NSArray<NSData *>*)datas parameters:(NSDictionary *)parameters showLoading:(BOOL)showLoading Name:(NSString *)name FileName:(NSString *)fileName MimeType:(NSString *)mimeType finish:(RequestFinishedHandler)finish {
    if (showLoading) {
        [SVProgressHUD showWithStatus:nil];
    }

    NSString *url = [HFNetWorkHandler getURLStringWithRequestType:_requestType];
    NSString *requestType = [HFNetWorkHandler matchURLWith:_requestType];
    NSLog(@"post: %@",requestType);
    [self.manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSData *data in datas) {
            [formData appendPartWithFileData:data name:name fileName:fileName?:@"image.png" mimeType:mimeType?:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        NSLog(@"进度:%lf  已上传:%.2fMB , 总:%.2fMB",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount,(uploadProgress.completedUnitCount / 1024.0 / 1024.0),(uploadProgress.totalUnitCount / 1024.0 / 1024.0));
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showLoading) {
            [SVProgressHUD dismiss];
        }
        
        NSString *responseMSG = [responseObject exitObjectForKey:@"msg"];
        NSNumber *codeNumber = [responseObject exitObjectForKey:NET_CODE];
        long code = codeNumber.longValue;
        NSLog(@"type: %@  code: %ld  msg: %@ ",requestType,code,responseMSG);
        if (finish == NULL) {
            return;
        }
        if (code == 0) {//请求成功
            if (showLoading) {
                [SVProgressHUD showSuccessWithStatus:responseMSG];
            }
            finish(0,responseMSG,responseObject);
            
        }else{//连接成功，请求错误
//            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%ld\n%@",code,responseMSG]];
//            [MobClick event:@"errorCode" attributes:@{@"code":[NSString stringWithFormat:@"%ld",code],@"msg":responseMSG?:@""}];
            [self responseFailWithErrorCode:code responseMSG:responseMSG];
            finish(code,responseMSG,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self netFailActionWitherror:error showLoading:showLoading];
        if (finish) {
            finish(-1,@"Request Error",nil);
        }
    }];
    
}
+ (void)downloadTaskWithURL:(NSString *)url showLoading:(BOOL)showLoading filePath:(NSString *)filePath disk:(BOOL)disk progress:(void (^)(double))progress downLoadFinishedHandler:(downLoadFinishedHandler)downLoadFinish{
    
    if (disk && [[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        if (downLoadFinish) {
            downLoadFinish(0,nil,[NSURL URLWithString:filePath]);
        }
        return;
    }
    
    if (showLoading) {
        [SVProgressHUD showWithStatus:nil];
    }
    
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        double p = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        NSLog(@"下载进度: %f",p);
        if (progress) {
            progress(p);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (filePath) {
            return [NSURL fileURLWithPath:filePath];
        }else{
            return targetPath;
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (error) {
            if (downLoadFinish) {
                downLoadFinish(-1,response,filePath);
            }
        }else{
            if (downLoadFinish) {
                downLoadFinish(0,response,filePath);
            }
        }
        
    }];
    //开始启动任务
    [task resume];
}

//请求失败原因判断
- (void)netFailActionWitherror:(NSError *)error showLoading:(BOOL)show{
    if (show) {
        [SVProgressHUD dismiss];
    }
    AFNetworkReachabilityStatus netStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    // 是否是没网
    if (netStatus == AFNetworkReachabilityStatusNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"Net error,please check your net"];
    }else{// 其他
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }
    NSLog(@"Error code:%ld  msg:%@",error.code,error.localizedDescription);
    [MobClick event:@"errorCode" attributes:@{@"code":[NSString stringWithFormat:@"%ld",error.code],@"msg":error.localizedDescription?:@""}];
}

/// 链接成功 请求失败 处理
- (void)responseFailWithErrorCode:(NSInteger)code responseMSG:(NSString *)responseMSG{
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%ld\n%@",code,responseMSG]];
    [MobClick event:@"errorCode" attributes:@{@"code":[NSString stringWithFormat:@"%ld",code],@"msg":responseMSG?:@""}];
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
        
//        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        [_manager.requestSerializer setTimeoutInterval:NetTimeOut_20];
    }
    return _manager;
}

@end
