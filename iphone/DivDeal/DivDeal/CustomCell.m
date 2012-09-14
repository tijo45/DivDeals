//
//  CustomCell.m
//  PPRevealSideViewController
//
//  Created by Deepak Bhati on 06/09/12.
//  Copyright (c) 2012 Deepak Bhati. All rights reserved.
//

#import "CustomCell.h"
#import "AppDelegate.h"
@implementation CustomCell
@synthesize myLabel = _myLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        _disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        [self.contentView addSubview:_disclosureButton];
//        _disclosureButton.frame = CGRectMake(0, 0, 40, 40);
//        self.textLabel.backgroundColor = [UIColor clearColor];
        
        _myLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _myLabel.backgroundColor = [UIColor clearColor];
        _myLabel.numberOfLines = 2;
        
        [self.contentView addSubview:_myLabel];
        
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];    
//    CGRect newFrame = _disclosureButton.frame;
//    newFrame.origin.x = CGRectGetWidth(self.contentView.frame)- 5.0 /*margin*/ - self.revealSideInset.right - CGRectGetWidth(newFrame);
//    newFrame.origin.y = floorf((CGRectGetHeight(self.frame) - CGRectGetHeight(_disclosureButton.frame))/2.0);
//    _disclosureButton.frame = newFrame;
//    
//    CGFloat margin = 3.0;
//    
//    _myLabel.frame = CGRectMake(margin, 
//                                margin, 
//                                CGRectGetMinX(newFrame)-2*margin,
//                                CGRectGetHeight(self.frame) - 2*margin);
    
    
    _myLabel.frame = CGRectMake(10, 0, 300, 24);
    
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"city"])
        _myLabel.textAlignment = UITextAlignmentRight;
    else
        _myLabel.textAlignment = UITextAlignmentCenter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) dealloc {
    self.myLabel = nil;
#if !PP_ARC_ENABLED
    [super dealloc];
#endif
}

@end
