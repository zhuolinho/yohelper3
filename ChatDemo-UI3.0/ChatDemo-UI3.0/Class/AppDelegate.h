/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "ApplyViewController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

@protocol AlipayDelegate <NSObject>

- (void)AlipayRequestBack:(NSDictionary *)result;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate, IChatManagerDelegate>
{
    EMConnectionState _connectionState;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainController;
@property id<AlipayDelegate, WXApiDelegate> payVC;

@end
