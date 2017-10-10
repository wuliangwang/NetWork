//
//  HFNetWorkEnum.h
//  Qotaku
//
//  Created by 胖虎 on 2017/5/17.
//  Copyright © 2017年 胖虎. All rights reserved.

/*
    后方跟着注释的 都是已调试接口
    注意:
        如果需要在URL后面拼接user_id 和 token 的 
        在 HFNetWorkHandler.m 中 userIdUrlType 方法中types 添加type
 */

#ifndef HFNetWorkEnum_h
#define HFNetWorkEnum_h

typedef enum{
    RequestTypeTest = 0,
    RequestTypeUserRegister,    // 注册
    RequestTypeUserCode,        // 获取验证码
    RequestTypeUserLogin,       // 登录
    RequestTypeUserLogout,      // 退出登录
    RequestTypeUserPassword,    // 重置,修改密码
    RequestTypeUserUpdate,      // 更新用户资料
    RequestTypeUserIcon,        // 更新用户头像
    RequestTypeHomepage,        // home
    RequestTypeStore,           // 商家详情
    RequestTypeStoreFavorite,   // 收藏店铺
    RequestTypeArticleList,     // 商家点评列表 
    RequestTypeArticleComments, // 商家点评评论列表  
    RequestTypeArticleLikeList, // 商家点评点赞列表
    RequestTypeArticle,         // 点评详情
    RequestTypeArticleLike,     // 点评点赞
    RequestTypeArticleFavorite, // 点评收藏 
    RequestTypeArticleCommentAdd,// 点评新加评论
    RequestTypeArticleCommentDelete,//删除点评评论
    RequestTypeArticleAdd,      // 新加点评  
    RequestTypeHomepageGoodsShow, // 美食秀 
    RequestTypeStoreFilter, // 商圈
}RequestType;


typedef NS_ENUM(NSInteger, NetWorkError){
    NetWorkError_OffLine                              = -1009,
    NetWorkError_TimeOut                              = -1001,
};

#define NET_USERID         @"userId"
#define NET_CODE           @"code"

#endif /* HFNetWorkEnum_h */
