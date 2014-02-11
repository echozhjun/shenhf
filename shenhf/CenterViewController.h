//
//  CenterViewController.h
//  helloworld
//
//  Created by echo on 13-11-8.
//  Copyright (c) 2013年 echo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemViewController.h"
#import "WelcomeViewController.h"

typedef NS_ENUM(NSInteger, CenterViewStatus) {
    CenterViewStatusGlobel = 0,
    CenterViewStatusItem = 1
};

@interface CenterViewController : UIViewController<UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) WelcomeViewController *welcomeViewController;
@property (assign, nonatomic) CenterViewStatus viewStatus;

@end
