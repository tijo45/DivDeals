//
//  CityViewController.h
//  DivDeal
//
//  Created by Deepak Bhati on 12/09/12.
//  Copyright (c) 2012 Deepak Bhati. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityViewControllerDelegate <NSObject>

-(void)CitySelected;

@end

@interface CityViewController : UIViewController
{
    
    id<CityViewControllerDelegate>CityDelegate;
    NSMutableArray *cityArray, *businessArray, *locationArray;
    
    IBOutlet UITableView *table;
    
    IBOutlet UISegmentedControl *Filtersegment;
    IBOutlet UIActivityIndicatorView *Spinner;
    
    BOOL IsBusniss;
    
    NSIndexPath *selectdIndex;
    
    IBOutlet UIActivityIndicatorView *spinner;
    NSString *nextURL;
    BOOL isFirstTime;
}

@property(nonatomic , retain)id<CityViewControllerDelegate>CityDelegate;
@property(nonatomic , retain)IBOutlet UISegmentedControl *Filtersegment;

-(IBAction)segmentValueChange:(id)sender;

@end
