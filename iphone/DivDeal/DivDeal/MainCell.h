//
//  MainCell.h
//  DivDeal
//
//  Created by Deepak Bhati on 12/09/12.
//  Copyright (c) 2012 Deepak Bhati. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCell : UITableViewCell
{
    IBOutlet UIImageView *dealImage, *bgImage;
    IBOutlet UILabel *DealName;
    IBOutlet UILabel *rateLbl;
    IBOutlet UILabel *DisLbl;
    IBOutlet UILabel *DaysLbl;
    
}

@property(nonatomic , retain)IBOutlet UILabel *DealName, *rateLbl, *DisLbl, *DaysLbl;

@property (nonatomic ,retain)IBOutlet UIImageView *dealImage, *bgImage;

@end
