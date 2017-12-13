//
//  PHNetWorkEnum.h
//  Seller
//
//  Created by 胖虎 on 2017/12/12.
//  Copyright © 2017年 胖虎. All rights reserved.
//

#ifndef PHNetWorkEnum_h
#define PHNetWorkEnum_h

typedef void(^RequestSuccess)(id data);

typedef void(^RequestFinishedHandler)(NSInteger code, NSString *responseMSG, NSDictionary *responseDict);

typedef void(^downLoadFinishedHandler)(NSInteger code, NSURLResponse *response, NSURL *filePath);

/**
 * 声明项目中的请求地址枚举
 * 声明枚举之后,需要在 PHNetWorkHandler -> matchURLWith 方法中,设置对应的请求地址
 */
typedef enum{
    RequestTypeTest = 0,

}RequestType;


typedef NS_ENUM(NSInteger, NetWorkError){
    NetWorkError_OffLine                              = -1009,
    NetWorkError_TimeOut                              = -1001,
};

/// 网络请求成功code
#define NetWork_Success_Code 0

// 配置项目中网络请求返回数据公共的key
#define NET_USERID         @"userId"
#define NET_CODE           @"code"
#define NET_DATA           @"data"
#define NET_MSG            @"msg"

// BaceURL
#define LiveServer         @"http://192.168.0.11:8384"

// 网络链接超时最大值
#define NetTimeOut_20      20


// 正常GET 和 POST 请求最大请求失败数(失败原因非没有网) 只有请求失败次数达到了 才会回调 RequestFinishedHandler
#define RequestFinishedCount 1

// 链接成功请求失败 不重新请求直接回调RequestFinishedHandler的错误码集合（一般是后台拟定）
// 格式 @"001,002"  逗号隔开
#define NoRequestAgainCodes @""



#endif /* PHNetWorkEnum_h */
