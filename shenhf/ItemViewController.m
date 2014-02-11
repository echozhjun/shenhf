//
//  ItemViewController.m
//  helloworld
//
//  Created by echo on 13-11-15.
//  Copyright (c) 2013年 echo. All rights reserved.
//

#import "ItemViewController.h"
#import "AFNetworking.h"
#import "EGOImageView.h"
#import "WXApi.h"
#import "HYActivityView.h"
#import "TencentOpenAPI/QQApiInterface.h"

@interface ItemViewController ()
@property (nonatomic, strong) HYActivityView *activityView;

@end

@implementation ItemViewController

@synthesize index;
@synthesize data;

NSArray *colors;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIColor *color0 = [UIColor colorWithRed:80/255.0 green:222/255.0 blue:141/255.0 alpha:0.8f];
        UIColor *color1 = [UIColor colorWithRed:255/255.0 green:38/255.0 blue:76/255.0 alpha:0.8f];
        UIColor *color2 = [UIColor colorWithRed:11/255.0 green:161/255.0 blue:248/255.0 alpha:0.8f];
        UIColor *color3 = [UIColor colorWithRed:11/255.0 green:226/255.0 blue:248/255.0 alpha:0.8f];
        UIColor *color4 = [UIColor colorWithRed:11/255.0 green:158/255.0 blue:64/255.0 alpha:0.8f];
        UIColor *color5 = [UIColor colorWithRed:235/255.0 green:85/255.0 blue:76/255.0 alpha:0.8f];
        UIColor *color6 = [UIColor colorWithRed:211/255.0 green:179/255.0 blue:140/255.0 alpha:0.8f];
        UIColor *color7 = [UIColor colorWithRed:11/255.0 green:161/255.0 blue:248/255.0 alpha:0.8f];
        UIColor *color8 = [UIColor colorWithRed:255/255.0 green:144/255.0 blue:31/255.0 alpha:0.8f];
        UIColor *color9 = [UIColor colorWithRed:255/255.0 green:105/255.0 blue:100/255.0 alpha:0.8f];
        
        colors = [NSArray arrayWithObjects:color0, color1, color2, color3, color4, color5, color6, color7, color8, color9, nil];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)initData {
	NSString *title = [data objectForKey:@"title"];
    
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, [self heightForText:title])];
	titleLabel.text = title;
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
	titleLabel.numberOfLines = 0;
	[self.view addSubview:titleLabel];
    
    NSInteger height = self.view.frame.size.height - titleLabel.frame.size.height - 20;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.size.height + 20, 320, height)];

    NSInteger colorIndex = index % 10;
	scrollView.backgroundColor = [colors objectAtIndex:colorIndex];
    
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 9999)];
	[self.view addSubview:scrollView];
    
    NSString *content = [data objectForKey:@"content"];
    NSString *parten = @"<a.*a>";
    NSError* error = NULL;
    
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:nil error:&error];
    
    NSArray* match = [reg matchesInString:content options:NSMatchingCompleted range:NSMakeRange(0, [content length])];
    
    NSInteger currentHeight = 0;
    if (match.count != 0)
    {
        for (NSTextCheckingResult *matc in match)
        {
            NSRange range = [matc range];
            NSString *atag = [content substringWithRange:range];
            
            NSRegularExpression *imgReg = [NSRegularExpression regularExpressionWithPattern:@"src=\"(.*?)\"" options:nil error:&error];
            
            match = [imgReg matchesInString:atag options:NSMatchingCompleted range:NSMakeRange(0, [atag length])];
            
            if (match.count != 0)
            {
                for (NSTextCheckingResult *mat in match)
                {
                    NSRange r1 = [mat rangeAtIndex:1];
                    
                    if (!NSEqualRanges(r1, NSMakeRange(NSNotFound, 0))) {
                        
                        NSString *img = [atag substringWithRange:r1];
                        img = [img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        EGOImageView *egoImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 280)];
                        currentHeight = 260;
                        [egoImageView setImageURL:[NSURL URLWithString:img]];
                        [scrollView addSubview:egoImageView];
                    }
                }
            }
            
            content = [content stringByReplacingOccurrencesOfString:atag withString:@""];
        }  
    }
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, currentHeight, 320, [self heightForText:content])];

	contentLabel.text = content;
	contentLabel.textColor = [UIColor whiteColor];
	contentLabel.numberOfLines = 0;
	[scrollView addSubview:contentLabel];
    
    
	UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, currentHeight + [self heightForText:content], 320, 35)];
	timeLabel.text = [data objectForKey:@"post_date"];
	timeLabel.textColor = [UIColor whiteColor];
	timeLabel.numberOfLines = 0;
    timeLabel.textAlignment = UITextAlignmentCenter;
	[scrollView addSubview:timeLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImage = [UIImage imageNamed:@"share.png"];
    [btn setImage:btnImage forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(290, currentHeight + [self heightForText:content], 27, 27)];
    [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn];
    
}

- (float)heightForText:(NSString *)value
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:18.0f] constrainedToSize:CGSizeMake(320, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    float height = sizeToFit.height;
    if (height < 80.0f) {
        return 80.0f;
    }
    return sizeToFit.height;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)buttonClicked:(UIButton *)button
{
    if (!self.activityView) {
        self.activityView = [[HYActivityView alloc]initWithTitle:@"分享到" referView:self.view];
        
        self.activityView.numberOfButtonPerLine = 6;
        
        ButtonView *bv = [[ButtonView alloc]initWithText:@"新浪微博" image:[UIImage imageNamed:@"share_platform_sina"] handler:^(ButtonView *buttonView){
            [self sendToWeibo];
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"QQ" image:[UIImage imageNamed:@"share_platform_qqfriends"] handler:^(ButtonView *buttonView){
            [self sendToQQ];
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"微信" image:[UIImage imageNamed:@"share_platform_wechat"] handler:^(ButtonView *buttonView){
            [self sendToWeixinSession];
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"微信朋友圈" image:[UIImage imageNamed:@"share_platform_wechattimeline"] handler:^(ButtonView *buttonView){
            [self sendToWeixinFriend];
        }];
        [self.activityView addButtonView:bv];
        
    }
    
    [self.activityView show];
    
}

- (void) sendToWeixinSession
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    NSString *title = [data objectForKey:@"title"];
    NSString *content = [data objectForKey:@"content"];
    req.text = [NSString stringWithFormat:@"%@\n神回复:%@", title, content];
    req.bText = YES;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

- (void) sendToWeixinFriend
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    NSString *title = [data objectForKey:@"title"];
    NSString *content = [data objectForKey:@"content"];
    req.text = [NSString stringWithFormat:@"%@\n神回复:%@", title, content];
    req.bText = YES;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

- (void) sendToQQ
{
    NSString *title = [data objectForKey:@"title"];
    NSString *content = [data objectForKey:@"content"];
    QQApiObject *_qqApiObject = [QQApiTextObject objectWithText:[NSString stringWithFormat:@"%@\n神回复:%@", title, content]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:_qqApiObject];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void) sendToWeibo
{
    NSString *title = [data objectForKey:@"title"];
    NSString *content = [data objectForKey:@"content"];
}


+ (void)onReq:(QQBaseReq *)req
{

}

+ (void)onResp:(QQBaseResp *)resp
{

}

- (void)isOnlineResponse:(NSDictionary *)response
{
    
}


- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

@end
