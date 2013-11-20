//
//  CenterViewController.h
//  helloworld
//
//  Created by echo on 13-11-8.
//  Copyright (c) 2013年 echo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemViewController.h"

typedef NS_ENUM(NSInteger, CenterViewStatus) {
    CenterViewStatusGlobel = 0,
    CenterViewStatusImem = 1
};

@interface CenterViewController : UIViewController<UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (assign, nonatomic) CenterViewStatus viewStatus;

@end
