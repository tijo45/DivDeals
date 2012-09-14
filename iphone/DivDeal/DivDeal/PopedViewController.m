//
//  PopedViewController.m
//  PPRevealSideViewController
//
//  Created by Deepak Bhati on 06/09/12.
//  Copyright (c) 2012 Deepak Bhati. All rights reserved.
//

#import "PopedViewController.h"
#import "AppDelegate.h"
#import "MainCell.h"

#import "JSONKit.h"
#import "UIImageView+WebCache.h"

@implementation PopedViewController

@synthesize dealDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [Spinner startAnimating];
    [self performSelectorInBackground:@selector(downLoadCategouryData) withObject:nil];
}

#pragma mark - server Function
#pragma mark -
#pragma Private Methods

-(void)downLoadCategouryData
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *urlString = [NSString stringWithFormat:@"http://api.yipit.com/v1/deals/?key=jmqgADVW3gtdYTr4&division=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"city"]];
    
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
{    //[[categoryArray lastObject]addObject:@"1"];
}

-(void)dataReceived:(NSObject *)obj
{
    [Spinner stopAnimating];
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]initWithDictionary:(NSMutableDictionary *)obj];
  
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]initWithDictionary:[dict1 objectForKey:@"response"]];
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[dict2 objectForKey:@"deals"]];

    
    if ([array count]>0)
    {
        NSLog(@"%@",[array objectAtIndex:0]);
        if (CategouryDataArray)
            [CategouryDataArray removeAllObjects];
        
        CategouryDataArray = [[NSMutableArray alloc]initWithArray:array];
        
        [dealTable reloadData];
    }
    
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
    return [CategouryDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
	MainCell *cell = (MainCell  *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if (cell == nil)
	{
        //cell = [[[ListCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainCell" owner:self options:nil];
		for (int i =0; i < [nib count]; i++)
		{
			if ([[nib objectAtIndex:i] isKindOfClass:[MainCell class]])
			{
				cell = (MainCell *)[nib objectAtIndex:0];
				break;
			}
		}
	}
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableDictionary *dict = [CategouryDataArray objectAtIndex:indexPath.row];
    
    cell.DisLbl.text = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"discount"] objectForKey:@"raw"]];
    cell.rateLbl.text = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"price"] objectForKey:@"raw"]];
    cell.DealName.text = [dict objectForKey:@"yipit_title"] ;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd HH':'mm':'ss"];
    //end_date
    NSString *Datestr =[dict objectForKey:@"end_date"];
    NSDate *date = [dateFormatter dateFromString:Datestr];
    
   // NSDate *Todaydate = [NSDate date];
    
    NSTimeInterval distanceBetweenDates = [date timeIntervalSinceDate:[NSDate date]];
    int totaldays = distanceBetweenDates/86400;
//    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",totaldays] forKey:@"totalDays"];
//    [[NSUserDefaults standardUserDefaults]synchronize];

    
    cell.DaysLbl.text = [NSString stringWithFormat:@"%d",totaldays];
    
    //cell.DaysLbl.text = [[[CategouryDataArray objectAtIndex:indexPath.row] objectForKey:@"discount"] objectForKey:@"raw"];
    
    [cell.dealImage setImageWithURL:[NSURL URLWithString:[[dict objectForKey:@"images"] objectForKey:@"image_small"]]];
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([dealDelegate respondsToSelector:@selector(DealSelected:)]) {
        [dealDelegate DealSelected:[CategouryDataArray objectAtIndex:indexPath.row]];
    }
    else
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [[NSUserDefaults standardUserDefaults]setObject:[CategouryDataArray objectAtIndex:indexPath.row] forKey:@"deal"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [appDelegate setUpDealDescriptionView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return 80;
    
}


#pragma mark -

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)popToRoot:(id)sender {
    [self.revealSideViewController popViewControllerAnimated:YES];
}
@end
