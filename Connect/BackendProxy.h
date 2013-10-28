//
//  BackendProxy.h
//  Connect
//
//  Created by MacDev on 9/30/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "serverResponse.h"

@interface BackendProxy : NSObject{
    
}

+ (bool)internetConnection;
+ (serverResponse *)login :(NSString*)name :(NSString*)mail;
+ (serverResponse *)enterUser :(NSString*)name :(NSString*)mail :(NSString*)facebook :(NSString*)linkedin :(NSString*)password;
+ (serverResponse *)getUser :(NSString*)numId;
+ (serverResponse *)getUserByMail :(NSString*)mail;
+ (serverResponse *)addFriends:(NSString*)scanUser;

@end
