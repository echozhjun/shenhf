//
//  Data.h
//  shenhf
//
//  Created by echo on 13-12-6.
//  Copyright (c) 2013年 shenhf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSDate   *time;
@property (strong, nonatomic) NSString *tag;

+ (Data*)next;

@end
