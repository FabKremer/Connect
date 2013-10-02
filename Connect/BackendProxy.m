//
//  BackendProxy.m
//  Connect
//
//  Created by MacDev on 9/30/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import "BackendProxy.h"

@implementation BackendProxy


+ (serverResponse *)login:(NSString*)mail :(NSString*)password{

    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          mail,@"Email",
                          password, @"Password",
                          nil];
    
    // POST
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:@"http://testpis.azurewebsites.net/api/login/"]];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:info options:0 error:&error];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    //NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // imprimo lo que mando para verificar
    //NSLog(@"%@", [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]);
    
    NSHTTPURLResponse* urlResponse = nil;
    error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    // imprimo el resultado del post para verificar
    //NSLog(@"Response: %@", result);
    //NSLog(@"Response: %ld", (long)urlResponse.statusCode);
    
    //si el server devuelve un usuario
    if ((NSInteger)urlResponse.statusCode == 200){
        
        //paso el NSData que devuelve el servidor a un NSDictionary para agarrar los datos del JSON
        NSError* error1;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:responseData //1
                              options:kNilOptions
                              error:&error1];
        
        //agarro los datos del dictinary
        NSString * userId = [json objectForKey:@"Id"];
        NSString * userName = [json objectForKey:@"Name"];
        NSString * userMail = [json objectForKey:@"Email"];
        NSString * userFacebook = [json objectForKey:@"FacebookId"];
        NSString * useLinkedin = [json objectForKey:@"LinkedInId"];
        NSString * userPassword = [json objectForKey:@"Password"];
        
        //me creo el objeto serverResponse
        serverResponse * sr = [serverResponse alloc];
        sr = [sr initialize :(NSInteger)urlResponse.statusCode :result :userId :userName : userMail :userFacebook :useLinkedin :userPassword];
        
        //******************
        //GUARDO EL USUARIO
        //*****************
        
        return sr;
    }
    
    //me creo el objeto serverResponse cuando hubo error
    serverResponse * sr = [serverResponse alloc];
    sr = [sr initialize :(NSInteger)urlResponse.statusCode :NULL :NULL :NULL :NULL :NULL :NULL :NULL];
    
    return sr;
}


+ (serverResponse *)enterUser:(NSString*)name :(NSString*)mail :(NSString*)facebook :(NSString*)linkedin :(NSString*)password{
    
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          name,@"Name",
                          mail,@"Email",
                          facebook,@"FacebookId",
                          linkedin,@"LinkedInId",
                          password, @"Password",
                          nil];

    
    // POST
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:@"http://testpis.azurewebsites.net/api/signup/"]];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:info options:0 error:&error];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    // imprimo lo que mando para verificar
    //NSLog(@"%@", [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]);
    
    NSHTTPURLResponse* urlResponse = nil;
    error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    // imprimo el resultado del post para verificar
    //NSLog(@"Response: %@", result);
    //NSLog(@"Response: %ld", (long)urlResponse.statusCode);
    
    //si el server devuelve un usuario
    if ((NSInteger)urlResponse.statusCode == 200){
        
        //paso el NSData que devuelve el servidor a un NSDictionary para agarrar los datos del JSON
        NSError* error1;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:responseData //1
                              options:kNilOptions
                              error:&error1];
    
        //agarro los datos del dictinary
        NSString * userId = [json objectForKey:@"Id"];
        NSString * userName = [json objectForKey:@"Name"];
        NSString * userMail = [json objectForKey:@"Email"];
        NSString * userFacebook = [json objectForKey:@"FacebookId"];
        NSString * useLinkedin = [json objectForKey:@"LinkedInId"];
        NSString * userPassword = [json objectForKey:@"Password"];
    
        //me creo el objeto serverResponse
        serverResponse * sr = [serverResponse alloc];
        sr = [sr initialize :(NSInteger)urlResponse.statusCode :result :userId :userName : userMail :userFacebook :useLinkedin :userPassword];
        
        //******************
        //GUARDO EL USUARIO
        //*****************
    
        return sr;
    }
    
    //me creo el objeto serverResponse cuando hubo error
    serverResponse * sr = [serverResponse alloc];
    sr = [sr initialize :(NSInteger)urlResponse.statusCode :NULL :NULL :NULL :NULL :NULL :NULL :NULL];
    
    return sr;
}


@end
