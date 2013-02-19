//
//  MainViewController.m
//  PPRevealSideViewController
//
//  Created by Deepak Bhati on 06/09/12.
//  Copyright (c) 2012 Deepak Bhati. All rights reserved.
//

#import "MainViewController.h"
#import "CityViewController.h"
#import "PopedViewController.h"
#import "UIImageView+WebCache.h"
#import "BrowserViewController_ipad.h"
#import <Twitter/Twitter.h>

#import "AppDelegate.h"
@implementation MainViewController

#define offset  80.0

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [self changeOffset:nil];
    
    // reinit the bouncing directions (should not be done in your own implementation, this is just for the sample)
    [self.revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionBottom | PPRevealSideDirectionLeft | PPRevealSideDirectionRight | PPRevealSideDirectionTop];

    _animated = YES;
    
    Infodict = [[NSMutableDictionary alloc]initWithDictionary:appDelegate.MaininfoDict];
    
    NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    NSLog(@"%@",[Infodict description]);
    
    [self SetUpView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    PPRevealSideInteractions inter1 = PPRevealSideInteractionNone;
    inter1 |= PPRevealSideInteractionContentView;
    self.revealSideViewController.panInteractionsWhenClosed = inter1;
    
    
    [self.revealSideViewController changeOffset:offset
                                   forDirection:PPRevealSideDirectionRight];
    [self.revealSideViewController changeOffset:offset
                                   forDirection:PPRevealSideDirectionLeft];

}

- (void) preloadLeft {
   
    if (!Poped) {
        Poped = [[PopedViewController alloc] initWithNibName:@"PopedViewController" bundle:nil ];
    }
    Poped.dealDelegate = self;
    [self.revealSideViewController preloadViewController:Poped
                                                 forSide:PPRevealSideDirectionLeft
                                              withOffset:_offset];

}
-(void)preLoadRight
{
    if (!c) {
        c = [[CityViewController alloc] initWithNibName:@"CityViewController" bundle:nil];
    }
    c.CityDelegate = self;
    [self.revealSideViewController preloadViewController:c
                                                 forSide:PPRevealSideDirectionRight
                                              withOffset:_offset];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(preloadLeft) object:nil];
    [self performSelector:@selector(preloadLeft) withObject:nil afterDelay:0.3];

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(preLoadRight) object:nil];
    [self performSelector:@selector(preLoadRight) withObject:nil afterDelay:0.3];
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}


- (IBAction) showLeft {
    if (!Poped) {
        Poped = [[PopedViewController alloc] initWithNibName:@"PopedViewController" bundle:nil ];
    }
    Poped.dealDelegate = self;
    [self.revealSideViewController pushViewController:Poped onDirection:PPRevealSideDirectionLeft withOffset:_offset animated:_animated];

}

- (IBAction)showRight {
    if (!c) {
        c = [[CityViewController alloc] initWithNibName:@"CityViewController" bundle:nil];
    }
    c.CityDelegate = self;
    [self.revealSideViewController pushViewController:c onDirection:PPRevealSideDirectionRight withOffset:_offset animated:_animated];
}

- (IBAction)changeOffset:(id)sender {
   // UISlider *s = (UISlider*)sender;
    //_offset = floorf(s.value);
    _offset = offset;
    //_labelOffset.text = [NSString stringWithFormat:@"Offset %.0f", _offset];
    
    [self.revealSideViewController changeOffset:_offset
                                forDirection:PPRevealSideDirectionRight];
    [self.revealSideViewController changeOffset:_offset
                                   forDirection:PPRevealSideDirectionLeft];
    [self.revealSideViewController changeOffset:_offset
                                   forDirection:PPRevealSideDirectionTop];
    [self.revealSideViewController changeOffset:_offset
                                   forDirection:PPRevealSideDirectionBottom];

}

-(void)SetUpView
{
    NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    NSLog(@"%@",[Infodict description]);
    
    DisLbl.text = [NSString stringWithFormat:@"%@",[[Infodict objectForKey:@"discount"] objectForKey:@"raw"]];
    rateLbl.text = [NSString stringWithFormat:@"%@",[[Infodict objectForKey:@"price"] objectForKey:@"raw"]];
    DealDesc.text = [Infodict objectForKey:@"title"] ;
    //cell.DaysLbl.text = [[[CategouryDataArray objectAtIndex:indexPath.row] objectForKey:@"discount"] objectForKey:@"raw"];
    
    DealName.text = [NSString stringWithFormat:@"%@ \n%@",[[Infodict objectForKey:@"source"] objectForKey:@"name"],[[Infodict objectForKey:@"business"] objectForKey:@"name"]];
    
    NSMutableArray *ar = [[Infodict objectForKey:@"business"] objectForKey:@"locations"];
    if ([ar count]>0)
    {
        NSString *address;
        
        address  = @" ";
        if ([[ar objectAtIndex:0] objectForKey:@"address"]!= [NSNull null])
            address = [address stringByAppendingString:[[ar objectAtIndex:0] objectForKey:@"address"]];
         if ([[ar objectAtIndex:0] objectForKey:@"state"]!= [NSNull null])
            address = [address stringByAppendingString:[NSString stringWithFormat:@"\n%@",[[ar objectAtIndex:0] objectForKey:@"state"]]];
         if ([[ar objectAtIndex:0] objectForKey:@"zip_code"]!= [NSNull null])
            address = [address stringByAppendingString:[NSString stringWithFormat:@",%@",[[ar objectAtIndex:0] objectForKey:@"zip_code"]]];
        
        if ([[ar objectAtIndex:0] objectForKey:@"phone"]!= [NSNull null])
            address = [address stringByAppendingString:[NSString stringWithFormat:@"\n%@",[[ar objectAtIndex:0] objectForKey:@"phone"]]];

        
        DealDesc2.text = address;
        
    }
    else
        DealDesc2.text = @"";
    
    [dealImage setImageWithURL:[NSURL URLWithString:[[Infodict objectForKey:@"images"] objectForKey:@"image_big"]]];

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd HH':'mm':'ss"];
    //end_date
    NSString *Datestr =[Infodict objectForKey:@"end_date"];
    NSDate *date = [dateFormatter dateFromString:Datestr];
    
    // NSDate *Todaydate = [NSDate date];
    
    NSTimeInterval distanceBetweenDates = [date timeIntervalSinceDate:[NSDate date]];
    int totaldays = distanceBetweenDates/86400;
    //    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",totaldays] forKey:@"totalDays"];
    //    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    DaysLbl.text = [NSString stringWithFormat:@"%d",totaldays];
    
    //cell.DaysLbl.text = [[[CategouryDataArray objectAtIndex:indexPath.row] objectForKey:@"discount"] objectForKey:@"raw"];

}



-(IBAction)DealPressed:(id)sender
{
    browerVC = [[BrowserViewController_ipad alloc]initWithNibName:@"BrowserViewController_ipad" bundle:nil];
    
    browerVC.CompanyUrl = [Infodict objectForKey:@"url"];
    [self.view addSubview:browerVC.view];
    self.view.alpha = 0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        //self.view.alpha = 0 ;
        self.view.alpha = 1;
        
     [UIView commitAnimations];
    
}



-(IBAction)twitterPressed:(id)sender
{
    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"Check out this deal: %@ %@",DealDesc.text,[Infodict objectForKey:@"url"]]];
        
        if (dealImage.image)
        {
            [tweetSheet addImage:dealImage.image];
        }
        
            [tweetSheet addURL:[NSURL URLWithString:[Infodict objectForKey:@"url"]]];
        
	    [self presentModalViewController:tweetSheet animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }

}

-(IBAction)FBPressed:(id)sender
{
    appDelegate.fbController.delegate = self;
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"FB_ID"] isEqualToString:@"##NOUSER##"])
    {
        [self.view addSubview:loadingView];

        
        DealDesc.text = [Infodict objectForKey:@"title"] ;
        //cell.DaysLbl.text = [[[CategouryDataArray objectAtIndex:indexPath.row] objectForKey:@"discount"] objectForKey:@"raw"];
        
        DealName.text = [NSString stringWithFormat:@"%@ \n%@",[[Infodict objectForKey:@"source"] objectForKey:@"name"],[[Infodict objectForKey:@"business"] objectForKey:@"name"]];

        
        [appDelegate.fbController postToFacebook:[NSString stringWithFormat:@"Check out this deal %@",[[Infodict objectForKey:@"business"] objectForKey:@"name"]]:@"http://www.yipit.com":[Infodict objectForKey:@"title"]:[[Infodict objectForKey:@"images"] objectForKey:@"image_big"] :[[Infodict objectForKey:@"images"] objectForKey:@"image_big"]:[Infodict objectForKey:@"url"]];

        //[appDelegate.fbController postToFacebook:[NSString stringWithFormat:@"Check out this deal: %@",DealDesc.text]:@"http://www.yipit.com":DealName.text:@"http://www.ajm.in/appicons/CandyEater/CandyEater.png" :@"http://www.ajm.in/appicons/CandyEater/CandyEater.png":@"http://www.yipit.com"];

    }
    else
    {
        NSLog(@"login into facebook");
        [appDelegate.fbController login];
    }

}

-(IBAction)MailPressed:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"A message from divDeal App"];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:@"fisrtMail@example.com", @"secondMail@example.com", nil];
        [mailer setToRecipients:toRecipients];
        
        UIImage *myImage = [UIImage imageNamed:@"icon.png"];
        NSData *imageData = UIImagePNGRepresentation(myImage);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"News App Icon"];
        
        NSString *emailBody =[NSString stringWithFormat:@"Check out this deal: %@ \n%@",DealDesc.text,[Infodict objectForKey:@"url"]];
        [mailer setMessageBody:emailBody isHTML:NO];
        
        // only for iPad
        // mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        
        [self presentModalViewController:mailer animated:YES];
        
        [mailer release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
}


#pragma mark - MFMailComposeController delegate


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Mail saved: you saved the email message in the Drafts folder");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send the next time the user connects to email");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Mail failed: the email message was nog saved or queued, possibly due to an error");
			break;
		default:
			NSLog(@"Mail not sent");
			break;
	}
    
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark Appdelegate.fbController Delegate Methods
-(void)FBPostedSuccessfully
{
    [loadingView removeFromSuperview];
}

-(void)FBLoggedInSuccessfully
{
	if (appDelegate.fbController.isTryingAutoLogin)
	{
		// LOAD FROM NSUserDefaults
		NSLog(@"LOGIN : LOAD FROM USER DEFAULTS");
	}
	else
	{
		NSLog(@"LOGIN : SAVE TO USER DEFAULTS");
        
        [[NSUserDefaults standardUserDefaults]setObject:appDelegate.fbController.userid forKey:@"FB_ID"];
        [[NSUserDefaults standardUserDefaults]setObject:appDelegate.fbController.username forKey:@"FB_NAME"];
        [[NSUserDefaults standardUserDefaults]setObject:appDelegate.fbController.userimage forKey:@"FB_IMAGE"];
        [[NSUserDefaults standardUserDefaults]synchronize];
		NSLog(@"%@",appDelegate.fbController.userid);
		NSLog(@"%@",appDelegate.fbController.username);
		NSLog(@"%@",appDelegate.fbController.userimage);
        
        
        [self FBPressed:nil];
	}
    
}
-(void)FBLoginFailed
{
    [loadingView removeFromSuperview];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"##NOUSER##" forKey:@"FB_ID"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
	NSLog(@"LOGIN FAILED");
	NSLog(@"%@",appDelegate.fbController.userid);
	NSLog(@"%@",appDelegate.fbController.username);
	NSLog(@"%@",appDelegate.fbController.userimage);
}
-(void)FBLoggedOutSuccessfully
{
    [loadingView removeFromSuperview];
    
	NSLog(@"LOGGED OUT");
	NSLog(@"%@",appDelegate.fbController.userid);
	NSLog(@"%@",appDelegate.fbController.username);
	NSLog(@"%@",appDelegate.fbController.userimage);
}


#pragma mark - DealDelegate
-(void)DealSelected:(NSMutableDictionary *)dealInfo
{
    [Infodict removeAllObjects];
    Infodict = [[NSMutableDictionary alloc]initWithDictionary:dealInfo];
    [self SetUpView];
    [self showLeft];
    
    if (browerVC) {
        [browerVC.view removeFromSuperview];
        browerVC = nil;
    }

}


@end
