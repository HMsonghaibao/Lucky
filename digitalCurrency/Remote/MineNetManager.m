//
//  MineNetManager.m
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MineNetManager.h"

@implementation MineNetManager

//保存用户信息
+(void)saveInfosVideoUrl:(NSString *)videourl random:(NSString *)random CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/real/name";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"video"] = videourl;
    dic[@"random"] = random;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//身份认证上传视频获取随机码
+(void)identityAuthenticationapprovevideorandomCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
     NSString *path = @"uc/approve/video/random";
     NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//身份认证
+(void)identityAuthenticationRealName:(NSString *)realName andIdCard:(NSString *)idCard andVideoUrl:(NSString *)videoUrl andRandom:(NSString *)random andCardDic:(NSMutableDictionary *)cardDic CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/real/name";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"realName"] = realName;
    dic[@"idCard"] = idCard;
    dic[@"video"] = videoUrl;
    dic[@"random"] = random;
    dic[@"idCardFront"] = cardDic[@"idCardFront"];
    dic[@"idCardBack"] = cardDic[@"idCardBack"];
    dic[@"handHeldIdCard"] = cardDic[@"handHeldIdCard"];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//设置交易密码
+(void)moneyPasswordForJyPassword:(NSString *)jyPassword CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/transaction/password";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"jyPassword"] = jyPassword;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//获取重置交易密码的验证码
+(void)resetMoneyPasswordCodeForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/mobile/transaction/code";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//重置交易密码
+(void)resetMoneyPasswordForCode:(NSString *)code withNewPassword:(NSString *)newPassword CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/reset/transaction/password";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"code"] = code;
    dic[@"newPassword"] = newPassword;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//修改交易密码
+(void)resetMoneyPasswordForOldPassword:(NSString *)oldPassword withLatestPassword:(NSString *)latestPassword CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/update/transaction/password";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"oldPassword"] = oldPassword;
    dic[@"newPassword"] = latestPassword;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//获取绑定邮箱的验证码
+(void)bindingEmailCodeForEmail:(NSString *)email CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/bind/email/code";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"email"] = email;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//绑定邮箱
+(void)bindingEmailForCode:(NSString *)code withPassword:(NSString *)password withEmail:(NSString *)email CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/bind/email";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"code"] = code;
    dic[@"password"] = password;
    dic[@"email"] = email;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//获取绑定手机的验证码
+(void)bindingPhoneCodeForPhone:(NSString *)phone CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/mobile/bind/code";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"phone"] = phone;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//绑定手机
+(void)bindingPhoneForCode:(NSString *)code withPassword:(NSString *)password withPhone:(NSString *)phone CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/bind/phone";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"code"] = code;
    dic[@"password"] = password;
    dic[@"phone"] = phone;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//获取重置登录密码的验证码
+(void)resetLoginPasswordCodeForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/mobile/update/password/code";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//重置登录密码
+(void)resetLoginPasswordForCode:(NSString *)code withOldPassword:(NSString *)oldPassword withLatestPassword:(NSString *)latestPassword CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/update/password";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"code"] = code;
    dic[@"oldPassword"] = oldPassword;
    dic[@"newPassword"] = latestPassword;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//我的订单
+(void)myBillInfoForStatus:(NSString *)status withPageNo:(NSString*)pageNo withPageSize:(NSString *)pageSize CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"otc/order/self";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"status"] = status;
    dic[@"pageNo"] = pageNo;
    dic[@"pageSize"] = pageSize;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//账号设置的状态信息获取
+(void)accountSettingInfoForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"member/getMemberInfo";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//获取我的钱包所有信息
+(void)getMyWalletInfoForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/asset/wallet";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}


//查询总资产
+(void)getMyTotalInfoForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/asset/wallet/total";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}


//滚动列表
+(void)getqueryMemberAssetTotalForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/asset/wallet/queryMemberAssetTotal";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}


//任务列表
+(void)getTaskListForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/task/getTaskList";
    NSString*languagestr=@"";
    if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
        languagestr = @"en_us";
    }else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hans"])
    {
        languagestr = @"zh_cn";
    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:languagestr forKey:@"language"];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}


//我的收益
+(void)getTotalRewardForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/promotion/reward/getTotalReward";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}


//推荐奖励
+(void)getRecommandRewardTotalForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/promotion/reward/getRecommandRewardTotal";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}


//获取我的广告
+(void)getMyAdvertisingForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"otc/advertise/all";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//上架我的广告
+(void)upMyAdvertisingForAdvertisingId:(NSString *)advertisingId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"otc/advertise/on/shelves";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"id"] = advertisingId;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//下架我的广告
+(void)downMyAdvertisingForAdvertisingId:(NSString *)advertisingId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"otc/advertise/off/shelves";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"id"] = advertisingId;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//获取广告的详细信息
+(void)getMyAdvertisingDetailInfoForAdvertisingId:(NSString *)advertisingId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"otc/advertise/detail";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"id"] = advertisingId;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//明细 获取交易历史
+(void)getTradeHistoryForCompleteHandleWithPageNo:(NSString*)pageNo withPageSize:(NSString *)pageSize CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/asset/transaction/all";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"pageNo"] = pageNo;
    dic[@"pageSize"] = pageSize;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//上传图片
+(void)uploadImageForFile:(NSData *)file CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/upload/oss/image";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"file"] = file;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//设置头像
+(void)setHeadImageForUrl:(NSString *)urlString CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"member/updateAvatar";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"imageUrl"] = urlString;
    dic[@"memberId"] = [YLUserInfo shareUserInfo].ID;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//提币获取验证码
+(void)resetwithdrawCodeForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/mobile/withdraw/code";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//提币申请
+(void)mentionCoinApplyForUnit:(NSString *)unit withAddress:(NSString*)address withAmount:(NSString *)amount withFee:(NSString *)fee withRemark:(NSString *)remark withJyPassword:(NSString *)jyPassword mobilecode:(NSString *)mobilecode CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/withdraw/apply/code";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"unit"] = unit;
    dic[@"remark"] = remark;
    dic[@"address"] = address;
    dic[@"amount"] = amount;
    dic[@"fee"] = fee;
    dic[@"jyPassword"] = jyPassword;
    dic[@"code"] = mobilecode;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//提币选择信息
+(void)mentionCoinInfoForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/withdraw/support/coin/info";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//1付款 2取消
+(void)myBillDetailTipForUrlString:(NSString *)urlString withOrderSn:(NSString *)orderSn CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = urlString;
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"orderSn"] = orderSn;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
// 4放款
+(void)myBillDetailTipForOrderSn:(NSString *)orderSn withJyPassword:(NSString*)jyPassword CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"otc/order/release";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"orderSn"] = orderSn;
    dic[@"jyPassword"] = jyPassword;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//订单投诉
+(void)myBillDetailComplaintsForRemark:(NSString *)remark withOrderSn:(NSString *)orderSn CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
{
    NSString *path = @"otc/order/appeal";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"orderSn"] = orderSn;
    dic[@"remark"] = remark;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//平台消息
+(void)getPlatformMessageForCompleteHandleWithPageNo:(NSString*)pageNo withPageSize:(NSString *)pageSize CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"notice/all";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"page"] = pageNo;
    dic[@"pageSize"] = pageSize;
    dic[@"memberId"] = [YLUserInfo shareUserInfo].ID;
    
    if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
        dic[@"language"] = @"en_us";
    }else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hans"])
    {
        dic[@"language"] = @"zh_cn";
    }
    
    
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//获取更改绑定手机的验证码
+(void)changePhoneNumCode:(NSString*)phone ForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"sms/sendCheckCode";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:phone forKey:@"mobile"];
    dic[@"codeType"] = @"2";
    NSLog(@"====%@",dic);
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//更换手机号
+(void)changePhoneNumForPassword:(NSString *)password withPhone:(NSString*)phone withCode:(NSString *)code CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"member/updateMobile";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
//    dic[@"password"] = password;
    dic[@"mobile"] = phone;
    dic[@"code"] = code;
    NSLog(@"===%@",dic);
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//上传反馈意见
+(void)takeUpFeedBackForRemark:(NSString *)remark CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/feedback";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"remark"] = remark;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//关于我们
+(void)aboutUSInfo:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/ancillary/website/info";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//订单详情页
+(void)myBillDetailForId:(NSString *)orderSn CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"otc/order/detail";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"orderSn"] = orderSn;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//获取历史聊天记录
+(void)chatRecordDetailForId:(NSString *)orderSn uidTo:(NSString *)uidTo uidFrom:(NSString *)uidFrom limit:(NSString *)limit page:(NSString *)page sortFiled:(NSString *)sortFiled CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"chat/getHistoryMessage";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"orderId"] = orderSn;
//    dic[@"uidTo"] = uidTo;
//    dic[@"uidFrom"] = uidFrom;
    dic[@"limit"] = limit;
    dic[@"page"] = page;
    dic[@"sortFiled"] = sortFiled;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}


//获取合伙人消息通知
+(void)getParterlistFortype:(NSString *)type nameid:(NSString *)nameid limit:(NSString *)limit page:(NSString *)page sortFiled:(NSString *)sortFiled CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"chat/getHistoryMessage";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"messageType"] = type;
    dic[@"uidTo"] = nameid;
    dic[@"limit"] = limit;
    dic[@"page"] = page;
    dic[@"sortFiled"] = sortFiled;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}


//获取未读数
+(void)getUnReadCountFortype:(NSString *)type nameid:(NSString *)nameid CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"chat/getUnReadCount";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"messageType"] = type;
    dic[@"uidTo"] = nameid;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}



//设置已读
+(void)setMessageReadForMsgid:(NSString *)Msgid CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"chat/setMessageRead";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"msgId"] = Msgid;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}



//查看历史委托
+(void)historyEntrustForPageNo:(NSString *)pageNo withPageSize:(NSString*)pageSize CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
{
    NSString *path = @"exchange/order/history";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"pageNo"] = pageNo;
    dic[@"pageSize"] = pageSize;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//查看委托详情
+(void)historyEntrustDetailForOrderId:(NSString *)orderId  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = orderId;
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];

}
//提交的身份认证信息获取
+(void)getIdentifyInfo:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/real/detail";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//获取交易对数据
+(void)getTradCoinForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"market/symbol";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//获取收款账户信息
+(void)getPayAccountInfoForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/account/setting";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//设置银行卡
+(void)setBankNumForUrlString:(NSString *)url withBank:(NSString *)bank withBranch:(NSString *)branch withJyPassword:(NSString *)jyPassword withRealName:(NSString *)realName withCardNo:(NSString *)cardNo CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = url;
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"bank"] = bank;
    dic[@"branch"] = branch;
    dic[@"jyPassword"] = jyPassword;
    dic[@"realName"] = realName;
    dic[@"cardNo"] = cardNo;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//设置支付宝账号
+(void)setAliPayForUrlString:(NSString *)url withAli:(NSString *)ali withJyPassword:(NSString *)jyPassword withRealName:(NSString *)realName withQrCodeUrl:(NSString *)qrCodeUrl CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = url;
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"ali"] = ali;
    dic[@"jyPassword"] = jyPassword;
    dic[@"realName"] = realName;
    dic[@"qrCodeUrl"] = qrCodeUrl;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//设置微信账号
+(void)setWeChatForUrlString:(NSString *)url withWechat:(NSString *)wechat withJyPassword:(NSString *)jyPassword withRealName:(NSString *)realName withQrCodeUrl:(NSString *)qrCodeUrl CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = url;
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"wechat"] = wechat;
    dic[@"jyPassword"] = jyPassword;
    dic[@"realName"] = realName;
    dic[@"qrCodeUrl"] = qrCodeUrl;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//推广好友记录
+(void)getPromoteFriendsPageno:(NSString *)pageNo ForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/promotion/record";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"pageNo"] = pageNo;
    dic[@"pageSize"] = @"10";
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//我的佣金记录
+(void)getMyCommissionPageno:(NSString *)pageNo ForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/promotion/reward/record";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"pageNo"] = pageNo;
    dic[@"pageSize"] = @"10";
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//版本更新
+(void)versionUpdateForId:(NSString *)ID  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"app/getAppVersion"];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"platform"] = ID;
    NSLog(@"===%@",dic);
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//删除我的广告
+(void)deleteAdvertiseForAdvertiseId:(NSString *)advertiseId  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"otc/advertise/delete";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"id"] = advertiseId;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//持币分红
+(void)postBonusForAdvertiseId:(NSString *)advertiseId Param:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/bonus/user/page"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];

    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];

}

//交易/邀请挖矿记录
+(void)getmainminingAdvertiseId:(NSString *)advertiseId inviterState:(NSString *)inviterState withPageSize:(NSString*)pageSize startime:(NSString *)startime endtime:(NSString *)endtime CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/mine/list_es";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"memberId"] = advertiseId;
    dic[@"page"] = pageSize;
    dic[@"limit"] = @"10";
    if (startime.length > 0 && endtime.length > 0) {
        dic[@"startTime"] = startime;
        dic[@"endTime"] = endtime;
    }
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//首页分配数据
+(void)Getindex_infoCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"market/index_info";
    NSMutableDictionary *dic = [NSMutableDictionary new];

    [self requesByAppendtWithGET:[NSString stringWithFormat:@"%@%@",HOST,path] parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);

    }];
}

//账户状态(是否能发布广告)
+(void)userbusinessstatus:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/certified/business/status";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [self requestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//币理财管理
+(void)financialorderlistParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    
    
    
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/financial/order/list"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
    
    
}


//币理财项目
+(void)financialitemsCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/financial/items/list";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [self requestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//资产流水
+(void)assettransactionParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/asset/transaction/all"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}


//推荐奖励
+(void)recommendedrewardParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"member/updateNickName"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}


//获取投资详情邀请列表
+(void)getInviteMemberListParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"invest/all"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}


//获取投资详情统计
+(void)getInvestTotalParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/invest/getInvestTotal"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}


//图片上传接口
+(void)uploadByBase64Param:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"upload/uploadByBase64"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}


//上传实名认证头像
+(void)uploadFaceParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/upload/oss/uploadFace"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}


//是否已投过资
+(void)isInvestParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/invest/isInvest"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}


//合伙人收益
+(void)partnerincomeParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/promotion/reward/rewardPartnerList"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}


//手续费收益
+(void)feeincomeParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/promotion/reward/tradeFeeList"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}


//普通直接或间接及其他推荐成员列表
+(void)generalRecommandListParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/member/generalRecommandList"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}


//查询普通推荐人数统计
+(void)queryGeneralRecommandTotalParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"asset/transfer"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}


//抽奖记录
+(void)queryMemberLotteryRecordListParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"member/getTotalPerformance"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}


//查询累计奖励
+(void)getMemberTotalRewardMoneyParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"withdraw/applyWithdraw"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}


//获取抽奖统计总数
+(void)getTotalLotteryMoneyInfoParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"member/getTeamList"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}


//查询当期排行榜
+(void)queryLotteryRankListByTimeParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"asset/myWallet"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}



//获取会员当期中奖金额
+(void)getMemberTimeRewardMoneyParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/lottery/getMemberTimeRewardMoney"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}



//团队管理
+(void)teamListParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
//    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/member/teamList"];
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/member/partnerRecommandList"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}



//申请费用查询
+(void)getApplyMoneyParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/member-partner/getApplyMoney"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}



//可选投资资金列表
+(void)queryInvestApplyMoneyListParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/invest/queryInvestApplyMoneyList"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}


//获取用户已投资金额
+(void)getInvestMoneyParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/invest/getInvestMoney"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}



//投资接口
+(void)investApplyMoneyListParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/invest/investApply"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}


//手动输入投资接口
+(void)customInvestApplyParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"invest/invest"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}



//查询合伙人信息
+(void)queryMemberPartnerParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"other/getAboutMe"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}



//获取签名
+(void)getUserSigParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"other/getDownloadUrl"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}



//查询分享信息
+(void)queryInviteInfoParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"other/getShareInfo"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}



//解锁记录
+(void)lockRecordParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"notice/delete"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}


//增加锁仓记录
+(void)queryAddLockRecordPageParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"notice/all"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}


//周解锁记录
+(void)weeklockRecordParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/member-unlock/weekUnlockList"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}



//锁仓信息
+(void)unlockInfoParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/member-unlock/unlockInfo"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}



//提币记录
+(void)withdrawrecordParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/withdraw/record"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}
//币理财
+(void)financialitemsBHBCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/financial/items/BHB";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self requestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}



//申请成为商家
+(void)approvecertifiedbusinessParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/approve/certified/business/apply"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}


//成为商家币种列表
+(void)approvebusinessauthdepositlist:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/business-auth-deposit/list";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self requestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//购买币理财
+(void)financialorderParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/financial/order"];

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//用户协议
+(void)Userprotocol:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/ancillary/more/help/detail"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}


//获取提币地址
+(void)getassetwalletresetaddress:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/asset/wallet/reset-address"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//个人中心的竞猜类型条件接口
+(void)Getcoinguesstype:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/coin/guess/type";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self requestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//个人中心投注记录
+(void)getcoinguessmemberId:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/coin/guess/memberId"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//中奖详情
+(void)getcoinguessdetail:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/coin/guess/detail"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);

    }];
}

//获取抽奖场次
+(void)getLotterySession:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"other/getInvestRule"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//申请报名抽奖
+(void)getRewardApply:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/lottery/rewardApply"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}



//获取抽奖规则
+(void)getLotteryRule:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"asset/myWalletUnit"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//邀请合伙人
+(void)invitationTurnParter:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"chat/invitationTurnPartner"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//邀请合伙人
+(void)invitationApplyPartner:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"income/getFreeLockList"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}


+(void)getPartnerInfo:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"income/myLockTotal"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}


//获取投资规则
+(void)getInvestRuleInfo:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"asset/exchangeTV"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
    
//投资收益统计
+(void)getInvestRewardTotal:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"asset/getCnyRateByUnit"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}



//复投记录
+(void)getRedeliveryList:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"member/updateAvatar"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//投资收益列表
+(void)getInvestRewardList:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"income/myIncomeTotal"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//收益列表
+(void)getInvestRewardTeamList:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"income/getIncomeList"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//投资记录
+(void)getInvestRecordParams:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    
    NSString *path = [NSString stringWithFormat:@"%@%@",HOST,@"uc/invest/getInvestRecord"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithPost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}




//汇特接口

//生态
+(void)shengtaiParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@%@",HUITEHOST,@"uc/promotion/reward/tradeFeeList"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [self requestWithHuitePost:path header:nil parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}

@end
