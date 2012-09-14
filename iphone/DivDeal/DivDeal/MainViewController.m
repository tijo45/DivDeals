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
    
    [self changeOffset:nil];
    
    // reinit the bouncing directions (should not be done in your own implementation, this is just for the sample)
    [self.revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionBottom | PPRevealSideDirectionLeft | PPRevealSideDirectionRight | PPRevealSideDirectionTop];

    _animated = YES;
    
    Infodict = [[NSMutableDictionary alloc]initWithDictionary:[[[NSUserDefaults standardUserDefaults]objectForKey:@"deal"]mutableCopy]];
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


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
    DealName.text = [Infodict objectForKey:@"yipit_title"] ;
    //cell.DaysLbl.text = [[[CategouryDataArray objectAtIndex:indexPath.row] objectForKey:@"discount"] objectForKey:@"raw"];
    
    DealDesc.text = [NSString stringWithFormat:@"%@",[[Infodict objectForKey:@"business"] objectForKey:@"name"]];
    
    NSMutableArray *ar = [[Infodict objectForKey:@"business"] objectForKey:@"locations"];
    if ([ar count]>0)
        DealDesc2.text = [NSString stringWithFormat:@"%@",[[ar objectAtIndex:0] objectForKey:@"address"]];
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
    BrowserViewController_ipad *browerVC = [[BrowserViewController_ipad alloc]initWithNibName:@"BrowserViewController_ipad" bundle:nil];
    
    browerVC.CompanyUrl = [Infodict objectForKey:@"yipit_url"];
    [self.view addSubview:browerVC.view];
    self.view.alpha = 0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        //self.view.alpha = 0 ;
        self.view.alpha = 1;
        
     [UIView commitAnimations];
    
}

#pragma mark - DealDelegate
-(void)DealSelected:(NSMutableDictionary *)dealInfo
{
    [Infodict removeAllObjects];
    Infodict = [[NSMutableDictionary alloc]initWithDictionary:dealInfo];
    [self SetUpView];

}


@end
