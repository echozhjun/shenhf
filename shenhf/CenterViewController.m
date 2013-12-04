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
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "Reachability.h"

@interface CenterViewController ()

@end

@implementation CenterViewController

NSArray *preData;
NSArray *curData;
NSArray *nextData;
NSInteger currentPage = -1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
	                                         selector:@selector(reachabilityChanged:)
	                                             name:kReachabilityChangedNotification
	                                           object:nil];
    
    [self setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    self.welcomeView = [[WelcomeViewController alloc] init];
    [self presentViewController:self.welcomeView animated:YES completion:nil];
    
	Reachability *reach = [Reachability reachabilityWithHostname:@"shenhf.net"];
    
	reach.reachableBlock = ^(Reachability *reachability) {
		dispatch_async(dispatch_get_main_queue(), ^{
		    sleep(1);
            NSLog(@"reachable");
		    [self requestData:0];
		});
	};
    
	reach.unreachableBlock = ^(Reachability *reachability) {
		dispatch_async(dispatch_get_main_queue(), ^{
		});
	};
    
	[reach startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)note {
	Reachability *reach = [note object];
    
	if ([reach isReachable]) {
        [self requestData:0];
	}
	else {
        [self presentViewController:self.welcomeView animated:YES completion:nil];
	}
}

- (void)loadCenterView {
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

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
	ItemViewController *itemView = [[ItemViewController alloc] init];
	itemView.index = index;
	itemView.data = [self requestData:index];
    [itemView initData];
	return itemView;
}

- (NSDictionary *)requestData:(NSUInteger)index {
	NSInteger pageSize = 10;
	NSInteger page = (index + 1) / pageSize + 1;
	if (page != currentPage) {
		[self request:[NSURL URLWithString:[NSString stringWithFormat:@"http://shenhf.net/rssfeed.php?pagesize=%d&page=%d", pageSize, page]]];
		currentPage = page;
	}
	NSInteger i = (index + 1) % pageSize;
	return [curData objectAtIndex:i];
}

- (void)request:(NSURL *)url {
	[SVProgressHUD show];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	op.responseSerializer = [AFJSONResponseSerializer serializer];
	[op setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
	    preData = curData;
	    curData = [responseObject objectForKey:@"ret"];
	    [SVProgressHUD dismiss];
        [self loadCenterView];
        [self.welcomeView dismissViewControllerAnimated:YES completion:nil];
	} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	    NSLog(@"Error: %@", error);
	}];
	[[NSOperationQueue mainQueue] addOperation:op];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
	if ([viewController isKindOfClass:[ItemViewController class]]) {
		NSInteger index = [(ItemViewController *)viewController index];
		if (index == 0) {
			return nil;
		}
		index--;
		return [self viewControllerAtIndex:index];
	}
	return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
	if ([viewController isKindOfClass:[ItemViewController class]]) {
		NSInteger index = [(ItemViewController *)viewController index];
		index++;
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

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
