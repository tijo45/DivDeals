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

@synthesize CityDelegate,Filtersegment;

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
    
    IsBusniss = NO;
    
   // [table reloadData];

      // [Filtersegment setSelectedSegmentIndex:0];
    
    
    isFirstTime = NO;
    nextURL = nil;
    
    selectdIndex = nil;
    businessArray = nil;
    
    if (([[NSUserDefaults standardUserDefaults]objectForKey:@"busniss"])||([[NSUserDefaults standardUserDefaults]objectForKey:@"ForAll"]))
    {
        [self ForBusniss];
    }
    else
    {
        Filtersegment.enabled = FALSE;
        [self forCity];
    }
    
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [self SelectTableCell];
}


-(void)SelectTableCell
{
    if (([[NSUserDefaults standardUserDefaults]objectForKey:@"busniss"])||([[NSUserDefaults standardUserDefaults]objectForKey:@"ForAll"]))
    {
        if ([cityArray count]>0)
        {
            NSString *cityStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"busniss"];
            
            if (cityStr) {
                [table scrollRectToVisible:CGRectMake(0, 30, 320, 384) animated:YES];
            }
            else
            {
                NSString *tempStr;
                
                for (int i=0; i<[cityArray count]; i++)
                {
                    tempStr = [[cityArray objectAtIndex:i]objectForKey:@"slug"];
                    if([tempStr isEqualToString:cityStr])
                    {
                        [table scrollRectToVisible:CGRectMake(0, i*30, 320, 384) animated:YES];
                        break;
                    }
                }
            }
        }
    }
    else
    {
        if ([cityArray count]>0)
        {
            if([cityArray containsObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"city"]])
                [table scrollRectToVisible:CGRectMake(0, [cityArray indexOfObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"city"]]*30, 320, 384) animated:YES];
        }
    }
}

-(void)downloadData
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([appDelegate connected]) {
        [self performSelectorInBackground:@selector(downLoadCategouryData) withObject:nil];
    }
    else
    {
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"No Network please try agan leter." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Retry", nil];
        [al show];
    }
    
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Retry"])
    {
        [self downloadData];
    }
    
}
#pragma mark - server Function
#pragma mark -
#pragma Private Methods

-(void)downLoadCategouryData
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSString *urlString;
    
    if (!nextURL)
        urlString = [NSString stringWithFormat:@"http://api.yipit.com/v1/tags/?key=jmqgADVW3gtdYTr4"];
    else
        urlString = nextURL;
        
    
    
	urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSURL *url = [NSURL URLWithString:urlString];
	NSData *data= [NSData dataWithContentsOfURL:url];
	
	if (data)
	{
		NSString *response = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
		
		NSRange r = [response rangeOfString:@"<BR />"];
        if (r.length)
            response = [response substringFromIndex:(r.length + r.location)];
        
		r = [response rangeOfString:@"<BR />"];
        if (r.length)
            response = [response substringFromIndex:(r.length + r.location)];
		
		data = [response dataUsingEncoding:NSUTF8StringEncoding];
		
		NSObject *obj = [response mutableObjectFromJSONString];
		[self performSelectorOnMainThread:@selector(dataReceived:) withObject:obj waitUntilDone:YES];
	}
    else {
        [self performSelectorOnMainThread:@selector(datanotReecived) withObject:nil waitUntilDone:YES];
        
    }
	
	[pool release];
}

-(void)datanotReecived
{
    
}

-(void)dataReceived:(NSObject *)obj
{
    [Spinner stopAnimating];
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]initWithDictionary:(NSMutableDictionary *)obj];
    
    NSMutableDictionary *moreDict = [[NSMutableDictionary alloc]initWithDictionary:[dict1 objectForKey:@"meta"]];
    
    
    NSLog(@"%@",[moreDict objectForKey:@"next"]);
    if ([moreDict objectForKey:@"next"]) {
        nextURL = [[NSString alloc]initWithString:[moreDict objectForKey:@"next"]];
        [nextURL retain];
        
//        if (isFirstTime==NO) {
//            isFirstTime = YES;
//            [self performSelectorInBackground:@selector(downLoadCategouryData) withObject:nil];
//            return;
//        }
    }
    else
        nextURL = nil;

    
    NSMutableDictionary *Dict = [[NSMutableDictionary alloc]initWithDictionary:[dict1 objectForKey:@"response"]];
    
    if ([[Dict objectForKey:@"tags"] count]>0)
    {
        if (businessArray)
        {
            [businessArray addObjectsFromArray:[[NSMutableArray alloc]initWithArray:[Dict objectForKey:@"tags"]]];
        }
        else
        {
            //[table scrollRectToVisible:CGRectMake(0, 0, 320, 384) animated:YES];

            [businessArray removeAllObjects];
            [businessArray release];
            
            businessArray = [[NSMutableArray alloc]init];
            [businessArray addObject:[[NSMutableDictionary alloc] init]];

            [[businessArray lastObject]setObject:@"All" forKey:@"slug"];
            [[businessArray lastObject]setObject:@"All" forKey:@"name"];
            [[businessArray lastObject]setObject:@"" forKey:@"url"];
            //WithArray:[[NSMutableArray alloc]initWithArray:[Dict objectForKey:@"tags"]]];
            [businessArray addObjectsFromArray:[[NSMutableArray alloc]initWithArray:[Dict objectForKey:@"tags"]]];

        }
        IsBusniss = YES;
        
        
        [cityArray removeAllObjects];
        [cityArray release];
        cityArray = [[NSMutableArray alloc]initWithArray:businessArray];
        
        
        [table reloadData];
        
        //[self SelectTableCell];
    }
}


#pragma mark - userDefine Fuction

-(IBAction)segmentValueChange:(id)sender
{
    if (Filtersegment.selectedSegmentIndex==0)
    {
        [self forCity];
    }
    else
    {
        [self ForBusniss];
    }
}


-(void)ForBusniss
{
    selectdIndex = nil;
    if (businessArray)
    {
        if (cityArray) {
            [cityArray removeAllObjects];
            [cityArray release];
        }
        
        cityArray = [[NSMutableArray alloc]initWithArray:businessArray];
        
        IsBusniss = YES;
        [table reloadData];
    }
    else
    {
        [Spinner startAnimating];
        [self downloadData];
    }
    
    [Filtersegment setSelectedSegmentIndex:1];
    
}

-(void)forCity
{
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
    
    selectdIndex = nil;
    IsBusniss = NO;
    
    if (locationArray) {
        [locationArray removeAllObjects];
        [locationArray release];
    }
    locationArray = [[NSMutableArray alloc]initWithArray:cityArray];
    [locationArray retain];

    
    if (cityArray) {
        [cityArray removeAllObjects];
        [cityArray release];
    }
    cityArray = [[NSMutableArray alloc]initWithArray:locationArray];
    
    [table reloadData];
    
    [Filtersegment setSelectedSegmentIndex:0];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(bool) IsMoreButton:(NSIndexPath *)IndexPath
{
    return IndexPath.row>=[cityArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int Counts = 0;
    NSLog(@"ListCont %d",[cityArray count]);
    
    Counts =  [cityArray count]>0 ? [cityArray count]+1: 0;
    
    return Counts;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([self IsMoreButton:indexPath])
    {
        
        static NSString *CellIdentifier = @"MoreCell";
        
        CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = ([[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]);
        }
        if (cell == nil)
        {
            //cell = [[[ListCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
            for (int i =0; i < [nib count]; i++)
            {
                if ([[nib objectAtIndex:i] isKindOfClass:[CustomCell class]])
                {
                    cell = (CustomCell *)[nib objectAtIndex:0];
                    break;
                }
            }
        }
        
        
        cell.myLabel.hidden = TRUE;
         spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        spinner.center = cell.center;
        [spinner startAnimating];
        
        [cell addSubview:spinner];
        
        [self performSelectorInBackground:@selector(downLoadCategouryData) withObject:nil];
        
        
        return cell;
    }
    
    
    static NSString *CellIdentifier = @"Cell";
    
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = ([[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]);
    }
    
    
    if (IsBusniss)
    {
        cell.myLabel.text = [[cityArray objectAtIndex:indexPath.row] objectForKey:@"slug"];
        
        if(([[[NSUserDefaults standardUserDefaults]objectForKey:@"busniss"] isEqualToString:[[cityArray objectAtIndex:indexPath.row]objectForKey:@"slug"]])||([[[NSUserDefaults standardUserDefaults]objectForKey:@"ForAll"] isEqualToString:[[cityArray objectAtIndex:indexPath.row]objectForKey:@"slug"]]))
        {
            cell.myLabel.textColor = [UIColor blackColor];
            cell.bgImage.image = [UIImage imageNamed:@"bluestrip.png"];
            
            selectdIndex = indexPath;
            
        }
        else
        {
            cell.myLabel.textColor = [UIColor whiteColor];
            cell.bgImage.image = [UIImage imageNamed:@"blackstrip.png"];
            
        }

    }
    else
    {
        cell.myLabel.text = [cityArray objectAtIndex:indexPath.row];
        
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"city"] isEqualToString:[cityArray objectAtIndex:indexPath.row]])
        {
            cell.myLabel.textColor = [UIColor blackColor];
            cell.bgImage.image = [UIImage imageNamed:@"bluestrip.png"];
            
            selectdIndex = indexPath;
        }
        else
        {
            cell.myLabel.textColor = [UIColor whiteColor];
            cell.bgImage.image = [UIImage imageNamed:@"blackstrip.png"];
            
        }

    }
    
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![self IsMoreButton:indexPath])
    {
        
        if (IsBusniss)
        {
            if ([[[cityArray objectAtIndex:indexPath.row]objectForKey:@"slug"] isEqualToString:@"All"])
            {
                [[NSUserDefaults standardUserDefaults]setObject:@"All" forKey:@"ForAll"];
                [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"busniss"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSUserDefaults standardUserDefaults]synchronize];

            }
            else
            {
                [[NSUserDefaults standardUserDefaults]setObject:[[cityArray objectAtIndex:indexPath.row]objectForKey:@"slug"] forKey:@"busniss"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"ForAll"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [appDelegate setUpView];
            
            [table reloadData];

            
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setObject:[cityArray objectAtIndex:indexPath.row] forKey:@"city"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            Filtersegment.enabled = TRUE;
            [self ForBusniss];
            
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return 32;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

@end
