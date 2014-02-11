//
//  AppDelegate.h
//  shenhf
//
//  Created by echo on 13-11-20.
//  Copyright (c) 2013年 shenhf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) UIViewController *coverController;

@end

@protocol ParentDelegate <NSObject>

@property (strong, nonatomic) AppDelegate *delegate;

- (void) startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end
