//
//  PHNetWorkHandler.m
//  Seller
//
//  Created by 胖虎 on 2017/12/12.
//  Copyright © 2017年 胖虎. All rights reserved.
//

#import "PHNetWorkHandler.h"

@implementation PHNetWorkHandler
+(NSString *)getURLStringWithRequestType:(RequestType)type{
    NSString *url = [self matchURLWith:type];
    /**
     *  可以根据公司需求配置请求链接.
     */
    
    NSString *baseURL;
    baseURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *resultURL = [LiveServer stringByAppendingString:baseURL];
    NSLog(@"resultURL : %@",resultURL);
    return resultURL;
}

///
+ (NSString *)matchURLWith:(RequestType)type{
    NSString *url;
    switch (type) {
        case RequestTypeTest:
            url = @"/test";
            break;
        default:
            break;
    }
    return url;
    
}
@end
