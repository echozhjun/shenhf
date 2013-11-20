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

- (void)viewWillAppear:(BOOL)animated {
	[self request:[NSURL URLWithString:[NSString stringWithFormat:@"http://shenhf.net/rssfeed.php?pagesize=1&page=%d", index]]];
}

- (void)request:(NSURL *)url {
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	op.responseSerializer = [AFJSONResponseSerializer serializer];
	[op setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
	    NSLog(@"DATA: %@", responseObject);
	    [self display:responseObject];
	} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	    NSLog(@"Error: %@", error);
	}];
	[[NSOperationQueue mainQueue] addOperation:op];
}

- (void)display:(NSDictionary *)data {
	NSArray *results = [data objectForKey:@"ret"];
	NSDictionary *result = [results objectAtIndex:0];
    
	UILabel *itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
	itemNameLabel.text = [result objectForKey:@"title"];
	itemNameLabel.textColor = [UIColor whiteColor];
	itemNameLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
	itemNameLabel.numberOfLines = 0;
	[self.view addSubview:itemNameLabel];
    
	UIView *board = [[UIView alloc] initWithFrame:CGRectMake(0, itemNameLabel.frame.origin.y + 50, 320, self.view.frame.size.height - itemNameLabel.frame.origin.y)];
	CGFloat red = (CGFloat)arc4random() / 0x100000000;
	CGFloat green = (CGFloat)arc4random() / 0x100000000;
	board.backgroundColor = [UIColor colorWithRed:red green:green blue:0 alpha:1.0f];
	[self.view addSubview:board];
    
	UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
	contentLabel.text = [result objectForKey:@"content"];
	contentLabel.textColor = [UIColor whiteColor];
	contentLabel.numberOfLines = 0;
    [board addSubview:contentLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20 + contentLabel.frame.size.height, 320, 50)];
	timeLabel.text = [result objectForKey:@"post_date"];
	timeLabel.textColor = [UIColor whiteColor];
	timeLabel.numberOfLines = 0;
    [board addSubview:timeLabel];
    
	[self.view addSubview:itemNameLabel];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
