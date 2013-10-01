//
//  Connect_Tests.m
//  Connect Tests
//
//  Created by MacDev on 9/30/13.
//  Copyright (c) 2013 PIS. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BackendProxy.h"
#import "serverResponse.h"

@interface Connect_Tests : XCTestCase{
@private
    serverResponse *sr;
}
@end

@implementation Connect_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testLogIn1{
    
    NSString * mail = @"gabriel.fa07@gmail.com";
    NSString * password = @"pass";
    
    sr = [BackendProxy login :mail :password];
    
    NSLog(@"primer test");
    //XCTAssertEqual([sr getNumId], @"1", @"No conncide el id");
    XCTAssertTrue((1 == 2), @"");
}

@end
