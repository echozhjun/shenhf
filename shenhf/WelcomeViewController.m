//
//  WelcomeViewController.m
//  helloworld
//
//  Created by echo on 13-11-15.
//  Copyright (c) 2013年 echo. All rights reserved.
//

#import "WelcomeViewController.h"
#import "Reachability.h"
#import "CenterViewController.h"
#include <unistd.h>

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

CenterViewController *centerViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.view.backgroundColor = [UIColor whiteColor];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
	UIImageView *logoView = [self getLogoImage];
	logoView.center = self.view.center;
	[self.view addSubview:logoView];
}

- (UIImageView *)getLogoImage {
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
