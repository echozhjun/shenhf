//
//  ControlViewController.h
//  helloworld
//
//  Created by echo on 13-11-16.
//  Copyright (c) 2013年 echo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CenterViewController.h"
#import "TopViewController.h"

@interface ControlViewController : UIViewController <ParentDelegate>

@property (strong, nonatomic) AppDelegate *delegate;
@property (strong, nonatomic) TopViewController *topView;
@property (strong, nonatomic) CenterViewController *centerView;

@end
