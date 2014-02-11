//
//  Data.m
//  shenhf
//
//  Created by echo on 13-12-6.
//  Copyright (c) 2013年 shenhf. All rights reserved.
//

#import "Data.h"
#import "AFNetworking.h"

@implementation Data

@synthesize title;
@synthesize content;
@synthesize time;
@synthesize tag;

NSArray *preData;
NSArray *curData;
NSArray *nextData;

+ (Data *)next {
	return nil;
}

- (NSDictionary *)requestData:(NSUInteger)index {
    NSInteger pageSize         = 10;
    NSInteger page             = (index + 1) / pageSize + 1;
    [self request:[NSURL URLWithString:[NSString stringWithFormat:@"http://shenhf.net/rssfeed.php?pagesize=%d&page=%d", pageSize, page]]];
    NSInteger i                = (index + 1) % pageSize;
	return [curData objectAtIndex:i];
}

- (void)request:(NSURL *)url {
    NSURLRequest *request      = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer      = [AFJSONResponseSerializer serializer];
	[op setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
    preData                    = curData;
    curData                    = [responseObject objectForKey:@"ret"];
	} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	    NSLog(@"Error: %@", error);
	}];
	[[NSOperationQueue mainQueue] addOperation:op];
}

@end
