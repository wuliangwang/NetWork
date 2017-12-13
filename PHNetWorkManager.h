//
//  PHNetWorkManager.h
//  Seller
//
//  Created by 胖虎 on 2017/12/12.
//  Copyright © 2017年 胖虎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHNetWorkEnum.h"
#import <AFNetworking.h>

@interface PHNetWorkManager : NSObject
+ (instancetype)defaultManager;

- (void)GET:(NSString *)URLString parameters:(id)parameters finished:(RequestFinishedHandler)finish;

- (void)POST:(NSString *)URLString parameters:(id)parameters finished:(RequestFinishedHandler)finish;

- (void)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block finished:(RequestFinishedHandler)finish;


@end
