//
//  HFNetWork.h
//  Qotaku
//
//  Created by 胖虎 on 2017/5/17.
//  Copyright © 2017年 胖虎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFNetWorkEnum.h"

typedef void(^RequestSuccess)(id data);

typedef void(^RequestFinishedHandler)(NSInteger code, NSString *responseMSG, NSDictionary *responseDict);

typedef void(^downLoadFinishedHandler)(NSInteger code, NSURLResponse *response, NSURL *filePath);

@interface HFNetWork : NSObject
- (instancetype)initWithRequestType:(RequestType)requestType;

//- (instancetype)initWithRequestType:(RequestType)requestType needLogin:(BOOL)need;

/**
 *  GET数据请求成功，返回Code为0
 *
 *  @param parameters  参数
 *  @param showLoading 是否显示Loading
 *  @param success     返回数据
 */
- (void)getWithParameters:(NSDictionary *)parameters showLoading:(BOOL)showLoading success:(RequestSuccess)success;

/**
 *  GET网络请求过程结束
 *
 *  @param parameters        请求参数
 *  @param showLoading 是否显示Loading
 *  @param finish      请求完成
 */
- (void)getWithParameters:(NSDictionary *)parameters showLoading:(BOOL)showLoading finished:(RequestFinishedHandler)finish;


/**
 *  POST数据请求成功，返回Code为0
 *
 *  @param parameters  参数
 *  @param showLoading 是否显示Loading
 *  @param success     返回数据
 */
- (void)postWithParameters:(NSDictionary *)parameters showLoading:(BOOL)showLoading success:(RequestSuccess)success;

/**
 *  POST网络请求过程结束
 *
 *  @param parameters        请求参数
 *  @param showLoading 是否显示Loading
 *  @parameters finish
 */
- (void)postWithParameters:(NSDictionary *)parameters showLoading:(BOOL)showLoading finished:(RequestFinishedHandler)finish;


/**
 *  POST 上传单个文件 上传结束回调
 *
 *  @param datas        需要上传是二进制文件数组(单个文件上传 数组中存一个元素即可)
 *  @param parameters  携带参数
 *  @param showLoading 是否显示Loading
 *  @param name        服务器用来解析的字段(后台定 必须传)
 *  @param fileName    与服务器协商好的文件名字 (可不传 默认 image.png)
 *  @param mimeType    文件类型(可不传 默认是 image/png)
 *  @param finish      请求结束 code = 0 成功
 */

- (void)postFileWithData:(NSArray<NSData *>*)datas parameters:(NSDictionary *)parameters showLoading:(BOOL)showLoading Name:(NSString *)name FileName:(NSString *)fileName MimeType:(NSString *)mimeType finish:(RequestFinishedHandler)finish;
/**
 *  DownLoad 下载文件
 *
 *  @param url         文件下载的URL
 *  @param filePath    存储路径
 *  @param disk        是否判断当前路径有没有文件(YES：本地有返回,没有则下载 NO:直接从网上下载)
 *  @param  progress    下载进度
 *  @param downLoadFinish  下载完成回调
 */

+ (void)downloadTaskWithURL:(NSString *)url showLoading:(BOOL)showLoading filePath:(NSString *)filePath disk:(BOOL)disk progress:(void(^)(double progre))progress downLoadFinishedHandler:(downLoadFinishedHandler)downLoadFinish;


@end
