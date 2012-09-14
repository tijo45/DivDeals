//
//  CityViewController.m
//  DivDeal
//
//  Created by Deepak Bhati on 12/09/12.
//  Copyright (c) 2012 Deepak Bhati. All rights reserved.
//

#import "CityViewController.h"

#import "CustomCell.h"
#import "PopedViewController.h"
#import "MainViewController.h"

#import "AppDelegate.h"

@interface CityViewController ()

@end

@implementation CityViewController

@synthesize CityDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    cityArray = [[NSMutableArray alloc]init];
    [cityArray addObject:@"New-York"];
    [cityArray addObject:@"Los-Angeles"];
    [cityArray addObject:@"Chicago"];
    [cityArray addObject:@"Boston"];
    [cityArray addObject:@"San-Diego"];
    [cityArray addObject:@"San-Francisco"];
    [cityArray addObject:@"Atlanta"];
    [cityArray addObject:@"Washington-DC"];
    [cityArray addObject:@"Seattle"];
    [cityArray addObject:@"Toronto"];
    [cityArray addObject:@"Houston"];
    [cityArray addObject:@"Miami"];
    [cityArray addObject:@"Denver"];
    [cityArray addObject:@"Dallas"];
    [cityArray addObject:@"Phoenix"];
    [cityArray addObject:@"Philadelphia"];
    [cityArray addObject:@"Las-Vegas"];
    [cityArray addObject:@"Orange-County"];
    [cityArray addObject:@"Portland"];
    [cityArray addObject:@"Minneapolis"];
    [cityArray addObject:@"Austin"];
    [cityArray addObject:@"San-Jose"];
    [cityArray addObject:@"Orlando"];
    [cityArray addObject:@"Vancouver"];
    [cityArray addObject:@"St.-Louis"];
    [cityArray addObject:@"Kansas-City"];
    [cityArray addObject:@"Milwaukee"];
    [cityArray addObject:@"Cincinnati"];
    [cityArray addObject:@"Indianapolis"];
    [cityArray addObject:@"Nashville"];
    [cityArray addObject:@"Montreal"];
    [cityArray addObject:@"Baltimore"];
    [cityArray addObject:@"Sacramento"];
    [cityArray addObject:@"Salt-Lake-City"];
    [cityArray addObject:@"Fort-Lauderdale"];
    [cityArray addObject:@"San-Antonio"];
    [cityArray addObject:@"Pittsburgh"];
    [cityArray addObject:@"Raleigh-Durham"];
    [cityArray addObject:@"North-Jersey"];
    [cityArray addObject:@"New-Orleans"];
    [cityArray addObject:@"Tampa-/-St.-Petersburg"];
    [cityArray addObject:@"Cleveland"];
    [cityArray addObject:@"Detroit"];
    [cityArray addObject:@"Palm-Beach"];
    [cityArray addObject:@"Charlotte"];
    [cityArray addObject:@"Oakland"];
    [cityArray addObject:@"Columbus"];
    [cityArray addObject:@"Calgary"];
    [cityArray addObject:@"Edmonton"];
    [cityArray addObject:@"Ottawa"];
    
    [table reloadData];

    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [cityArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = ([[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]);
    }
    
    cell.myLabel.text = [cityArray objectAtIndex:indexPath.row];
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"city"] isEqualToString:[cityArray objectAtIndex:indexPath.row]])
    {
        cell.myLabel.textColor = [UIColor whiteColor];
        //cell.backgroundColor = [UIColor blackColor];
    }
    else
    {
        cell.myLabel.textColor = [UIColor blackColor];
        //cell.backgroundColor = [UIColor clearColor];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults]setObject:[cityArray objectAtIndex:indexPath.row] forKey:@"city"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    
//    if ([CityDelegate respondsToSelector:@selector(CitySelected)]) {
//        [CityDelegate CitySelected];
//    }
//    else
//    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate setUpView];
//    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return 24;
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
