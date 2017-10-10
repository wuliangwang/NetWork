//
//  HFNetWorkHandler.h
//  Qotaku
//
//  Created by 胖虎 on 2017/5/17.
//  Copyright © 2017年 胖虎. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFNetWorkHandler : NSObject

+ (NSString *)getURLStringWithRequestType:(RequestType)type;

+ (NSString *)matchURLWith:(RequestType)type;

@end
