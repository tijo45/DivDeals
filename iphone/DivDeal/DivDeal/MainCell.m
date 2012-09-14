//
//  MainCell.m
//  DivDeal
//
//  Created by Deepak Bhati on 12/09/12.
//  Copyright (c) 2012 Deepak Bhati. All rights reserved.
//

#import "MainCell.h"

@implementation MainCell

@synthesize DealName, rateLbl, DisLbl, DaysLbl,dealImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
