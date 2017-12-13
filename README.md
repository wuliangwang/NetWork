# NetWork
网络请求的基本封装

使用

1.首先先到 HFNetWorkEnum 中去添加一个网络请求的枚举

2.到 HFNetWorkHandler.m 中 matchURLWith 方法添加网络请求字段

3.到 HFNetWorkHandler.m 中 getURLStringWithRequestType 方法 配置URL 
可根据后台要求更改

4.DVNetFetcher 是异步文件下载 原生的API封装

5.HFNetWork 是正常的 get post 文件上传封装 基于 AFNetworking封装 其中的 load 效果使用的是 SVProgressHUD


