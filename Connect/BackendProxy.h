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

+ (serverResponse *)login :(NSString*)name :(NSString*)mail;
+ (serverResponse *)enterUser :(NSString*)name :(NSString*)mail :(NSString*)facebook :(NSString*)linkedin :(NSString*)password;

@end
