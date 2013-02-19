//
//  FBController.m
//  FB
//
//  Created by MaDdy on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBController.h"
#import "SBJsonWriter.h"
#import "AppDelegate.h"
#define _APP_KEY @"360988710650671"

@implementation FBController
@synthesize facebook;
@synthesize loginButton,username,userid,userimage,isTryingAutoLogin,post;
@synthesize delegate,userBday,userGender,userEmail;
@synthesize friendListCaller;



-(id)init
{
	if ([super init])
	{
		// HERE THE LOGIN BUTTON
		
		loginButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		loginButton.frame = CGRectMake(0, 0, 256,256);
		[loginButton addTarget:self
						action:@selector(login)
			  forControlEvents:UIControlEventTouchUpInside];
		
		// HERE THE Post BUTTON
		post = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		post.frame = CGRectMake(10,400, 300,40);
		[post addTarget:self
						action:@selector(postToFacebook::::::)
			  forControlEvents:UIControlEventTouchUpInside];
		[post setTitle:@"Psot to FB" forState:UIControlStateNormal];
		[post setHidden:TRUE];
		
		
		[loginButton setImage:
		 [UIImage imageNamed:@"fbBtn.png"]
					 forState:UIControlStateNormal];
		
		
		// Initialize Facebook
		facebook = [[Facebook alloc] initWithAppId:_APP_KEY andDelegate:self];//(id<FBSessionDelegate>)[[UIApplication sharedApplication] delegate]];
        //facebook = [[Facebook alloc] initWithAppId:SHKFacebookid 
                                 //  urlSchemeSuffix:@"foo" 
                                   //    andDelegate:self];
        
		facebook.sessionDelegate = self;
		// Initialize user permissions
		userPermissions = [[NSMutableDictionary alloc] initWithCapacity:1];
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		if ([defaults objectForKey:@"FBAccessTokenKey"]	&& [defaults objectForKey:@"FBExpirationDateKey"]) 
		{
			facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
			facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
		}
		
			// Now check that the URL scheme fb[app_id]://authorize is in the .plist and can
			// be opened, doing a simple check without local app id factored in here
			NSString *url = [NSString stringWithFormat:@"fb%@://authorize",_APP_KEY];
			BOOL bSchemeInPlist = NO; // find out if the sceme is in the plist file.
			NSArray* aBundleURLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
			if ([aBundleURLTypes isKindOfClass:[NSArray class]] && 
				([aBundleURLTypes count] > 0)) {
				NSDictionary* aBundleURLTypes0 = [aBundleURLTypes objectAtIndex:0];
				if ([aBundleURLTypes0 isKindOfClass:[NSDictionary class]]) {
					NSArray* aBundleURLSchemes = [aBundleURLTypes0 objectForKey:@"CFBundleURLSchemes"];
					if ([aBundleURLSchemes isKindOfClass:[NSArray class]] &&
						([aBundleURLSchemes count] > 0)) {
						NSString *scheme = [aBundleURLSchemes objectAtIndex:0];
						if ([scheme isKindOfClass:[NSString class]] && 
							[url hasPrefix:scheme]) {
							bSchemeInPlist = YES;
						}
					}
				}
			}
			// Check if the authorization callback will work
			BOOL bCanOpenUrl = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: url]];
			if (!bSchemeInPlist || !bCanOpenUrl) {
				/*UIAlertView *alertView = [[UIAlertView alloc] 
										  initWithTitle:@"Setup Error" 
										  message:@"Invalid or missing URL scheme. You cannot run the app until you set up a valid URL scheme in your .plist." 
										  delegate:self 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil, 
										  nil];
				[alertView show];
				[alertView release];*/
			}
//		}
		
		
		
		// Initialize permissions
		permissions = [[NSArray alloc] initWithObjects:@"offline_access",@"status_update", nil];
		
		isTryingAutoLogin = NO;
		self.userid = @"##NOUSER##";
		self.username = @"##NOUSER##";
		self.userimage = @"##NOUSER##";
		self.userBday = @"01-01-2000"; // MM - dd - yyyy
		self.userGender = @"M";
		self.userEmail = @"x@x.com";
		
		return self;
	}
	return nil;
}

-(void)logout
{
	self.userid = @"##NOUSER##";
	self.username = @"##NOUSER##";
	self.userimage = @"##NOUSER##";
	self.userBday = @"01-01-2000"; // MM - dd - yyyy
	self.userGender = @"M";
	self.userEmail = @"x@x.com";
	
	[[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"status_update"];
	[[NSUserDefaults standardUserDefaults]synchronize];
	
	[facebook logout];
	
	if (!isTryingAutoLogin)
	{
        [delegate FBLoggedOutSuccessfully];
	}
    
    [delegate FBLoggedOutSuccessfully];
}


-(void)login
{
	if (![facebook isSessionValid]) {
        [facebook authorize:permissions];
    } 
	else
	{
		self.username = @"Anonymous";
		self.userimage = @"";
		[self getFacebookName];		
	}
		
}


-(void)autoLoginIntoFB
{
	isTryingAutoLogin = YES;
	
	if (![facebook isSessionValid])
	{
		NSLog(@"session invalid");
        [facebook authorize:permissions];
    } 
	else
	{
		self.username = @"Anonymous";
		self.userimage = @"";
		[self getFacebookName];		
	}
	
	//isTryingAutoLogin = NO;
}

// USE THIS FUNCTION TO POST A PROPER POST WITH IMAGE AND LINKS
-(void)postToFacebook:(NSString *)title :(NSString *)titleURL :(NSString *)caption :(NSString *)imageSrc :(NSString *)imageLink :(NSString *)imageHRef
{
 
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc]init];
//    
    NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          @"Get your Deal app here",@"text",
                                                           imageHRef,@"href",
                                                           nil], nil];
    
    NSLog(@"%@",[actionLinks description]);
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
        
    NSMutableDictionary *params = nil;
	params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
			  [NSString stringWithFormat:@"{"
			   "\"name\":\"%@\",\"caption\":\"%@\",\"href\":\"%@\",\"media\":"
			   "[{\"type\": \"image\","
			   "\"src\": \"%@\","
			   "\"link\": \"%@\","
			   "\"href\": \"%@\"}]}",title,caption,titleURL,imageSrc,imageLink,imageHRef],@"attachment",actionLinksStr,@"action_links",nil];
	
    [facebook requestWithMethodName:@"facebook.stream.publish" andParams:params andHttpMethod:@"GET" andDelegate:self];
}

-(void)postToFriendsFacebook:(NSString *)title :(NSString *)titleURL :(NSString *)caption :(NSString *)imageSrc :(NSString *)imageLink :(NSString *)imageHRef :(NSString *)fuid
{
//	NSDictionary *params = nil;
//	params = [NSDictionary dictionaryWithObjectsAndKeys:
//			  [NSString stringWithFormat:@"{"
//			   "\"name\":\"%@\",\"caption\":\"%@\",\"href\":\"%@\",\"media\":"
//			   "[{\"type\": \"image\","
//			   "\"src\": \"%@\","
//			   "\"link\": \"%@\","
//			   "\"href\": \"%@\"}]}",title,caption,titleURL,imageSrc,imageLink,imageHRef],@"attachment",fuid,@"target_id",nil];
//	
//	[[FBRequest requestWithDelegate:self] call:@"facebook.stream.publish" params:params];
}


// USE THIS FUNCTION TO POST A DIRECT STATUS
-(void)postToFacebook:(NSString *)status
{
//	NSDictionary *params = params = [NSDictionary dictionaryWithObjectsAndKeys:status,@"message",nil];
//	[[FBRequest requestWithDelegate:self] call:@"facebook.stream.publish" params:params];
}


#pragma mark -

- (void)getFacebookName 
{
	//[delegate respondToSelector:@selector(FBFetchingUserDetails)];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, name, pic FROM user WHERE uid=me()", @"query",
                                   nil];
    [facebook requestWithMethodName:@"fql.query" andParams:params andHttpMethod:@"POST" andDelegate:self];
	
}

-(void)getUserFriends
{
//	NSString* fql = [NSString stringWithFormat:@"SELECT name,uid FROM user WHERE uid IN ( SELECT uid2 FROM friend WHERE uid1=%lld )",self._session.uid];
//	NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
//	[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
}

#pragma mark - FBSessionDelegate Methods
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin
{
	NSLog(@"DID LOGIN");
	self.username = @"Anonymous";
	self.userimage = @"";
	[self getFacebookName];	
	
    // Save authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled 
{
	[delegate FBLoginFailed];
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout 
{
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
	
   // [self showLoggedOut];
}

/**
 * Called when the session has expired.
 */
- (void)fbSessionInvalidated {   
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception" 
                              message:@"Your session has expired." 
                              delegate:nil 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil, 
                              nil];
    [alertView show];
    [alertView release];
    [self fbDidLogout];
}

#pragma mark -
#pragma mark FACEBOOK Functions
- (void)request:(FBRequest*)request didLoad:(id)result 
{
	if ([request.url isEqualToString:@"https://api.facebook.com/method/fql.query"]) 
	{
		NSArray* users = result;
		if ([users count] == 1)
		{
			// USER DETAILS
			
			NSDictionary* user = [users objectAtIndex:0];
            NSLog(@"UserInfo %@",[user description]);
            
			self.userid = [NSString stringWithFormat:@"%ld",[[user objectForKey:@"uid"] longValue]];
			self.userimage =[[NSString  alloc]initWithString:[user objectForKey:@"pic"]];
			self.username = [[NSString  alloc]initWithString:[user objectForKey:@"name"]];
			
			if (!isTryingAutoLogin)
			{
				[facebook requestWithGraphPath:@"me/permissions" andDelegate:self];
			}
			else
			{
				// THIS WILL NEVER HAPPEN
				[delegate FBLoggedInSuccessfully];
				isTryingAutoLogin = NO;
			}
		}
	}
	else if ([request.url isEqualToString:@"https://graph.facebook.com/me/permissions"]) 
	{
		[delegate FBLoggedInSuccessfully];
	}
    else if([request.url isEqualToString:@"https://api.facebook.com/method/facebook.stream.publish"])
    {
        [LoadingImageQube removeFromSuperview];
        [spinner removeFromSuperview];
        
        [delegate FBPostedSuccessfully];
    }
}


- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response
{
	NSLog(@"LOGIN- respone");
}

/**
 * Called when an error prevents the request from completing successfully.
 */

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error
{
	if ([request.url isEqualToString:@"https://api.facebook.com/method/fql.query"]) 
	{
		NSLog(@"LOGIN	-	error : %d ... %@ ... %@",error.code,error.localizedDescription,error.domain);
		//[friendListCaller FriendListForUser:nil];
	}
	
	[facebook logout];
	[delegate FBLoginFailed];
}

//If the user decides not to grant permission, the dialogDidCancel delegate method gets called:
- (void)dialogDidCancel:(FBDialog*)dialog 
{
	// NO PERMISSION GRANTED BY USER
	[facebook logout];
	[delegate FBLoginFailed];
}


#pragma mark -
#pragma mark FBNew

/**
 * Called when post Successfull.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url 
{
	NSLog(@"Post Success Ful");
}

/**
 * Called when Somthing went Wrong in Posting on Wall .
 */
- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error 
{
	NSLog(@"Error message: %@", [error userInfo]);// objectForKey:@"error_msg"]);	
}

/**
 * Called when user press Dialoge Cancel Button .
 */
- (void)dialogDidNotComplete:(FBDialog *)dialog {
	NSLog(@"Dialog dismissed.");
}






@end
