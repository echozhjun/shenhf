//
//  ItemViewController.h
//  helloworld
//
//  Created by echo on 13-11-15.
//  Copyright (c) 2013年 echo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterViewController.h"
#import "TencentOpenAPI/QQApiInterface.h"

@interface ItemViewController : UIViewController<QQApiInterfaceDelegate>

@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSDictionary *data;
@property (strong, nonatomic) id delegate;

- (void)initData;

@end
