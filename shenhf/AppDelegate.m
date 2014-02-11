//
//  AppDelegate.m
//  shenhf
//
//  Created by echo on 13-11-20.
//  Copyright (c) 2013年 shenhf. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import "CenterViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "TencentOpenAPI/QQApiInterface.h"
#import "sdkCall.h"
#import <WeiboSDK/WeiboSDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	   
    self.coverView = [self getCoverView];
    
    [self.window addSubview:self.coverView];
    [self.window bringSubviewToFront:self.coverView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    self.coverView.alpha = 0.99;
    [UIView commitAnimations];
    
    [self.window makeKeyAndVisible];
    
    [WXApi registerApp:@"wx47598b446dc27a2f"];
    
    [sdkCall getinstance];
    
    return YES;
}

- (UIView *)getCoverView {
    UIView *view = [[UIView alloc] initWithFrame:self.window.frame];
    view.backgroundColor = [UIColor whiteColor];
	UIImage *logo = [self scaleImage:[UIImage imageNamed:@"logo.jpg"] toScale:0.5];
	UIImageView *logoView = [[UIImageView alloc] initWithImage:logo];
	logoView.contentMode = UIViewContentModeCenter;
    logoView.center = view.center;
    [view addSubview:logoView];
	return view;
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
	UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
	[image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	return scaledImage;
}

-(void) onReq:(BaseReq*)req
{

}

-(void) onResp:(BaseResp*)resp
{

}


- (void) startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [self.window sendSubviewToBack:self.coverView];
    if (self.viewController == nil) {
        self.viewController = [[CenterViewController alloc] init];
        self.window.rootViewController = self.viewController;
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"applicationWillResignActive");
    
    [self.window bringSubviewToFront:self.coverView];
    
    NSDate* expireDate = [[NSDate date] dateByAddingTimeInterval:180];
    [[NSUserDefaults standardUserDefaults] setObject:expireDate forKey:@"expire"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
    
    [self.window sendSubviewToBack:self.coverView];
    
    NSDate* date = [[NSUserDefaults standardUserDefaults] objectForKey:@"expire"];
    if(date && [[[NSDate date] earlierDate:date] isEqualToDate:date]) {
        [self refreshApp];
    }
}

- (void) refreshApp {
    [self.viewController refresh];
}


- (void)applicationWillTerminate:(UIApplication *)application
{

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    [QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)[ItemViewController class]];
    
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)[ItemViewController class]];
    
    return [WXApi handleOpenURL:url delegate:self];
}

@end
