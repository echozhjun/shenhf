//
//  WelcomeViewController.m
//  helloworld
//
//  Created by echo on 13-11-15.
//  Copyright (c) 2013年 echo. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		CGFloat red = (CGFloat)arc4random() / 0x100000000;
        CGFloat green = (CGFloat)arc4random() / 0x100000000;
        CGFloat blue = (CGFloat)arc4random() / 0x100000000;
        self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
	}
	return self;
}



- (void)viewDidLoad {
	[super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isLogin = [userDefaults objectForKey:@"ISLOGIN"];
    if ([isLogin isEqualToString:@"logined"]) {
        
    }
    
    UIView *logoBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    logoBack.center = self.view.center;
    logoBack.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:logoBack];
    
    UIImageView *logoView = [self getLogoImage];
    logoView.center = self.view.center;
    [self.view addSubview:logoView];
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1.0f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"suckEffect";
    [[self.view.superview layer] addAnimation:animation forKey:nil];
    
    [self.view removeFromSuperview];
    
}

- (UIImageView *)getLogoImage{
    UIImage *logo = [self scaleImage:[UIImage imageNamed:@"logo.jpg"] toScale:0.5];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:logo];
    logoView.contentMode = UIViewContentModeCenter;
    return logoView;
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
	UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
	[image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	return scaledImage;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
