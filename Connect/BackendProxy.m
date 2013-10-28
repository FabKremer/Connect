//
//  BackendProxy.m
//  Connect
//
//  Created by MacDev on 9/30/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import "BackendProxy.h"
#import "Reachability.h"

NSString * server = @"developmentpis.azurewebsites.net";

@implementation BackendProxy

+ (bool)internetConnection{
    //verifico conexion con el server
    Reachability *networkReachability = [Reachability reachabilityWithHostName:server];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable){
        //si no hay conexion con el server
        return false;
    }
    
    return true;
}

+ (serverResponse *)login:(NSString*)mail :(NSString*)password{
    
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          mail,@"Mail",
                          password, @"Password",
                          nil];
    
    NSString * url = @"http://";
    NSString * url1 = [server copy];
    url = [url stringByAppendingString:url1];
    url = [url stringByAppendingString:@"/api/Users/Login"];

    // POST
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:url]];
    
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
        
        NSNumber* userIdInt = [json objectForKey:@"Id"];
        int userIdInt1 = [userIdInt intValue];
        
        NSString *userId = [NSString stringWithFormat:@"%d", userIdInt1];
        
        NSString * userName = [json objectForKey:@"Name"];
        NSString * userMail = [json objectForKey:@"Mail"];
        NSString * userFacebook = [json objectForKey:@"FacebookId"];
        NSString * useLinkedin = [json objectForKey:@"LinkedInId"];
        NSString * userPassword = [json objectForKey:@"Password"];
        
        //me creo el objeto serverResponse
        serverResponse * sr = [serverResponse alloc];
        sr = [sr initialize :(NSInteger)urlResponse.statusCode :result :userId :userName : userMail :userFacebook :useLinkedin :userPassword];
        
        //******************
        //GUARDO EL USUARIO
        //*****************
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:userId forKey:@"id"];
        
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
                          mail,@"Mail",
                          facebook,@"FacebookId",
                          linkedin,@"LinkedInId",
                          password, @"Password",
                          nil];
    
    NSString * url = @"http://";
    NSString * url1 = [server copy];
    url = [url stringByAppendingString:url1];
    url = [url stringByAppendingString:@"/api/Users/SignUp"];
    
    // POST
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:url]];
    
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
        
        NSNumber* userIdInt = [json objectForKey:@"Id"];
        int userIdInt1 = [userIdInt intValue];
        
        NSString *userId = [NSString stringWithFormat:@"%d", userIdInt1];
        
        NSString * userName = [json objectForKey:@"Name"];
        NSString * userMail = [json objectForKey:@"Mail"];
        NSString * userFacebook = [json objectForKey:@"FacebookId"];
        NSString * useLinkedin = [json objectForKey:@"LinkedInId"];
        NSString * userPassword = [json objectForKey:@"Password"];
        
        //me creo el objeto serverResponse
        serverResponse * sr = [serverResponse alloc];
        sr = [sr initialize :(NSInteger)urlResponse.statusCode :result :userId :userName : userMail :userFacebook :useLinkedin :userPassword];
        
        //******************
        //GUARDO EL USUARIO
        //*****************
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:userId forKey:@"id"];
        
        
        return sr;
    }
    
    //me creo el objeto serverResponse cuando hubo error
    serverResponse * sr = [serverResponse alloc];
    sr = [sr initialize :(NSInteger)urlResponse.statusCode :NULL :NULL :NULL :NULL :NULL :NULL :NULL];
    
    return sr;
}

+ (serverResponse *)getUser :(NSString*)numId{
    
    NSString * s1 = @"http://";
    NSString * s2 = [server copy];
    s1 = [s1 stringByAppendingString:s2];
    s1 = [s1 stringByAppendingString:@"/api/Users/GetUser/"];
    s1 = [s1 stringByAppendingString:numId];
    
    
    NSURL * url = [NSURL URLWithString:s1];
    
    // GET
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:url];
    
    NSError *error;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    
    
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
        NSString * userMail = [json objectForKey:@"Mail"];
        NSString * userFacebook = [json objectForKey:@"FacebookId"];
        NSString * useLinkedin = [json objectForKey:@"LinkedInId"];
        NSString * userPassword = [json objectForKey:@"Password"];
        
        //me creo el objeto serverResponse
        serverResponse * sr = [serverResponse alloc];
        sr = [sr initialize :(NSInteger)urlResponse.statusCode :result :userId :userName : userMail :userFacebook :useLinkedin :userPassword];
        
        return sr;
    }
    
    //me creo el objeto serverResponse cuando hubo error
    serverResponse * sr = [serverResponse alloc];
    sr = [sr initialize :(NSInteger)urlResponse.statusCode :NULL :NULL :NULL :NULL :NULL :NULL :NULL];
    
    return sr;
}

+ (serverResponse *)getUserByMail:(NSString *)mail{
    
    
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          mail,@"Mail",
                          nil];
    
    NSString * url = @"http://";
    NSString * url1 = [server copy];
    url = [url stringByAppendingString:url1];
    url = [url stringByAppendingString:@"/api/Users/GetUserByMail"];
    
    // POST
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:url]];
    
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
        NSString * userMail = [json objectForKey:@"Mail"];
        NSString * userFacebook = [json objectForKey:@"FacebookId"];
        NSString * useLinkedin = [json objectForKey:@"LinkedInId"];
        NSString * userPassword = [json objectForKey:@"Password"];
        
        //me creo el objeto serverResponse
        serverResponse * sr = [serverResponse alloc];
        sr = [sr initialize :(NSInteger)urlResponse.statusCode :result :userId :userName : userMail :userFacebook :useLinkedin :userPassword];
    
        return sr;
    }
    
    //me creo el objeto serverResponse cuando hubo error
    serverResponse * sr = [serverResponse alloc];
    sr = [sr initialize :(NSInteger)urlResponse.statusCode :NULL :NULL :NULL :NULL :NULL :NULL :NULL];
    
    return sr;
}

+ (serverResponse *)addFriends:(NSString*)scanUser{
    
    //agarro el id del usario logeado
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * user = [defaults stringForKey:@"id"];
    
    //get del usuario
    serverResponse * srUser = [BackendProxy getUser:user];
    
    //get del usuario scaneado
    serverResponse * srScanUser = [BackendProxy getUser:scanUser];
    
    //si existe el id del susario escaneado
    if ([srScanUser getCodigo] == 200){
        //los hago amigos
        NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                              [srUser getMail],@"MailFrom",
                              [srScanUser getMail], @"MailTo",
                              nil];
    
        NSString * url = @"http://";
        NSString * url1 = [server copy];
        url = [url stringByAppendingString:url1];
        url = [url stringByAppendingString:@"/api/Friends/AddFriend"];
    
        // POST
        NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:url]];
    
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:info options:0 error:&error];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
    
        //NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
        // imprimo lo que mando para verificar
        NSLog(@"%@", [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]);
    
        NSHTTPURLResponse* urlResponse = nil;
        error = [[NSError alloc] init];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
        // imprimo el resultado del post para verificar
        NSLog(@"Response: %@", result);
        NSLog(@"Response: %ld", (long)urlResponse.statusCode);
    
        //verifico que devuelve el servidor
        if ((NSInteger)urlResponse.statusCode == 200){
            //si existen los dos mails y los hace amigos, devuelvo la informacion del usuario escaneado
            return srScanUser;
        }
        
        //me creo el objeto serverResponse cuando hubo error luego del addFriends
        serverResponse * sr = [serverResponse alloc];
        sr = [sr initialize :(NSInteger)urlResponse.statusCode :NULL :NULL :NULL :NULL :NULL :NULL :NULL];
        return sr;
        
    }
    
    //me creo el objeto serverResponse cuando hubo error luego del escaneo
    serverResponse * sr = [serverResponse alloc];
    sr = [sr initialize :[srScanUser getCodigo] :NULL :NULL :NULL :NULL :NULL :NULL :NULL];
    return sr;
    
}

@end
