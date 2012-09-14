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
    NSMutableArray *cityArray;
    
    IBOutlet UITableView *table;
}

@property(nonatomic , retain)id<CityViewControllerDelegate>CityDelegate;

@end
