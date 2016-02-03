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

+ (UIImage *)getPicByKey:(NSString *)key;
+ (void)setPicByKey:(NSString *)key pic:(UIImage *)pic;
+ (NSString *)getNameByKey:(NSString *)key;
+ (void)setNameByKey:(NSString *)key name:(NSString *)name;
+ (NSString *)getAvatarByKey:(NSString *)key;
+ (void)setAvatarByKey:(NSString *)key name:(NSString *)name;
+ (NSDictionary *)getInfo;
+ (void)setInfo:(NSDictionary *)info;

+ (NSString *)LanguageString:(NSUInteger)num;
+ (NSString *)CountryString:(NSUInteger)num;

@end

@protocol APIProtocol <NSObject>

- (void)didReceiveAPIResponseOf: (API *)api data: (NSDictionary *)data;
- (void)didReceiveAPIErrorOf: (API *)api data: (long)errorNo;

@end