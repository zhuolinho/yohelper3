//
//  API.m
//  GoodLuck
//
//  Created by HoJolin on 15/8/22.
//
//

#import "API.h"

static NSMutableDictionary *picDic;
static NSMutableDictionary *nameDic;
static NSMutableDictionary *avatarDic;
static NSDictionary *myInfo;

@implementation API

- (void)login:(NSString *)username password:(NSString *)password {
    [self post:@"auth.action" dic:@{@"username": username, @"password": password}];
}

- (void)getMyInfo {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *yo_token = [ud objectForKey:@"yo_token"];
    [self post:@"getMyInfo.action" dic:@{@"token": yo_token}];
}

- (void)getMyCollectionTeachers {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *yo_token = [ud objectForKey:@"yo_token"];
    [self post:@"getMyCollectionTeachers.action" dic:@{@"token": yo_token}];
}

- (void)getTeachersFromJobTag {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *yo_token = [ud objectForKey:@"yo_token"];
    [self post:@"getTeachersFromJobTag.action" dic:@{@"token": yo_token}];
}

- (void)post:(NSString *)action dic:(NSDictionary *)dic {
    NSString *str = [NSString stringWithFormat:@"%@/yozaii2/api/%@", HOST, action];
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSMutableArray *parametersArray = [[NSMutableArray alloc]init];
    for (NSString *key in [dic allKeys]) {
        id value = [dic objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }     
    }
    NSString *dicString = [parametersArray componentsJoinedByString:@"&"];
    NSData *data = [dicString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil) {
            NSError *err = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
            if(jsonObject != nil && err == nil){
                if([jsonObject isKindOfClass:[NSDictionary class]]){
                    NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
                    long errNo = [deserializedDictionary[@"errno"] integerValue];
                    if (errNo == 0) {
                        if (self->_delegate) {
                            [self->_delegate didReceiveAPIResponseOf:self data:deserializedDictionary];
                        }
                    }
                    else {
                        if (self->_delegate) {
                            [self->_delegate didReceiveAPIErrorOf:self data:errNo];
                        }
                    }
                }else if([jsonObject isKindOfClass:[NSArray class]]){
                    if (self->_delegate) {
                        [self->_delegate didReceiveAPIErrorOf:self data:-999];
                    }
                }
            }
            else if(err != nil){
                if (self->_delegate) {
                    [self->_delegate didReceiveAPIErrorOf:self data:-777];
                }
            }
        }
        else {
            if (self->_delegate) {
                [self->_delegate didReceiveAPIErrorOf:self data:-888];
            }
        }
    }];
}

+ (UIImage *)getPicByKey:(NSString *)key {
    if (picDic != nil) {
        return [picDic objectForKey:key];
    }
    return nil;
}

+ (void)setPicByKey:(NSString *)key pic:(UIImage *)pic {
    if (picDic == nil) {
        picDic = [[NSMutableDictionary alloc]init];
    }
    [picDic setValue:pic forKey:key];
}

+ (NSString *)getNameByKey:(NSString *)key {
    if (nameDic != nil) {
        return [nameDic objectForKey:key];
    }
    return nil;
}

+ (void)setNameByKey:(NSString *)key name:(NSString *)name {
    if (nameDic == nil) {
        nameDic = [[NSMutableDictionary alloc]init];
    }
    [nameDic setValue:name forKey:key];
}

+ (NSString *)getAvatarByKey:(NSString *)key {
    if (avatarDic != nil) {
        return [avatarDic objectForKey:key];
    }
    return nil;
}

+ (void)setAvatarByKey:(NSString *)key name:(NSString *)name {
    if (avatarDic == nil) {
        avatarDic = [[NSMutableDictionary alloc]init];
    }
    [avatarDic setValue:name forKey:key];
}

+ (void)setInfo:(NSDictionary *)info {
    myInfo = info;
}

+ (NSDictionary *)getInfo {
    return myInfo;
}

+ (NSString *)LanguageString:(NSUInteger)num {
    return @[@"All", @"English", @"French", @"Japanese", @"Korean", @"Spanish", @"Russian", @"German", @"Chinese"][num];
}

+ (NSString *)CountryString:(NSUInteger)num {
    return @[@"Other", @"US", @"UK", @"Japan", @"Korea", @"Spain", @"Italy", @"Germany", @"France", @"Belgium", @"Philippine", @"Malaysia", @"Switzerland", @"Australia", @"Thailand", @"Sweden", @"India", @"Iran", @"Russia", @"Other"][num];
}

@end
