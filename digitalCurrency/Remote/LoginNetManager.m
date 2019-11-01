//
//  LoginNetManager.m
//  digitalCurrency
//
//  Created by sunliang on 2018/2/5.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "LoginNetManager.h"

@implementation LoginNetManager
//极验验证的手机注册，获取短信验证码
+(void)getMobilePhoneForTel:(NSString *)tel withcountry:(NSString*)country withgeetest_challenge:(NSString*)challenge withgeetest_validate:(NSString*)validate withgeetest_seccode:(NSString*)seccode CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/mobile/code";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"phone"] = tel;
    dic[@"country"] = country;
    dic[@"geetest_challenge"] = challenge;
    dic[@"geetest_validate"] = validate;
    dic[@"geetest_seccode"] = seccode;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//邮箱注册
+(void)getAccountForEmail:(NSString *)email withpassword:(NSString*)password withusername:(NSString*)username withcountry:(NSString*)country withpromotion:(NSString*)promotion CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/register/email";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if (!promotion) {
        promotion=@"";
    }
     dic[@"email"] = email;
     dic[@"password"] = password;
     dic[@"username"] = username;
     dic[@"country"] = country;
     dic[@"promotion"] = promotion;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//手机号码注册
+(void)getAccountForPhone:(NSString *)phone withpassword:(NSString*)password withcode:(NSString*)code withusername:(NSString*)username withrecommend:(NSString*)recommend withcountry:(NSString*)country withG3Result:(NSDictionary *)g3Result CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{

    NSString *path = @"member/register";
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"mobile"] = phone;
    dic[@"pwd"] = password;
    dic[@"code"] = code;
    dic[@"userName"] = username;
//    dic[@"country"] = country;
//    dic[@"reccommand"] = recommend ? recommend : @"";
    NSString*recommendstr = [recommend stringByReplacingOccurrencesOfString:@" " withString:@""];
    dic[@"promotionCode"] = recommend ? recommendstr : @"";
    [g3Result enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
        [dic setObject:obj forKey:key];
    }];
    NSLog(@"dic --- %@",dic);
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}


//合伙人申请
+(void)partnerapplicationForPhone:(NSString *)phone withcoinName:(NSString*)coinName withcoin:(NSString*)coin withcode:(NSString*)code withusername:(NSString*)username withapplyType:(NSString*)applyType withdesc:(NSString*)desc CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    
    NSString *path = @"uc/member-partner/applyPartner";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    dic[@"memberId"] = [YLUserInfo shareUserInfo].ID;
    dic[@"mobile"] = phone;
    dic[@"realName"] = username;
    dic[@"promotionCode"] = code ? code : @"";
    dic[@"coinName"] = coinName;
    dic[@"applyType"] = applyType;
    dic[@"applyIntro"] = desc;
    dic[@"coinId"] = coin;
    
    NSLog(@"dic --- %@",dic);
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}



//邮箱或者手机登录
+(void)LogInForUsername:(NSString *)username andpassword:(NSString *)password CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/login";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"username"] = username;
    dic[@"password"] = password;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//极验验证的邮箱或者手机登录
+(void)challengeLogInForUsername:(NSString *)username andpassword:(NSString *)password geetest_challenge:(NSString *)challenge geetest_validate:(NSString *)validate geetest_seccode:(NSString *)seccode CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/login";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"username"] = username;
    dic[@"password"] = password;
    dic[@"geetest_challenge"] = challenge;
    dic[@"geetest_validate"] = validate;
    dic[@"geetest_seccode"] = seccode;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}
//退出
+(void)LogoutForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/loginout";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//支持国家
+(void)getAllCountryCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/support/country";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//忘记密码-获取邮箱验证码
+(void)FogetgetEmailcode:(NSString*)email CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/reset/email/code";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"account"] = email;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}
//忘记密码-获取手机短信验证码
+(void)FogetgetMobilecode:(NSString*)mobile CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/mobile/reset/code";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"account"] = mobile;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}//极验验证的忘记密码-获取手机短信验证码
+(void)challengeFogetgetMobilecode:(NSString*)mobile geetest_challenge:(NSString *)challenge geetest_validate:(NSString *)validate geetest_seccode:(NSString *)seccode CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/mobile/reset/code";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"account"] = mobile;
    dic[@"geetest_challenge"] = challenge;
    dic[@"geetest_validate"] = validate;
    dic[@"geetest_seccode"] = seccode;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}
//忘记登录密码去重置登录密码
+(void)FogetToResetPasswordWithaccount:(NSString*)account withname:(NSString*)name withcode:(NSString*)code withMode:(int)mode Withpassword:(NSString*)password CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"member/forgetPwd";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"mobile"] = account;
    dic[@"userName"] = name;
    dic[@"code"] = code;
//    dic[@"mode"] = [NSNumber numberWithInteger:mode];//0代表手机，1代表邮箱
    dic[@"pwd"] = [MD5 md5:password];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}


//修改登录密码
+(void)ChangeToResetPasswordWithaccount:(NSString*)account withcode:(NSString*)code withMode:(int)mode Withpassword:(NSString*)password CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"member/updatePwd";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //    dic[@"account"] = account;
    dic[@"memberId"] = [YLUserInfo shareUserInfo].ID;
    dic[@"code"] = code;
    //    dic[@"mode"] = [NSNumber numberWithInteger:mode];//0代表手机，1代表邮箱
    dic[@"pwd"] = [MD5 md5:password];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}


//忘记交易密码去重置登录密码
+(void)FogetToResetPayPasswordWithaccount:(NSString*)account withcode:(NSString*)code withMode:(int)mode Withpassword:(NSString*)password CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"member/updateJyPwd";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //    dic[@"account"] = account;
    dic[@"memberId"] = [YLUserInfo shareUserInfo].ID;
    dic[@"code"] = code;
    //    dic[@"mode"] = [NSNumber numberWithInteger:mode];//0代表手机，1代表邮箱
    dic[@"pwd"] = [MD5 md5:password];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

@end
