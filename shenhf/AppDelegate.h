//
//  AppDelegate.h
//  shenhf
//
//  Created by echo on 13-11-20.
//  Copyright (c) 2013年 shenhf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "CenterViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CenterViewController *viewController;
@property (strong, nonatomic) UIView *coverView;

@end

@protocol ParentDelegate <NSObject>

@property (strong, nonatomic) AppDelegate *delegate;

- (void) startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end
