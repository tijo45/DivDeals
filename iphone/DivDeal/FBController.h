//
//  FBController.h
//  FB
//
//  Created by MaDdy on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "FBConnect.h"
@class AppDelegate;


@protocol FBControllerDelegate

-(void)FBLoggedInSuccessfully;
-(void)FBLoginFailed;
-(void)FBLoggedOutSuccessfully;
-(void)FBPostedSuccessfully;

@optional
// THIS CAN BE USED TO SHOW ACTIVITY INDICATORS
-(void)FBFetchingUserDetails;
-(void)FBFriendsList:(NSMutableArray *)friends;

@end

@protocol FBFriendListCallerDelegate

-(void)FriendListForUser:(NSArray *)friendList;

@end



@interface FBController : NSObject <FBSessionDelegate,FBRequestDelegate,FBDialogDelegate,UITextFieldDelegate> {

    
    AppDelegate *appDelegate;
    
	// FACEBOOK
	//FBSession *_session;
	NSString *sessionProxy;
	//FBPermissionDialog* dialogPublish;
	
	// PROPERTIES
	IBOutlet UIButton *loginButton; 
	NSString *userid,*username,*userimage,*userBday,*userGender,*userEmail;
	
	id <FBControllerDelegate>delegate;
	
	// LOGIC VARIABLES
	bool isTryingAutoLogin;
	id<FBFriendListCallerDelegate> friendListCaller;
	
	////Deepak
	Facebook *facebook;
	NSMutableDictionary *userPermissions;
	NSArray *permissions;
	UIButton *post;
	//DataSet *apiData;
	
    UIImageView *LoadingImageQube;
    UIActivityIndicatorView *spinner;
    
}

@property (nonatomic, retain) Facebook *facebook;

@property(nonatomic,retain) UIButton *loginButton, *post;
@property(nonatomic,retain) NSString *userid,*username,*userimage,*userBday,*userGender,*userEmail;
@property (nonatomic,retain) id <FBControllerDelegate>delegate;
@property(nonatomic) bool isTryingAutoLogin;
@property (nonatomic,retain) id<FBFriendListCallerDelegate> friendListCaller;

//FACE BOOK


-(void)logout;
-(void)autoLoginIntoFB;
-(void)postToFacebook:(NSString *)title :(NSString *)titleURL :(NSString *)caption :(NSString *)imageSrc :(NSString *)imageLink :(NSString *)imageHRef;
-(void)postToFriendsFacebook:(NSString *)title :(NSString *)titleURL :(NSString *)caption :(NSString *)imageSrc :(NSString *)imageLink :(NSString *)imageHRef :(NSString *)fuid;
-(void)postToFacebook:(NSString *)status;
-(void)login;

- (void)getFacebookName;
-(void)getUserFriends;

@end
