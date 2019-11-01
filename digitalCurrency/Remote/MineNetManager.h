//
//  MineNetManager.h
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "BaseNetManager.h"

@interface MineNetManager : BaseNetManager

+(void)saveInfosVideoUrl:(NSString *)videourl random:(NSString *)random CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//身份认证上传视频获取随机码
+(void)identityAuthenticationapprovevideorandomCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//身份认证
+(void)identityAuthenticationRealName:(NSString *)realName andIdCard:(NSString *)idCard andVideoUrl:(NSString *)videoUrl andRandom:(NSString *)random andCardDic:(NSMutableDictionary *)cardDic CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//设置交易密码
+(void)moneyPasswordForJyPassword:(NSString *)jyPassword CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取重置交易密码的验证码
+(void)resetMoneyPasswordCodeForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//重置交易密码
+(void)resetMoneyPasswordForCode:(NSString *)code withNewPassword:(NSString *)newPassword CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//修改交易密码
+(void)resetMoneyPasswordForOldPassword:(NSString *)oldPassword withLatestPassword:(NSString *)latestPassword CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取绑定邮箱的验证码
+(void)bindingEmailCodeForEmail:(NSString *)email CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//绑定邮箱
+(void)bindingEmailForCode:(NSString *)code withPassword:(NSString *)password withEmail:(NSString *)email CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//获取绑定手机的验证码
+(void)bindingPhoneCodeForPhone:(NSString *)phone CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//绑定手机
+(void)bindingPhoneForCode:(NSString *)code withPassword:(NSString *)password withPhone:(NSString *)phone CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取重置登录密码的验证码
+(void)resetLoginPasswordCodeForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//重置登录密码
+(void)resetLoginPasswordForCode:(NSString *)code withOldPassword:(NSString *)oldPassword withLatestPassword:(NSString *)latestPassword CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//我的订单
+(void)myBillInfoForStatus:(NSString *)status withPageNo:(NSString*)pageNo withPageSize:(NSString *)pageSize CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//账号设置的状态信息获取
+(void)accountSettingInfoForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取我的钱包所有信息
+(void)getMyWalletInfoForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//查询总资产
+(void)getMyTotalInfoForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//滚动列表
+(void)getqueryMemberAssetTotalForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//任务列表
+(void)getTaskListForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//我的收益
+(void)getTotalRewardForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//推荐奖励
+(void)getRecommandRewardTotalForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取我的广告
+(void)getMyAdvertisingForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//上架我的广告
+(void)upMyAdvertisingForAdvertisingId:(NSString *)advertisingId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//下架我的广告
+(void)downMyAdvertisingForAdvertisingId:(NSString *)advertisingId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取广告的详细信息
+(void)getMyAdvertisingDetailInfoForAdvertisingId:(NSString *)advertisingId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//明细  获取交易历史
+(void)getTradeHistoryForCompleteHandleWithPageNo:(NSString*)pageNo withPageSize:(NSString *)pageSize CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//上传图片
+(void)uploadImageForFile:(NSData *)file CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//设置头像
+(void)setHeadImageForUrl:(NSString *)urlString CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//提币获取验证码
+(void)resetwithdrawCodeForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//提币申请
+(void)mentionCoinApplyForUnit:(NSString *)unit withAddress:(NSString*)address withAmount:(NSString *)amount withFee:(NSString *)fee withRemark:(NSString *)remark withJyPassword:(NSString *)jyPassword mobilecode:(NSString *)mobilecode CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//提币选择信息
+(void)mentionCoinInfoForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//1付款 2取消
+(void)myBillDetailTipForUrlString:(NSString *)urlString withOrderSn:(NSString *)orderSn CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
// 4放款
+(void)myBillDetailTipForOrderSn:(NSString *)orderSn withJyPassword:(NSString*)jyPassword CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//订单投诉
+(void)myBillDetailComplaintsForRemark:(NSString *)remark withOrderSn:(NSString *)orderSn CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//平台消息
+(void)getPlatformMessageForCompleteHandleWithPageNo:(NSString*)pageNo withPageSize:(NSString *)pageSize CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取更改绑定手机的验证码
+(void)changePhoneNumCode:(NSString*)phone ForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//更换手机号
+(void)changePhoneNumForPassword:(NSString *)password withPhone:(NSString*)phone withCode:(NSString *)code CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//上传反馈意见
+(void)takeUpFeedBackForRemark:(NSString *)remark CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//关于我们
+(void)aboutUSInfo:(void(^)(id resPonseObj,int code))completeHandle;

//订单详情页
+(void)myBillDetailForId:(NSString *)orderSn CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取历史聊天记录
+(void)chatRecordDetailForId:(NSString *)orderSn uidTo:(NSString *)uidTo uidFrom:(NSString *)uidFrom limit:(NSString *)limit page:(NSString *)page sortFiled:(NSString *)sortFiled CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//获取合伙人消息通知
+(void)getParterlistFortype:(NSString *)type nameid:(NSString *)nameid limit:(NSString *)limit page:(NSString *)page sortFiled:(NSString *)sortFiled CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//获取未读数
+(void)getUnReadCountFortype:(NSString *)type nameid:(NSString *)nameid CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//设置已读
+(void)setMessageReadForMsgid:(NSString *)Msgid CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//查看历史委托
+(void)historyEntrustForPageNo:(NSString *)pageNo withPageSize:(NSString*)pageSize CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//查看委托详情
+(void)historyEntrustDetailForOrderId:(NSString *)orderId  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//提交的身份认证信息获取
+(void)getIdentifyInfo:(void(^)(id resPonseObj,int code))completeHandle;

//获取交易对数据
+(void)getTradCoinForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取收款账户信息
+(void)getPayAccountInfoForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//设置银行卡
+(void)setBankNumForUrlString:(NSString *)url withBank:(NSString *)bank withBranch:(NSString *)branch withJyPassword:(NSString *)jyPassword withRealName:(NSString *)realName withCardNo:(NSString *)cardNo CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//设置支付宝账号
+(void)setAliPayForUrlString:(NSString *)url withAli:(NSString *)ali withJyPassword:(NSString *)jyPassword withRealName:(NSString *)realName withQrCodeUrl:(NSString *)qrCodeUrl CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//设置微信账号
+(void)setWeChatForUrlString:(NSString *)url withWechat:(NSString *)wechat withJyPassword:(NSString *)jyPassword withRealName:(NSString *)realName withQrCodeUrl:(NSString *)qrCodeUrl CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//推广好友记录
+(void)getPromoteFriendsPageno:(NSString *)pageNo ForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//我的佣金记录
+(void)getMyCommissionPageno:(NSString *)pageNo ForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//版本更新
+(void)versionUpdateForId:(NSString *)ID  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//删除我的广告
+(void)deleteAdvertiseForAdvertiseId:(NSString *)advertiseId  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//持币分红
+(void)postBonusForAdvertiseId:(NSString *)advertiseId Param:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//交易挖矿记录
+(void)getmainminingAdvertiseId:(NSString *)advertiseId inviterState:(NSString *)inviterState withPageSize:(NSString*)pageSize startime:(NSString *)startime endtime:(NSString *)endtime CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//首页分配数据
+(void)Getindex_infoCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//账户状态(是否能发布广告)
+(void)userbusinessstatus:(void(^)(id resPonseObj,int code))completeHandle;

//币理财管理
+(void)financialorderlistParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//币理财项目
+(void)financialitemsCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//资产流水
+(void)assettransactionParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//推荐奖励
+(void)recommendedrewardParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取投资详情邀请列表
+(void)getInviteMemberListParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取投资详情统计
+(void)getInvestTotalParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//图片上传接口
+(void)uploadByBase64Param:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//上传实名认证头像
+(void)uploadFaceParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//是否已投过资
+(void)isInvestParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//合伙人收益
+(void)partnerincomeParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//手续费收益
+(void)feeincomeParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//普通直接或间接及其他推荐成员列表
+(void)generalRecommandListParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//查询普通推荐人数统计
+(void)queryGeneralRecommandTotalParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//抽奖记录
+(void)queryMemberLotteryRecordListParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//查询累计奖励
+(void)getMemberTotalRewardMoneyParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//获取抽奖统计总数
+(void)getTotalLotteryMoneyInfoParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//查询当期排行榜
+(void)queryLotteryRankListByTimeParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//获取会员当期中奖金额
+(void)getMemberTimeRewardMoneyParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//团队管理
+(void)teamListParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//申请费用查询
+(void)getApplyMoneyParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//可选投资资金列表
+(void)queryInvestApplyMoneyListParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取用户已投资金额
+(void)getInvestMoneyParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//投资接口
+(void)investApplyMoneyListParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//手动输入投资接口
+(void)customInvestApplyParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//查询合伙人信息
+(void)queryMemberPartnerParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取签名
+(void)getUserSigParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//查询分享信息
+(void)queryInviteInfoParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//解锁记录
+(void)lockRecordParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//增加锁仓记录
+(void)queryAddLockRecordPageParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//周解锁记录
+(void)weeklockRecordParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//锁仓信息
+(void)unlockInfoParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//提币记录
+(void)withdrawrecordParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//币理财
+(void)financialitemsBHBCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


//申请成为商家
+(void)approvecertifiedbusinessParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//成为商家币种列表
+(void)approvebusinessauthdepositlist:(void(^)(id resPonseObj,int code))completeHandle;


//购买币理财
+(void)financialorderParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//用户协议
+(void)Userprotocol:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取提币地址
+(void)getassetwalletresetaddress:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//个人中心的竞猜类型条件接口
+(void)Getcoinguesstype:(void(^)(id resPonseObj,int code))completeHandle;

//个人中心投注记录
+(void)getcoinguessmemberId:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//中奖详情
+(void)getcoinguessdetail:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取抽奖场次
+(void)getLotterySession:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//申请报名抽奖
+(void)getRewardApply:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取抽奖规则
+(void)getLotteryRule:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//邀请合伙人
+(void)invitationTurnParter:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//申请成为合伙人
+(void)invitationApplyPartner:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

+(void)getPartnerInfo:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//获取投资规则
+(void)getInvestRuleInfo:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//投资收益统计
+(void)getInvestRewardTotal:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//复投记录
+(void)getRedeliveryList:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//投资收益记录
+(void)getInvestRewardList:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//团队收益
+(void)getInvestRewardTeamList:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//投资记录
+(void)getInvestRecordParams:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;



//汇特接口

//生态
+(void)shengtaiParam:(NSDictionary *)param CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
@end
