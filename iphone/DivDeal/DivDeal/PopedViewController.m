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
    
    [self downloadData];
    
    isFirstTime = NO;
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
    if (nextURL) {
        
//        NSRange rang = [nextURL rangeOfString:@"offset="];
//        
//        urlString = [nextURL substringToIndex:rang.location];
//        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"offset=%d",[CategouryDataArray count]+20]];
        urlString = nextURL;
    }
    else
    {
       // city
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"ForAll"]) {
            //http://api.yipit.com/v1/deals/?key=jmqgADVW3gtdYTr4&division=new-york&tag=gym
             
            //http://api.yipit.com/v1/deals/?key=jmqgADVW3gtdYTr4&division=new-york&tag=gym
            urlString = [NSString stringWithFormat:@"http://api.yipit.com/v1/deals/?key=jmqgADVW3gtdYTr4&division=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"city"]];

        }
        else
        {
            urlString = [NSString stringWithFormat:@"http://api.yipit.com/v1/deals/?key=jmqgADVW3gtdYTr4&division=%@&tag=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"city"],[[NSUserDefaults standardUserDefaults]objectForKey:@"busniss"]];

        }
        
  
     }
    
    //busniss
    //city
    

    
    
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
    
    
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]initWithDictionary:[dict1 objectForKey:@"response"]];
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[dict2 objectForKey:@"deals"]];

    
    if ([array count]>0)
    {
        //NSLog(@"%@",[array count]);
        if (CategouryDataArray)
            [CategouryDataArray addObjectsFromArray:array];
        else
        {
            [CategouryDataArray removeAllObjects];
            CategouryDataArray = [[NSMutableArray alloc]initWithArray:array];
        }
        
        [dealTable reloadData];
    }
    else
    {
        [spinner stopAnimating];
        
        if ([CategouryDataArray count]==0) {
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"there is no deal for you right now please try Another Categoury. Thank You" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [al show];
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

            [appDelegate Loadcity];
        }
        
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


-(bool) IsMoreButton:(NSIndexPath *)IndexPath
{
    return IndexPath.row>=[CategouryDataArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int Counts = 0;
    NSLog(@"ListCont %d",[CategouryDataArray count]);
    
    Counts =  [CategouryDataArray count]>0 ? [CategouryDataArray count]+1: 0;
    
    return Counts;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([self IsMoreButton:indexPath])
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
        
        
        cell.dealImage.hidden = TRUE;
        cell.DealName.hidden = TRUE;
        cell.bgImage.hidden = TRUE;
        spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = cell.center;
        [spinner startAnimating];
        
        [cell addSubview:spinner];
        
        [self performSelectorInBackground:@selector(downLoadCategouryData) withObject:nil];

        
        return cell;
    }
    
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
    //cell.DealName.text = [NSString stringWithFormat:@"%@\n %@ \n%@",[dict  objectForKey:@"title"],[[dict objectForKey:@"business"] objectForKey:@"name"],[[dict objectForKey:@"source"] objectForKey:@"name"]]; ;
    
    cell.DealName.text = [NSString stringWithFormat:@"%@ \n%@",[[dict objectForKey:@"business"] objectForKey:@"name"],[[dict objectForKey:@"source"] objectForKey:@"name"]]; ;
    
    //cell.DealName.text = [NSString stringWithFormat:@"%@",[dict  objectForKey:@"title"]];
    
    
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
    if(![self IsMoreButton:indexPath])
    {
        if ([dealDelegate respondsToSelector:@selector(DealSelected:)]) {
            [dealDelegate DealSelected:[CategouryDataArray objectAtIndex:indexPath.row]];
        }
        else
        {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            appDelegate.MaininfoDict = [[NSMutableDictionary alloc]initWithDictionary:[CategouryDataArray objectAtIndex:indexPath.row]];
            [appDelegate.MaininfoDict retain];
            
            [[NSUserDefaults standardUserDefaults]setObject:[CategouryDataArray objectAtIndex:indexPath.row] forKey:@"deal"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [appDelegate setUpDealDescriptionView];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return 82;
    
}


#pragma mark -

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

- (IBAction)popToRoot:(id)sender {
    [self.revealSideViewController popViewControllerAnimated:YES];
}
@end
