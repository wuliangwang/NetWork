# NetWork
基于AFN的二次封装

使用

1.首先先到 PHNetWorkEnum.h 中配置一下

2.依赖于SVProgressHUD 的 Load加载

3.DVNetFetcher 是异步文件下载 原生的API封装



### 基本使用

1.GET
```
[[[PHNetWork alloc] initWithRequestType:RequestTypeTest] getWithParameters:@{@"Test":@"Test"} showLoading:YES success:^(id data) {
            // 网络请求成功后的操作
}];

[[[PHNetWork alloc] initWithRequestType:RequestTypeTest] getWithParameters:@{@"Test":@"Test"} showLoading:YES finished:^(NSInteger code, NSString *responseMSG, NSDictionary *responseDict) {
           // 网络请求结束后的操作 
}];
```
2.POST
```
[[[PHNetWork alloc] initWithRequestType:RequestTypeTest] postWithParameters:@{@"Test":@"Test"} showLoading:YES success:^(id data) {
            // 网络请求成功后的操作
}];

[[[PHNetWork alloc] initWithRequestType:RequestTypeTest] postWithParameters:@{@"Test":@"Test"} showLoading:YES finished:^(NSInteger code, NSString *responseMSG, NSDictionary *responseDict) {
           // 网络请求结束后的操作 
}];

```
3.上传图片
```
[[[PHNetWork alloc] initWithRequestType:RequestTypeTest] postFileWithData:@[imageData] parameters:@{@"Test":@"Test"} showLoading:YES Name:@"icon" FileName:nil MimeType:@"image/png" finish:^(NSInteger code, NSString *responseMSG, NSDictionary *responseDict) {
           // 请求结束后的操作
}];
```
......


#### PHNetWork.h
![PHNetWork.h](https://github.com/wuliangwang/NetWork/blob/master/Screenshots/PHNetWork.h_image1.png)
![PHNetWork.h](https://github.com/wuliangwang/NetWork/blob/master/Screenshots/PHNetWork.h_image2.png)

#### url的拼接
在 PHNetWorkEnum.h 添加枚举
![在 PHNetWorkEnum.h 添加枚举](https://github.com/wuliangwang/NetWork/blob/master/Screenshots/url_1.png)
在 PHNetWorkHandler.m 中配置url
![在 PHNetWorkHandler.m 中配置url](https://github.com/wuliangwang/NetWork/blob/master/Screenshots/url_2.png)






