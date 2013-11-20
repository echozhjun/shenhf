//
//  WelcomeViewController.h
//  helloworld
//
//  Created by echo on 13-11-15.
//  Copyright (c) 2013年 echo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface WelcomeViewController : UIViewController<ParentDelegate>

@property (strong, nonatomic) AppDelegate *delegate;

@end
