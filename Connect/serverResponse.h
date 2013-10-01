//
//  serverResponse.h
//  Connect
//
//  Created by MacDev on 10/1/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface serverResponse : NSObject{
    
    NSInteger codigo;
    NSString *json;
    NSString *numId;
    NSString *name;
    NSString *mail;
    NSString *facebook;
    NSString *linkedin;
    NSString *password;
    
}

- (id)initialize :(NSInteger)c :(NSString*)j :(NSString*)i :(NSString*)n :(NSString*)m :(NSString*)f :(NSString*)l :(NSString*)p;
- (NSInteger)getCodigo;
- (NSString *)getJson;
- (NSString *)getNumId;
- (NSString *)getName;
- (NSString *)getMail;
- (NSString *)getFacebook;
- (NSString *)getLinkedin;
- (NSString *)getPassword;

@end
