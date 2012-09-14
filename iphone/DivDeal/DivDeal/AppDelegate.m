//
//  AppDelegate.m
//  DivDeal
//
//  Created by Deepak Bhati on 06/09/12.
//  Copyright (c) 2012 Deepak Bhati. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"
#import "TableViewController.h"
#import "PopedViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize revealSideViewController = _revealSideViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = ([[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]);
    
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"city"])
    {
        [self LoadDealView];
    }
    else
    {
        c = [[CityViewController alloc] initWithNibName:@"CityViewController" bundle:nil];
        c.CityDelegate = nil;
        c.view.frame = CGRectMake(0, 20, 320, 460);
        [self.window addSubview:c.view];
    }
    
 
    
//    PP_RELEASE(main);
//    PP_RELEASE(nav);
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


-(void)setUpView
{
    [UIView animateWithDuration:0.3 animations:^(void){
        c.view.alpha = 0;
    }completion:^(BOOL finished){
        [c.view removeFromSuperview];
        [self LoadDealView];
       // _revealSideViewController.view.alpha = 1;
    }];
}

-(void)setUpDealDescriptionView
{
    [UIView animateWithDuration:0.3 animations:^(void){
        popVC.view.alpha = 0;
    }completion:^(BOOL finished){
        [popVC.view removeFromSuperview];
        [self LoadMainView];
        // _revealSideViewController.view.alpha = 1;
    }];
}


-(void)LoadMainView
{
    MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:main];
    nav.navigationBarHidden = TRUE;
    _revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:nav];
    
    _revealSideViewController.delegate = self;
   // _revealSideViewController.view.alpha = 0;
    self.window.rootViewController = _revealSideViewController;

    
}


-(void)LoadDealView
{
    if (_revealSideViewController) {
        [_revealSideViewController.view removeFromSuperview];
        [_revealSideViewController release];
    }
    
    popVC = [[PopedViewController alloc]initWithNibName:@"PopedViewController" bundle:nil];
    popVC.dealDelegate = nil;
    popVC.view.frame = CGRectMake(0, 20, 320, 460);
    [self.window addSubview:popVC.view];

}

#pragma mark - PPRevealSideViewController delegate

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller willPushController:(UIViewController *)pushedController {
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didPushController:(UIViewController *)pushedController {
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller willPopToController:(UIViewController *)centerController {
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didPopToController:(UIViewController *)centerController {
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didChangeCenterController:(UIViewController *)newCenterController {
    
}

- (BOOL) pprevealSideViewController:(PPRevealSideViewController *)controller shouldDeactivateDirectionGesture:(UIGestureRecognizer*)gesture forView:(UIView*)view {
    return NO;
}

- (PPRevealSideDirection)pprevealSideViewController:(PPRevealSideViewController*)controller directionsAllowedForPanningOnView:(UIView*)view {
    
    if ([view isKindOfClass:NSClassFromString(@"UIWebBrowserView")]) return PPRevealSideDirectionLeft | PPRevealSideDirectionRight;
    
    return PPRevealSideDirectionLeft | PPRevealSideDirectionRight | PPRevealSideDirectionTop | PPRevealSideDirectionBottom;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
