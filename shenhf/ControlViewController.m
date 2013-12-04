//
//  ControlViewController.m
//  helloworld
//
//  Created by echo on 13-11-16.
//  Copyright (c) 2013年 echo. All rights reserved.
//

#import "ControlViewController.h"
#import "GMGridView.h"
#import "GMGridViewLayoutStrategies.h"
#import "CenterViewController.h"
#import "TopViewController.h"

@interface ControlViewController () <GMGridViewDataSource, GMGridViewActionDelegate>
{
    __gm_weak GMGridView *_gmGridView;
}

@end

@implementation ControlViewController

@synthesize delegate = _delegate;
NSInteger currentIndex = -1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.style = GMGridViewStylePush;
    gmGridView.itemSpacing = 5;
    gmGridView.minEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    gmGridView.centerGrid = YES;
    gmGridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontal];
    [self.view addSubview:gmGridView];
    _gmGridView = gmGridView;
    
    [self computeViewFrames];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _gmGridView.dataSource = self;
    _gmGridView.actionDelegate = self;
    
    _gmGridView.mainSuperView = self.view;
    
}

- (void)computeViewFrames
{
    CGSize itemSize = [self GMGridView:_gmGridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    CGSize minSize  = CGSizeMake(itemSize.width  + _gmGridView.minEdgeInsets.right + _gmGridView.minEdgeInsets.left,
                                 itemSize.height + _gmGridView.minEdgeInsets.top   + _gmGridView.minEdgeInsets.bottom);
    
    CGFloat top = self.view.bounds.size.height - 70;
    
    _gmGridView.frame =  CGRectMake(0, top, self.view.bounds.size.width , minSize.height);
}

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isLogin = [userDefaults objectForKey:@"ISLOGIN"];
    if ([isLogin isEqualToString:@"logined"]) {
        if (currentIndex == position) {
            return;
        }
        currentIndex = position;
        if (position == 0) {
            
        }
        if (position == 1) {
            
        }
        
    } else {
        
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return 3;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(80, 60);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = [UIColor orangeColor];
        cell.contentView = view;
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 8;
        if (index == 0) {
            
        }
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (index == 0) {
        label.text = @"Summ";
    }
    if (index == 1) {
        label.text = @"Item";
    }
    if (index == 2) {
        label.text = @"Todo";
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.highlightedTextColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [cell.contentView addSubview:label];
    
    return cell;
}

@end
