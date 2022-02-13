//
//  GeolocatorPlugin.m
//  RunnerTests
//
//  Created by Maurits van Beusekom on 08/02/2022.
//

@import geolocator_apple;
@import geolocator_apple.Private;
@import geolocator_apple.Test;
@import XCTest;

#import <CoreLocation/CoreLocation.h>
#import <OCMock/OCMock.h>

@interface GeolocatorPluginTests : XCTestCase

@end

@implementation GeolocatorPluginTests

#pragma mark - Test permission related methods

- (void)testCheckPermission {
  id mockPermissionHandler = OCMClassMock([PermissionHandler class]);
  GeolocatorPlugin *plugin = [[GeolocatorPlugin alloc] init];
  [plugin setPermissionHandlerOverride: mockPermissionHandler];
  
  OCMStub([mockPermissionHandler checkPermission]).andReturn(kCLAuthorizationStatusDenied);
    
  FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"checkPermission"
                                                              arguments:@{}];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"checkPermission should return denied permission index (which is 1)."];
  [plugin handleMethodCall:call
                               result:^(id  _Nullable result) {
    XCTAssertEqual(result, @1);
    [expectation fulfill];
  }];
  
  OCMVerify(times(1), [mockPermissionHandler checkPermission]);
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testRequestPermissionWithSuccess {
  id mockPermissionHandler = OCMClassMock([PermissionHandler class]);
  GeolocatorPlugin *plugin = [[GeolocatorPlugin alloc] init];
  [plugin setPermissionHandlerOverride:mockPermissionHandler];
  
  OCMStub([mockPermissionHandler requestPermission:([OCMArg invokeBlockWithArgs:@(kCLAuthorizationStatusAuthorizedAlways), nil]) errorHandler:[OCMArg any]]);
  
  FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"requestPermission"
                                                              arguments:@{}];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"requestPermission should return always permission index (which is 3)."];
  [plugin handleMethodCall:call
                    result:^(id  _Nullable result) {
    XCTAssertEqual(result, @3);
    [expectation fulfill];
  }];
  
  OCMVerify(times(1), [mockPermissionHandler requestPermission:[OCMArg any] errorHandler:[OCMArg any]]);
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testRequestPermissionWithError {
  id mockPermissionHandler = OCMClassMock([PermissionHandler class]);
  GeolocatorPlugin *plugin = [[GeolocatorPlugin alloc] init];
  [plugin setPermissionHandlerOverride:mockPermissionHandler];
  
  OCMStub([mockPermissionHandler requestPermission:[OCMArg any] errorHandler:([OCMArg invokeBlockWithArgs:@"error_code", @"error_description", nil])]);
  
  FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"requestPermission"
                                                              arguments:@{}];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"requestPermission should return error."];
  [plugin handleMethodCall:call
                    result:^(id  _Nullable result) {
    FlutterError *error = result;
    XCTAssertEqualObjects(error.code, @"error_code");
    XCTAssertEqualObjects(error.message, @"error_description");
    [expectation fulfill];
  }];
  
  OCMVerify(times(1), [mockPermissionHandler requestPermission:[OCMArg any] errorHandler:[OCMArg any]]);
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Test position related methods

- (void)testGetLastKnownPositionWithPermission {
  CLLocation *dummyLocation = [[CLLocation alloc] initWithLatitude:54.0 longitude:6.4];
  id mockGeolocationHandler = OCMClassMock([GeolocationHandler class]);
  id mockPermissionHandler = OCMClassMock([PermissionHandler class]);
  GeolocatorPlugin *plugin = [[GeolocatorPlugin alloc] init];
  [plugin setGeolocationHandlerOverride:mockGeolocationHandler];
  [plugin setPermissionHandlerOverride:mockPermissionHandler];
  
  OCMStub([mockPermissionHandler hasPermission]).andReturn(YES);
  OCMStub([mockGeolocationHandler getLastKnownPosition]).andReturn(dummyLocation);
  
  FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"getLastKnownPosition"
                                                              arguments:@{}];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"getLastKnownPosition should return location when permission are granted."];
  [plugin handleMethodCall:call result:^(id  _Nullable result) {
    XCTAssertEqualObjects(result[@"latitude"], @54.0);
    XCTAssertEqualObjects(result[@"longitude"], @6.4);
    [expectation fulfill];
  }];
  
  OCMVerify(times(1), [mockPermissionHandler hasPermission]);
  OCMVerify(times(1), [mockGeolocationHandler getLastKnownPosition]);
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGetLastKnownPositionWithoutPermission {
  id mockGeolocationHandler = OCMClassMock([GeolocationHandler class]);
  id mockPermissionHandler = OCMClassMock([PermissionHandler class]);
  GeolocatorPlugin *plugin = [[GeolocatorPlugin alloc] init];
  [plugin setGeolocationHandlerOverride:mockGeolocationHandler];
  [plugin setPermissionHandlerOverride:mockPermissionHandler];
  
  OCMStub([mockPermissionHandler hasPermission]).andReturn(NO);
  
  FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"getLastKnownPosition"
                                                              arguments:@{}];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"getLastKnownPosition should return error when permission are denied."];
  [plugin handleMethodCall:call result:^(id  _Nullable result) {
    FlutterError *error = result;
    XCTAssertEqualObjects(error.code, @"PERMISSION_DENIED");
    XCTAssertEqualObjects(error.message, @"User denied permissions to access the device's location.");
    [expectation fulfill];
  }];
  
  OCMVerify(times(1), [mockPermissionHandler hasPermission]);
  OCMVerify(never(), [mockGeolocationHandler getLastKnownPosition]);
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGetCurrentPositionWithoutPermission {
  id mockGeolocationHandler = OCMClassMock([GeolocationHandler class]);
  id mockPermissionHandler = OCMClassMock([PermissionHandler class]);
  GeolocatorPlugin *plugin = [[GeolocatorPlugin alloc] init];
  [plugin setGeolocationHandlerOverride:mockGeolocationHandler];
  [plugin setPermissionHandlerOverride:mockPermissionHandler];
  
  OCMStub([mockPermissionHandler hasPermission]).andReturn(NO);
  
  FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"getCurrentPosition"
                                                              arguments:@{}];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"getCurrentPosition should return error when permission are denied."];
  [plugin handleMethodCall:call result:^(id  _Nullable result) {
    FlutterError *error = result;
    XCTAssertEqualObjects(error.code, @"PERMISSION_DENIED");
    XCTAssertEqualObjects(error.message, @"User denied permissions to access the device's location.");
    [expectation fulfill];
  }];
  
  OCMVerify(times(1), [mockPermissionHandler hasPermission]);
  OCMVerify(never(), [mockGeolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest resultHandler:[OCMArg any] errorHandler:[OCMArg any]]);
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGetCurrentPositionWithPermissionAndSpecifyingAccuracy {
  CLLocation *dummyLocation = [[CLLocation alloc] initWithLatitude:54.0 longitude:6.4];
  id mockGeolocationHandler = OCMClassMock([GeolocationHandler class]);
  id mockPermissionHandler = OCMClassMock([PermissionHandler class]);
  GeolocatorPlugin *plugin = [[GeolocatorPlugin alloc] init];
  [plugin setGeolocationHandlerOverride:mockGeolocationHandler];
  [plugin setPermissionHandlerOverride:mockPermissionHandler];
  
  OCMStub([mockPermissionHandler hasPermission]).andReturn(YES);
  OCMStub([mockGeolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyHundredMeters
                                                       resultHandler:([OCMArg invokeBlockWithArgs:dummyLocation, nil])
                                                        errorHandler:[OCMArg any]]);
  
  FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"getCurrentPosition"
                                                              arguments:@{@"accuracy" : @2}];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"getCurrentPosition should return dummy location when permission are granted."];
  [plugin handleMethodCall:call result:^(id  _Nullable result) {
    XCTAssertEqualObjects(result[@"latitude"], @54.0);
    XCTAssertEqualObjects(result[@"longitude"], @6.4);
    [expectation fulfill];
  }];
  
  OCMVerify(times(1), [mockPermissionHandler hasPermission]);
  OCMVerify(times(1), [mockGeolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyHundredMeters resultHandler:[OCMArg any] errorHandler:[OCMArg any]]);
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGetCurrentPositionWithPermissionWhenErrorOccurs {
  id mockGeolocationHandler = OCMClassMock([GeolocationHandler class]);
  id mockPermissionHandler = OCMClassMock([PermissionHandler class]);
  GeolocatorPlugin *plugin = [[GeolocatorPlugin alloc] init];
  [plugin setGeolocationHandlerOverride:mockGeolocationHandler];
  [plugin setPermissionHandlerOverride:mockPermissionHandler];
  
  OCMStub([mockPermissionHandler hasPermission]).andReturn(YES);
  OCMStub([mockGeolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyHundredMeters
                                                       resultHandler:[OCMArg any]
                                                        errorHandler:([OCMArg invokeBlockWithArgs:@"error_code", @"error_description", nil])]);
  
  FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"getCurrentPosition"
                                                              arguments:@{@"accuracy" : @2}];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"getCurrentPosition should return a FlutterError when GeolocationHandler receives an error."];
  [plugin handleMethodCall:call result:^(id  _Nullable result) {
    FlutterError *error = result;
    XCTAssertEqualObjects(error.code, @"error_code");
    XCTAssertEqualObjects(error.message, @"error_description");
    [expectation fulfill];
  }];
  
  OCMVerify(times(1), [mockPermissionHandler hasPermission]);
  OCMVerify(times(1), [mockGeolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyHundredMeters resultHandler:[OCMArg any] errorHandler:[OCMArg any]]);
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Test location accuracy specific methods

- (void)testGetLocationAccuracy {
  id mockLocationAccuracyHandler = OCMClassMock([LocationAccuracyHandler class]);
  GeolocatorPlugin *plugin = [[GeolocatorPlugin alloc] init];
  [plugin setLocationAccuracyHandlerOverride:mockLocationAccuracyHandler];
  
  OCMStub([mockLocationAccuracyHandler getLocationAccuracyWithResult:([OCMArg invokeBlockWithArgs:@((LocationAccuracy)precise), nil])]);
  
  FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"getLocationAccuracy"
                                                              arguments:@{}];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"getLocationAccuracy should return precise location accuracy."];
  [plugin handleMethodCall:call result:^(id  _Nullable result) {
    XCTAssertEqualObjects(result, @((LocationAccuracy)precise));
    [expectation fulfill];
  }];
  
  OCMVerify(times(1), [mockLocationAccuracyHandler getLocationAccuracyWithResult:[OCMArg any]]);
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testRequestTemporaryFullAccuracyWithPurposeKey {
  id mockLocationAccuracyHandler = OCMClassMock([LocationAccuracyHandler class]);
  GeolocatorPlugin *plugin = [[GeolocatorPlugin alloc] init];
  [plugin setLocationAccuracyHandlerOverride:mockLocationAccuracyHandler];
  
  OCMStub([mockLocationAccuracyHandler requestTemporaryFullAccuracyWithResult:([OCMArg invokeBlockWithArgs:@((LocationAccuracy)precise), nil])
                                                                   purposeKey:[OCMArg any]]);
  
  FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"requestTemporaryFullAccuracy"
                                                              arguments:@{@"purposeKey" : @"dummy_key"}];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"requestTemporaryFullAccuracy should return precise location accuracy."];
  [plugin handleMethodCall:call result:^(id  _Nullable result) {
    XCTAssertEqualObjects(result, @((LocationAccuracy)precise));
    [expectation fulfill];
  }];
  
  OCMVerify(times(1), [mockLocationAccuracyHandler requestTemporaryFullAccuracyWithResult:[OCMArg any]
                                                                               purposeKey:@"dummy_key"]);
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testRequestTemporaryFullAccuracyWithouPurposeKey {
  id mockLocationAccuracyHandler = OCMClassMock([LocationAccuracyHandler class]);
  GeolocatorPlugin *plugin = [[GeolocatorPlugin alloc] init];
  [plugin setLocationAccuracyHandlerOverride:mockLocationAccuracyHandler];
  
  OCMStub([mockLocationAccuracyHandler requestTemporaryFullAccuracyWithResult:([OCMArg invokeBlockWithArgs:@((LocationAccuracy)precise), nil])
                                                                   purposeKey:[OCMArg any]]);
  
  FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"requestTemporaryFullAccuracy"
                                                              arguments:@{}];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"requestTemporaryFullAccuracy should return precise location accuracy."];
  [plugin handleMethodCall:call result:^(id  _Nullable result) {
    XCTAssertEqualObjects(result, @((LocationAccuracy)precise));
    [expectation fulfill];
  }];
  
  OCMVerify(times(1), [mockLocationAccuracyHandler requestTemporaryFullAccuracyWithResult:[OCMArg any]
                                                                               purposeKey:nil]);
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testRequestTemporaryFullAccuracyWithInvalidArgument {
  id mockLocationAccuracyHandler = OCMClassMock([LocationAccuracyHandler class]);
  GeolocatorPlugin *plugin = [[GeolocatorPlugin alloc] init];
  [plugin setLocationAccuracyHandlerOverride:mockLocationAccuracyHandler];
  
  OCMStub([mockLocationAccuracyHandler requestTemporaryFullAccuracyWithResult:([OCMArg invokeBlockWithArgs:@((LocationAccuracy)precise), nil])
                                                                   purposeKey:[OCMArg any]]);
  
  FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"requestTemporaryFullAccuracy"
                                                              arguments:@{@"invalid_key" : @"invalid_key"}];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"requestTemporaryFullAccuracy should return precise location accuracy."];
  [plugin handleMethodCall:call result:^(id  _Nullable result) {
    XCTAssertEqualObjects(result, @((LocationAccuracy)precise));
    [expectation fulfill];
  }];
  
  OCMVerify(times(1), [mockLocationAccuracyHandler requestTemporaryFullAccuracyWithResult:[OCMArg any]
                                                                               purposeKey:nil]);
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Test open setting related methods

- (void)testOpenAppSettings {
  if (@available(iOS 10, *))
  {
    id mockApplication = OCMClassMock([UIApplication class]);
    OCMStub([mockApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                             options:@{}
                   completionHandler:([OCMArg invokeBlockWithArgs:@(YES), nil])]);
    OCMStub(ClassMethod([mockApplication sharedApplication])).andReturn(mockApplication);
    
      
    FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"openAppSettings"
                                                                arguments:@{}];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"openAppSettings should return yes."];
    GeolocatorPlugin *plugin = [[GeolocatorPlugin alloc] init];
    [plugin handleMethodCall:call result:^(id  _Nullable result) {
      XCTAssertTrue(result);
      [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    return;
  }
  
  if (@available(iOS 8, *)) {
    id mockApplication = OCMClassMock([UIApplication class]);
    OCMStub([mockApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]).andReturn(YES);
    OCMStub(ClassMethod([mockApplication sharedApplication])).andReturn(mockApplication);
    
      
    FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"openAppSettings"
                                                                arguments:@{}];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"openAppSettings should return yes."];
    GeolocatorPlugin *plugin = [[GeolocatorPlugin alloc] init];
    [plugin handleMethodCall:call result:^(id  _Nullable result) {
      XCTAssertTrue(result);
      [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    return;
  }
  
  FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"openAppSettings"
                                                              arguments:@{}];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"openAppSettings should return yes."];
  GeolocatorPlugin *plugin = [[GeolocatorPlugin alloc] init];
  [plugin handleMethodCall:call result:^(id  _Nullable result) {
    XCTAssertFalse(result);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
  return;
}

- (void)testOpenLocationSettings {
  if (@available(iOS 10, *))
  {
    id mockApplication = OCMClassMock([UIApplication class]);
    OCMStub([mockApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                             options:@{}
                   completionHandler:([OCMArg invokeBlockWithArgs:@(YES), nil])]);
    OCMStub(ClassMethod([mockApplication sharedApplication])).andReturn(mockApplication);
    
      
    FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"openLocationSettings"
                                                                arguments:@{}];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"openLocationSettings should return yes."];
    GeolocatorPlugin *plugin = [[GeolocatorPlugin alloc] init];
    [plugin handleMethodCall:call result:^(id  _Nullable result) {
      XCTAssertTrue(result);
      [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    return;
  }
  
  if (@available(iOS 8, *)) {
    id mockApplication = OCMClassMock([UIApplication class]);
    OCMStub([mockApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]).andReturn(YES);
    OCMStub(ClassMethod([mockApplication sharedApplication])).andReturn(mockApplication);
    
      
    FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"openLocationSettings"
                                                                arguments:@{}];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"openLocationSettings should return yes."];
    GeolocatorPlugin *plugin = [[GeolocatorPlugin alloc] init];
    [plugin handleMethodCall:call result:^(id  _Nullable result) {
      XCTAssertTrue(result);
      [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    return;
  }
  
  FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"openLocationSettings"
                                                              arguments:@{}];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"openLocationSettings should return yes."];
  GeolocatorPlugin *plugin = [[GeolocatorPlugin alloc] init];
  [plugin handleMethodCall:call result:^(id  _Nullable result) {
    XCTAssertFalse(result);
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
  return;
}

@end
