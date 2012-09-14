//
//  LeftViewController.m
//  PPRevealSideViewController
//
//  Created by Deepak Bhati on 06/09/12.
//  Copyright (c) 2012 Deepak Bhati. All rights reserved.
//

#import "TableViewController.h"
#import "CustomCell.h"
#import "PopedViewController.h"
#import "MainViewController.h"

#import "AppDelegate.h"

//#import "SecondViewController.h"
//#import "ThirdViewController.h"
//#import "WebViewController.h"
//#import "ModalViewController.h"

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    @try {
        [self.tableView removeObserver:self
                            forKeyPath:@"revealSideInset"];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = FALSE;
    
    [self.tableView addObserver:self 
                     forKeyPath:@"revealSideInset"
                        options:NSKeyValueObservingOptionNew
                        context:NULL];
    
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

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.tableView removeObserver:self
                        forKeyPath:@"revealSideInset"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"revealSideInset"]) {
        UIEdgeInsets newInset = self.tableView.contentInset;
//        newInset.top = self.tableView.revealSideInset.top;
//        newInset.bottom = self.tableView.revealSideInset.bottom;
        self.tableView.contentInset = newInset;
    }
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void) dealloc 
{
    @try{
        [self.tableView removeObserver:self
                            forKeyPath:@"revealSideInset"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
#if !PP_ARC_ENABLED
    [super dealloc];
#endif
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
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate setUpView];
    
}

@end
