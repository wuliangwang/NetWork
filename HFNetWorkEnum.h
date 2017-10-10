//
//  HFNetWorkEnum.h
//  Qotaku
//
//  Created by 胖虎 on 2017/5/17.
//  Copyright © 2017年 胖虎. All rights reserved.

#ifndef HFNetWorkEnum_h
#define HFNetWorkEnum_h

typedef enum{
    RequestTypeTest = 0,
}RequestType;


typedef NS_ENUM(NSInteger, NetWorkError){
    NetWorkError_OffLine                              = -1009,
    NetWorkError_TimeOut                              = -1001,
};

#define NET_USERID         @"userId"
#define NET_CODE           @"code"

#endif /* HFNetWorkEnum_h */
