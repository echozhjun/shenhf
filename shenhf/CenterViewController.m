//
//  CenterViewController.m
//  helloworld
//
//  Created by echo on 13-11-8.
//  Copyright (c) 2013年 echo. All rights reserved.
//

#import "CenterViewController.h"
#import "ItemViewController.h"
#import "WelcomeViewController.h"

@interface CenterViewController ()

@end

@implementation CenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
	                                                    forKey:UIPageViewControllerOptionSpineLocationKey];
	self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    
	self.pageController.dataSource = self;
	[[self.pageController view] setFrame:[[self view] bounds]];
    
	[self.pageController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
	[self addChildViewController:self.pageController];
	[[self view] addSubview:[self.pageController view]];
	[self.pageController didMoveToParentViewController:self];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    
    ItemViewController *itemView = [[ItemViewController alloc] init];
    itemView.index = index;
    return itemView;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[ItemViewController class]]) {
        NSInteger index = [(ItemViewController *) viewController index];
        if (index == 0) {
            return nil;
        }
        index --;
        return [self viewControllerAtIndex:index];
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
	if ([viewController isKindOfClass:[ItemViewController class]]) {
        NSInteger index = [(ItemViewController *) viewController index];
        index ++;
        return [self viewControllerAtIndex:index];
    }
    return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
	return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskPortrait;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
