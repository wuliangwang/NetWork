//
//  HFNetWorkHandler.m
//  Qotaku
//
//  Created by 胖虎 on 2017/5/17.
//  Copyright © 2017年 胖虎. All rights reserved.
//

#define LiveServer @"http://127.0.0.1"

#import "HFNetWorkHandler.h"
#import "BaseFunction.h"

@implementation HFNetWorkHandler
+(NSString *)getURLStringWithRequestType:(RequestType)type{
    NSString *url = [self matchURLWith:type];
    NSString *av = [NSString stringWithFormat:@"%@",@([BaseFunction getAppNumberVersion])];
    NSString *os = [[UIDevice currentDevice].systemName stringByAppendingFormat:@" %@",[UIDevice currentDevice].systemVersion];
    NSString *m = [[UIDevice currentDevice] devicePlatform];
    NSString *width = [NSString stringWithFormat:@"%ld",(long)[UIScreen mainScreen].currentMode.size.width];
    NSString *height = [NSString stringWithFormat:@"%ld",(long)[UIScreen mainScreen].currentMode.size.height];
    NSString *imei = [BaseFunction getImei];
    
    NSString *paras;
    
    // 判断是否需要拼接user_id 和 token 在 URL
    if ([UserManager checkLoginState] && [self userIdUrlType:type]) {
        NSNumber *userID = [[NSNumber alloc] initWithInteger:[UserManager defaultManager].userID];
        NSString *token = [UserManager defaultManager].loginToken;
        paras = [NSString stringWithFormat:@"%@?av=%@&os=%@&m=%@&w=%@&h=%@&imei=%@&user_id=%@&token=%@",url, av, os, m, width, height,imei,userID,token];
    }else{
        paras = [NSString stringWithFormat:@"%@?av=%@&os=%@&m=%@&w=%@&h=%@&imei=%@",url, av, os, m, width, height,imei];
    }
    NSString *baseURL;
    baseURL = [paras stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *resultURL = [LiveServer stringByAppendingString:baseURL];
    NSLog(@"resultURL : %@",resultURL);
    return resultURL;
}

+ (NSString *)matchURLWith:(RequestType)type{
    NSString *url;
    switch (type) {
        case RequestTypeTest:
            url = @"Test";
            break;
        default:
        break;
    }
    
    return url;

}


/// 需要拼接的type 直接在下方数组中添加即可
+ (BOOL)userIdUrlType:(RequestType)type{
    NSArray *types = @[
                       @(RequestTypeTest),
                       ];
    
    return [types containsObject:@(type)];
}


@end
