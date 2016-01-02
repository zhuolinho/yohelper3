//
//  API.h
//  GoodLuck
//
//  Created by HoJolin on 15/8/22.
//
//

#import <Foundation/Foundation.h>
#define HOST @"http://115.29.166.167:8080"

@protocol APIProtocol;

@interface API : NSObject

@property (nonatomic) id<APIProtocol> delegate;

- (void)login:(NSString *)username password:(NSString *)password;
- (void)getMyInfo;

+ (UIImage *)getPicByKey:(NSString *)key;
+ (void)setPicByKey:(NSString *)key pic:(UIImage *)pic;
+ (NSString *)getNameByKey:(NSString *)key;
+ (void)setNameByKey:(NSString *)key name:(NSString *)name;
+ (NSString *)getAvatarByKey:(NSString *)key;
+ (void)setAvatarByKey:(NSString *)key name:(NSString *)name;
+ (NSDictionary *)getInfo;
+ (void)setInfo:(NSDictionary *)info;

@end

@protocol APIProtocol <NSObject>

- (void)didReceiveAPIResponseOf: (API *)api data: (NSDictionary *)data;
- (void)didReceiveAPIErrorOf: (API *)api data: (long)errorNo;

@end