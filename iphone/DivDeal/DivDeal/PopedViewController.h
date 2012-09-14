//
//  PopedViewController.h
//  PPRevealSideViewController
//
//  Created by Deepak Bhati on 06/09/12.
//  Copyright (c) 2012 Deepak Bhati. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopedViewControllerDelegate <NSObject>

-(void)DealSelected:(NSMutableDictionary *)dealInfo;

@end

@interface PopedViewController : UIViewController
{
    
    id<PopedViewControllerDelegate>dealDelegate;
    
    IBOutlet UIActivityIndicatorView *Spinner;
	NSMutableArray          *CategouryDataArray;
    
    IBOutlet UITableView *dealTable;
}

@property (nonatomic , retain) id<PopedViewControllerDelegate>dealDelegate;

- (IBAction)popToRoot:(id)sender;
@end
