//
//  AppDelegate.h
//  DivDeal
//
//  Created by Deepak Bhati on 06/09/12.
//  Copyright (c) 2012 Deepak Bhati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPRevealSideViewController.h"
#import "CityViewController.h"
#import "PopedViewController.h"

#import "FBController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, PPRevealSideViewControllerDelegate>
{
    PPRevealSideViewController *revealSideViewController;
    
    CityViewController  *c;
    PopedViewController *popVC;
    
    FBController        *fbController;
    
    NSMutableDictionary *MaininfoDict;
}
@property (nonatomic , retain)FBController *fbController;
@property (nonatomic , retain)NSMutableDictionary *MaininfoDict;

-(BOOL)connected;
-(void)setUpView;
-(void)setUpDealDescriptionView;
-(void)LoadMainView;
-(void)Loadcity;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PPRevealSideViewController *revealSideViewController;
@end
