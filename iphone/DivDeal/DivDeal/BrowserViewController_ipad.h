//
//  MerchandiseViewController.h
//  BandApp
//
//  Created by MaDdy M on 6/9/10.
//  Copyright 2010 AJM. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BrowserViewController_ipad : UIViewController<UIWebViewDelegate> 
{
	
	IBOutlet UIActivityIndicatorView *loading;
	IBOutlet UIWebView *webView;
	NSURL *url;
	BOOL isComeFormRewards;
	NSString *CompanyUrl;
	
	IBOutlet UILabel *pointsRewardLable;
}

@property BOOL isComeFormRewards;
@property (nonatomic,retain) IBOutlet UILabel *pointsRewardLable;
@property (nonatomic,retain) IBOutlet UIWebView *webView;
@property (nonatomic,retain) NSURL *url;
@property(nonatomic,retain)NSString *CompanyUrl;

-(IBAction)backPress;
-(IBAction)webViewBackPress;
@end
