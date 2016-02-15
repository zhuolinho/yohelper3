//
//  API.h
//  GoodLuck
//
//  Created by HoJolin on 15/8/22.
//
//

#import <Foundation/Foundation.h>

@protocol APIProtocol;

@interface API : NSObject

@property (nonatomic) id<APIProtocol> delegate;

- (void)login:(NSString *)username password:(NSString *)password;
- (void)getMyInfo;
- (void)getMyCollectionTeachers;
- (void)getTeachersFromJobTag;
- (void)getTopicNews;
- (void)setAvatar:(UIImage *)img;
- (void)setNickname:(NSString *)nickname;
- (void)setAddress:(NSString *)address;
- (void)setEmail:(NSString *)email;
- (void)setPassword:(NSString *)newPass oldPass:(NSString *)oldPass;
- (void)setGender:(NSString *)gender;
- (void)findPassword:(NSString *)phone;
- (void)sendAuthCode:(NSString *)phone;
- (void)checkAuthCode:(NSString *)phone authCode:(NSString *)authCode;
- (void)registerAction:(NSString *)username phone:(NSString *)phone password:(NSString *)password authCode:(NSString *)authCode;
- (void)authForWeixin:(NSString *)weixin avatarURL:(NSString *)avatarURL nickname:(NSString *)nickname gender:(NSString *)gender;
- (void)getMyVouchers;
- (void)getTreasures;
- (void)buyTreasure:(NSString *)tid addressee:(NSString *)addressee phone:(NSString *)phone address:(NSString *)address;
- (void)addLotteryValueWithInviteCode:(NSString *)inviteCode;
- (void)addPhoneWithVerification:(NSString *)phone verifyCode:(NSString *)verifyCode;
- (void)addLotteryRecord;
- (void)addCollectionTeacher:(NSString *)uid;
- (void)deleteCollectionTeacher:(NSString *)uid;

+ (UIImage *)getPicByKey:(NSString *)key;
+ (void)setPicByKey:(NSString *)key pic:(UIImage *)pic;
+ (NSString *)getNameByKey:(NSString *)key;
+ (void)setNameByKey:(NSString *)key name:(NSString *)name;
+ (NSString *)getAvatarByKey:(NSString *)key;
+ (void)setAvatarByKey:(NSString *)key name:(NSString *)name;
+ (NSString *)getUidByKey:(NSString *)key;
+ (void)setUidByKey:(NSString *)key uid:(NSString *)uid;
+ (NSDictionary *)getInfo;
+ (void)setInfo:(NSDictionary *)info;
+ (NSArray *)getChief;
+ (void)setChief:(NSArray *)Chief;

+ (NSString *)LanguageString:(NSUInteger)num;
+ (NSString *)CountryString:(NSUInteger)num;

@end

@protocol APIProtocol <NSObject>

- (void)didReceiveAPIResponseOf: (API *)api data: (NSDictionary *)data;
- (void)didReceiveAPIErrorOf: (API *)api data: (long)errorNo;

@end