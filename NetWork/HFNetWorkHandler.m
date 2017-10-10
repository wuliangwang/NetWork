//
//  HFNetWorkHandler.m
//  Qotaku
//
//  Created by 胖虎 on 2017/5/17.
//  Copyright © 2017年 胖虎. All rights reserved.
//

#import "HFNetWorkHandler.h"
#import "BaseFunction.h"

@implementation HFNetWorkHandler
+(NSString *)getURLStringWithRequestType:(RequestType)type{
    NSString *url = [self matchURLWith:type];
    NSString *av = [NSString stringWithFormat:@"%@",@([BaseFunction getAppNumberVersion])];
    NSString *os = [[UIDevice currentDevice].systemName stringByAppendingFormat:@" %@",[UIDevice currentDevice].systemVersion];
    NSString *m = [[UIDevice currentDevice] devicePlatform];
    NSString *width = [NSString stringWithFormat:@"%ld",(long)[UIScreen mainScreen].currentMode.size.width];
    NSString *height = [NSString stringWithFormat:@"%ld",(long)[UIScreen mainScreen].currentMode.size.height];
    NSString *imei = [BaseFunction getImei];
    
    NSString *paras;
    
    // 判断是否需要拼接user_id 和 token 在 URL
    if ([UserManager checkLoginState] && [self userIdUrlType:type]) {
        NSNumber *userID = [[NSNumber alloc] initWithInteger:[UserManager defaultManager].userID];
        NSString *token = [UserManager defaultManager].loginToken;
        paras = [NSString stringWithFormat:@"%@?av=%@&os=%@&m=%@&w=%@&h=%@&imei=%@&user_id=%@&token=%@",url, av, os, m, width, height,imei,userID,token];
    }else{
        paras = [NSString stringWithFormat:@"%@?av=%@&os=%@&m=%@&w=%@&h=%@&imei=%@",url, av, os, m, width, height,imei];
    }
    
//        baseURL = [paras stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *baseURL;
    baseURL = [paras stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *resultURL = [LiveServer stringByAppendingString:baseURL];
    NSLog(@"resultURL : %@",resultURL);
    return resultURL;
}

+ (NSString *)matchURLWith:(RequestType)type{
    NSString *url;
    switch (type) {
        case RequestTypeUserRegister:
            url = @"/user/register";
            break;
        case RequestTypeUserCode:
            url = @"/user/code";
            break;
        case RequestTypeUserLogin:
            url = @"/user/login";
            break;
        case RequestTypeUserLogout:
            url = @"/user/logout";
            break;
        case RequestTypeUserUpdate:
            url = @"/user/update";
            break;
        case RequestTypeUserIcon:
            url = @"/user/icon";
            break;
        case RequestTypeHomepage:
            url = @"/homepage";
            break;
        case RequestTypeStore:
            url = @"/store";
            break;
        case RequestTypeStoreFavorite:
            url = @"/store/favorite";
            break;
        case RequestTypeArticleList:
            url = @"/article/list";
            break;
        case RequestTypeUserPassword:
            url = @"/user/password";
            break;
        case RequestTypeArticleComments:
            url = @"/article/comments";
            break;
        case RequestTypeArticleLikeList:
            url = @"/article/like_list";
            break;
        case RequestTypeArticle:
            url = @"/article";
            break;
        case RequestTypeArticleLike:
            url = @"/article/like";
            break;
        case RequestTypeArticleFavorite:
            url = @"/article/favorite";
            break;
        case RequestTypeArticleCommentAdd:
            url = @"/article/comment_add";
            break;
        case RequestTypeArticleCommentDelete:
            url = @"/article/comment_delete";
            break;
        case RequestTypeArticleAdd:
            url = @"/article/add";
            break;
        case RequestTypeHomepageGoodsShow:
            url = @"/homepage/goods_show";
            break;
        case RequestTypeStoreFilter:
            url = @"/store/filter";
            break;
        default:
        break;
    }
    
    return url;

}


/// 需要拼接的type 直接在下方数组中添加即可
+ (BOOL)userIdUrlType:(RequestType)type{
    NSArray *types = @[
                       @(RequestTypeStore), // 商家详情
                       @(RequestTypeStoreFavorite), // 收藏店铺
                       @(RequestTypeUserLogout), // 退出登录
                       @(RequestTypeUserUpdate), // 更新用户信息
                       @(RequestTypeUserIcon),   // 更新头像
                       @(RequestTypeArticleFavorite), //收藏
                       @(RequestTypeArticleLike), // 点赞
                       @(RequestTypeArticleCommentAdd), //点评新加评论
                       @(RequestTypeArticleAdd), //新加点评
                       @(RequestTypeArticle), // 点评详情
                       @(RequestTypeArticleList), //点评列表
                       @(RequestTypeArticleCommentDelete), // 点评删除评论
                       @(RequestTypeHomepageGoodsShow), // 美食秀
                       ];
    
    return [types containsObject:@(type)];
}


@end
