//
//  ItemViewController.m
//  helloworld
//
//  Created by echo on 13-11-15.
//  Copyright (c) 2013年 echo. All rights reserved.
//

#import "ItemViewController.h"
#import "AFNetworking.h"

@interface ItemViewController ()

@end

@implementation ItemViewController

@synthesize index;
@synthesize data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)initData {
	NSString *title = [data objectForKey:@"title"];
    
	NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:title];
	CGRect labelsize = [attrStr boundingRectWithSize:CGSizeMake(320.f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil];
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, labelsize.size.height + 50)];
	titleLabel.text = title;
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
	titleLabel.numberOfLines = 0;
	[self.view addSubview:titleLabel];
    
	UIView *board = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height, 320, self.view.frame.size.height - titleLabel.frame.origin.y)];
	CGFloat red = (CGFloat)arc4random() / 0x100000000;
	CGFloat green = (CGFloat)arc4random() / 0x100000000;
	board.backgroundColor = [UIColor colorWithRed:red green:green blue:0 alpha:1.0f];
	[self.view addSubview:board];
    
	UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
	contentLabel.text = [data objectForKey:@"content"];
	contentLabel.textColor = [UIColor whiteColor];
	contentLabel.numberOfLines = 0;
	[board addSubview:contentLabel];
    
	UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20 + contentLabel.frame.size.height, 320, 50)];
	timeLabel.text = [data objectForKey:@"post_date"];
	timeLabel.textColor = [UIColor whiteColor];
	timeLabel.numberOfLines = 0;
	[board addSubview:timeLabel];
    
	[self.view addSubview:board];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
