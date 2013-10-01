//
//  serverResponse.m
//  Connect
//
//  Created by MacDev on 10/1/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import "serverResponse.h"

@implementation serverResponse

- (id)initialize :(NSInteger)c :(NSString*)j :(NSString*)i :(NSString*)n :(NSString*)m :(NSString*)f :(NSString*)l :(NSString*)p{
    
    if (self == [super init]){
        codigo = c;
        json = j;
        numId = i;
        name = n;
        mail = m;
        facebook = f;
        linkedin = l;
        password = p;
    }
    return self;
}

- (NSInteger)getCodigo{
    return codigo;
}

- (NSString *)getJson{
    return json;
}

- (NSString *)getNumId{
    return numId;
}

- (NSString *)getName{
    return name;
}

- (NSString *)getMail{
    return mail;
}

- (NSString *)getFacebook{
    return facebook;
}

- (NSString *)getLinkedin{
    return linkedin;
}

- (NSString *)getPassword{
    return password;
}

@end
