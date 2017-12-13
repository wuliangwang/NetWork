# NetWork
基于AFN的二次封装

使用

1.首先先到 PHNetWorkEnum.h 中配置一下

2.依赖于SVProgressHUD 的 Load加载

3.DVNetFetcher 是异步文件下载 原生的API封装

```
[[[PHNetWork alloc] initWithRequestType:RequestTypeTestGet] getWithParameters:@{@"name1":@"lizhen"} showLoading:YES success:^(id data) {
            NSLog(@"%@",data);
        }];
```


