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
#import <WeiboSDK/WeiboSDK.h>

@interface ItemViewController ()
@property (nonatomic, strong) HYActivityView *activityView;

@end

@implementation ItemViewController

@synthesize index;
@synthesize data;

NSArray *colors;
Weibo *weibo;

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
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, [self heightForText:title])];
    titleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, [self heightForText:title])];
	titleLabel.text = title;
	titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 0;
    [titleView addSubview:titleLabel];
	[self.view addSubview:titleView];
    
    NSString *content = [data objectForKey:@"content"];
    NSString *parten = @"<a.*a>";
    NSError* error = NULL;
    
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:nil error:&error];
    
    NSArray* match = [reg matchesInString:content options:NSMatchingCompleted range:NSMakeRange(0, [content length])];
    
    EGOImageView *egoImageView;
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
                        egoImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 280)];
                        currentHeight = 260;
                        [egoImageView setImageURL:[NSURL URLWithString:img]];
                    }
                }
            }
            
            content = [content stringByReplacingOccurrencesOfString:atag withString:@""];
        }  
    }
    NSInteger labelHeight = [self heightForText:content];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentHeight, 300, labelHeight)];
	contentLabel.text = content;
	contentLabel.textColor = [UIColor whiteColor];
	contentLabel.numberOfLines = 0;
    
    
    NSInteger bottomY = self.view.frame.size.height - 50;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomY, 320, 50)];
    NSInteger colorIndex = index % 10;
    bottomView.backgroundColor = [colors objectAtIndex:colorIndex];
    bottomView.clipsToBounds = YES;
    
    CALayer *topBorder = [CALayer layer];
    topBorder.borderColor = [UIColor lightTextColor].CGColor;
    topBorder.borderWidth = 1;
    topBorder.frame = CGRectMake(-2, 0, CGRectGetWidth(bottomView.frame) + 5, CGRectGetHeight(bottomView.frame)+1);
    
    [bottomView.layer addSublayer:topBorder];
    
	UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 35)];
	timeLabel.text = [data objectForKey:@"post_date"];
	timeLabel.textColor = [UIColor whiteColor];
	timeLabel.numberOfLines = 0;
    timeLabel.textAlignment = UITextAlignmentCenter;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImage = [UIImage imageNamed:@"share.png"];
    [btn setImage:btnImage forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(10, 10, 30, 30)];
    [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@">" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize: 30];
    [nextBtn setFrame:CGRectMake(280, 0, 42, 42)];
    [nextBtn addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger height = self.view.frame.size.height - titleLabel.frame.size.height - 70;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.size.height + 20, 320, height)];
    
	scrollView.backgroundColor = [colors objectAtIndex:colorIndex];
    
    [scrollView setScrollEnabled:YES];
    NSInteger contentHeight = 0;
    if (egoImageView != nil) {
        contentHeight = 280;
    }
    contentHeight = contentHeight + labelHeight + 50;
    [scrollView setContentSize:CGSizeMake(320, contentHeight)];
    if (egoImageView != nil) {
        [scrollView addSubview:egoImageView];
    }
    [scrollView addSubview:contentLabel];
    
	[self.view addSubview:scrollView];
    
    [bottomView addSubview:timeLabel];
    [bottomView addSubview:btn];
    [bottomView addSubview:nextBtn];
    [self.view addSubview:bottomView];
}

- (void)nextButtonClicked:(UIButton *)button
{
    [self.delegate gotoPageAtIndex:index + 1];
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

- (NSString *)shareContent {
    NSString *title = [data objectForKey:@"title"];
    NSString *content = [data objectForKey:@"content"];
    return [NSString stringWithFormat:@"%@\n神回复:%@", title, content];
}

- (void) sendToWeixinSession
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    
    req.text = [self shareContent];
    req.bText = YES;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

- (void) sendToWeixinFriend
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = [self shareContent];
    req.bText = YES;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

- (void) sendToQQ
{
    QQApiObject *_qqApiObject = [QQApiTextObject objectWithText:[self shareContent]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:_qqApiObject];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void) sendToWeibo
{
    if (weibo == nil) {
        weibo = [[Weibo alloc] initWithAppKey:@"3554647022" withAppSecret:@"ab02084fcf72060c1f19355c8cf01f45"];
        [Weibo setWeibo:weibo];
    }
    if (![Weibo.weibo isAuthenticated]) {
        [Weibo.weibo authorizeWithCompleted:^(WeiboAccount *account, NSError *error) {
            if (!error) {
                NSLog(@"成功登录，登录名: %@", account.user.screenName);
                [self sendWeibo];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"登录失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
        }];
    } else {
        [self sendWeibo];
    }
    
}

- (void) sendWeibo {
    [weibo newStatus:[self shareContent] pic:nil completed:^(Status *status, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"分享到微博失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"分享到微博成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
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


@end
