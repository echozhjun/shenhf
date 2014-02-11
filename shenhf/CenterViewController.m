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
        self.view.backgroundColor = [UIColor whiteColor];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self
	                                         selector:@selector(reachabilityChanged:)
	                                             name:kReachabilityChangedNotification
	                                           object:nil];
    
	Reachability *reach = [Reachability reachabilityWithHostname:@"shenhf.net"];
	[reach startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)note {
	Reachability *reach = [note object];
    
	if ([reach isReachable]) {
        [self requestData:0];
	} else {
        currentPage = -1;
        [self requestData:0];
    }
}

- (void)loadCenterView {
    if (self.pageController == nil) {
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
}

-(void)gotoPageAtIndex:(NSInteger)index {
    [self.pageController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:index]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
	ItemViewController *itemView = [[ItemViewController alloc] init];
    itemView.delegate = self;
	itemView.index = index;
	itemView.data = [self requestData:index];
    [itemView initData];
	return itemView;
}

- (NSDictionary *)requestData:(NSUInteger)index {
	NSInteger pageSize = 10;
	NSInteger page = (index + 1) / pageSize + 1;
    NSLog(@"%@%d%@%d", @"current page : ", page, @" index : ", index);
	if (page != currentPage) {
        NSString *urlString= [NSString stringWithFormat:@"http://shenhf.net/rssfeed.php?pagesize=%d&page=%d", pageSize, page];
        NSLog(@"%@", urlString);
		[self request:[NSURL URLWithString:urlString] index:index];
		currentPage = page;
	}
	NSInteger i = index % pageSize;
	return [curData objectAtIndex:i];
}

- (void)request:(NSURL *)url index:(NSUInteger)index {
	[SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	op.responseSerializer = [AFJSONResponseSerializer serializer];
	[op setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
	    preData = curData;
	    curData = [responseObject objectForKey:@"ret"];
        [self loadCenterView];
	    [SVProgressHUD dismiss];
        if (self.welcomeViewController != nil) {
            [self.welcomeViewController dismissViewControllerAnimated:YES completion:nil];
        }
	} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	    NSLog(@"Error: %@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您的网络好像不太给力喔" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [SVProgressHUD dismiss];
        if (self.welcomeViewController == nil) {
            self.welcomeViewController = [[WelcomeViewController alloc] init];
        }
        [self presentViewController:self.welcomeViewController animated:YES completion:nil];
    }];
	[[NSOperationQueue mainQueue] addOperation:op];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
	if ([viewController isKindOfClass:[ItemViewController class]]) {
		NSInteger index = [(ItemViewController *)viewController index];
        index--;
        if (index == -1) {
			return nil;
		}
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
