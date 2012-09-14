//
//  MerchandiseViewController.m
//  BandApp
//
//  Created by MaDdy M on 6/9/10.
//  Copyright 2010 AJM. All rights reserved.
//

#import "BrowserViewController_ipad.h"

//#define MERCHANDISE_LINK @"http://www.hardninechoppers.com/content/store/index.html"

@implementation BrowserViewController_ipad

@synthesize url,CompanyUrl,webView,pointsRewardLable,isComeFormRewards;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	if (self.CompanyUrl!=nil) 
	{
		url = [NSURL URLWithString:[self.CompanyUrl stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
		[webView loadRequest:[NSURLRequest requestWithURL:url]];
	}
	
}





/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [super dealloc];
}

#pragma mark User Defined Functions
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[loading stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[loading startAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[loading stopAnimating];
	NSLog(@"failed");
}

-(IBAction)webViewBackPress
{
	if ([webView canGoBack]) 
	{
		[webView goBack];
	}

}
-(IBAction)backPress
{
     
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    //self.view.alpha = 0 ;
    self.view.alpha = 0;
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    [UIView commitAnimations];
	
}


@end
