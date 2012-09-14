//
//  MainViewController.h
//  PPRevealSideViewController
//
//  Created by Deepak Bhati on 06/09/12.
//  Copyright (c) 2012 Deepak Bhati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopedViewController.h"
#import "CityViewController.h"

@interface MainViewController : UIViewController
{
    CityViewController *c;
    PopedViewController *Poped;
    BOOL _animated;
     CGFloat _offset;
    
    NSMutableDictionary *Infodict;
    
    IBOutlet UIImageView *dealImage;
    IBOutlet UILabel *DealName;
    IBOutlet UILabel *rateLbl;
    IBOutlet UILabel *DisLbl;
    IBOutlet UILabel *DaysLbl;
    
    IBOutlet UILabel *DealDesc;
    IBOutlet UILabel *DealDesc2;
    
    IBOutlet UIImageView *ratingImage;
 

}

- (IBAction) showLeft;
- (IBAction)showRight;
-(IBAction)DealPressed:(id)sender;
@end
