//
//  PHNetWorkHandler.h
//  Seller
//
//  Created by 胖虎 on 2017/12/12.
//  Copyright © 2017年 胖虎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHNetWorkEnum.h"
@interface PHNetWorkHandler : NSObject

+(NSString *)getURLStringWithRequestType:(RequestType)type;

+ (NSString *)matchURLWith:(RequestType)type;
@end
