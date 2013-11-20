//
//  AppDelegate.h
//  shenhf
//
//  Created by echo on 13-11-20.
//  Copyright (c) 2013年 shenhf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) UIViewController *coverController;

@end

@protocol ParentDelegate <NSObject>

@property (strong, nonatomic) AppDelegate *delegate;

@end
