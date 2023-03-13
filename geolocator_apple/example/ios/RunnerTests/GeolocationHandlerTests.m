//
//  RunnerTests.m
//  RunnerTests
//
//  Created by Maurits van Beusekom on 07/02/2022.
//

@import geolocator_apple;
@import geolocator_apple.Private;
@import geolocator_apple.Test;
@import XCTest;

#import <OCMock/OCMock.h>
#import <CoreLocation/CoreLocation.h>

@interface GeolocationHandlerTests : XCTestCase

@end

@implementation GeolocationHandlerTests {
  CLLocationManager *_mockLocationManager;
  GeolocationHandler *_geolocationHandler;
}

- (void)setUp {
  _mockLocationManager = OCMClassMock(CLLocationManager.class);
  
  _geolocationHandler = [[GeolocationHandler alloc] init];
  [_geolocationHandler setLocationManagerOverride:_mockLocationManager];
}

#pragma mark - Test requesting current location

- (void)testGetCurrentPositionShouldCallStartUpdatingLocation {
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable location) {}
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {}];
  
  OCMVerify(times(1), [self->_mockLocationManager setDesiredAccuracy:kCLLocationAccuracyBest]);
  OCMVerify(times(1), [self->_mockLocationManager startUpdatingLocation]);
}

- (void)testRequestPositionShouldReturnLocationWithinTimeConstraints {
  NSDate *now = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
    
  CLLocation *firstLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(54.0, 6.4)
                                                            altitude:0.0
                                                  horizontalAccuracy:0
                                                    verticalAccuracy:0
                                                           timestamp:[calendar dateByAddingUnit:NSCalendarUnitSecond value:-6 toDate:now options:0]];
  CLLocation *secondLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(54.1, 6.4)
                                                            altitude:0.0
                                                  horizontalAccuracy:0
                                                    verticalAccuracy:0
                                                           timestamp:now];

  
  XCTestExpectation *expectation = [self expectationWithDescription:@"expect result return third location"];
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable location) {
    XCTAssertEqual(location, secondLocation);
    [expectation fulfill];
  }
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {}];
  
  [_geolocationHandler locationManager:_mockLocationManager didUpdateLocations: @[firstLocation]];
  [_geolocationHandler locationManager:_mockLocationManager didUpdateLocations: @[secondLocation]];
    
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
  
  OCMVerify(times(1), [self->_mockLocationManager stopUpdatingLocation]);
}

- (void)testRequestPositionShouldStopListeningOnResult {
  CLLocation *location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(54.1, 6.4)
                                                            altitude:0.0
                                                  horizontalAccuracy:0
                                                    verticalAccuracy:0
                                                           timestamp:[NSDate date]];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"expect first result return third location"];
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable location) {
    [expectation fulfill];
  }
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
    
  }];
  
  [_geolocationHandler locationManager:_mockLocationManager didUpdateLocations: @[location]];
  
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
  
  OCMVerify(times(1), [self->_mockLocationManager stopUpdatingLocation]);
}

- (void)testRequestPositionShouldStopListeningOnError {
  NSError *error = [NSError errorWithDomain:kCLErrorDomain code:kCLErrorDenied userInfo:nil];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"expect result return third location"];
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable location) {
  }
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
    [expectation fulfill];
    
  }];
  
  [_geolocationHandler locationManager:_mockLocationManager didFailWithError: error];
  
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
  
  OCMVerify(times(1), [self->_mockLocationManager stopUpdatingLocation]);
}

- (void)testRequestPositionShouldNotStopListeningOnErrorDomainAndErrorLocationUnknown {
  NSError *error = [NSError errorWithDomain:kCLErrorDomain code:kCLErrorLocationUnknown userInfo:nil];
  
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable location) {
  }
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
    XCTFail();
  }];
  
  [_geolocationHandler locationManager:_mockLocationManager didFailWithError: error];
}


#pragma mark - Test listening to location stream

- (void)testStartListeningShouldNotStopListeningWhenListeningToStream {
  CLLocation *mockLocation = [[CLLocation alloc] initWithLatitude:54.0 longitude:6.4];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"expect result return third location"];
  [_geolocationHandler startListeningWithDesiredAccuracy: kCLLocationAccuracyBest
                                          distanceFilter:0
                       pauseLocationUpdatesAutomatically:NO
                         showBackgroundLocationIndicator:NO
                                            activityType:CLActivityTypeOther
                          allowBackgroundLocationUpdates:NO
                                           resultHandler:^(CLLocation * _Nullable location) {
    XCTAssertEqual(location, mockLocation);
    [expectation fulfill];
  }
                                            errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
    
  }];
  
  [_geolocationHandler locationManager:_mockLocationManager didUpdateLocations: @[mockLocation]];
  
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
  
  OCMVerify(never(), [self->_mockLocationManager stopUpdatingLocation]);
}

- (void)testRequestingPositionWhileListeningDoesntStopStream {
  CLLocation *mockLocation = [[CLLocation alloc] initWithLatitude:54.0 longitude:6.4];
  XCTestExpectation *expectationStream = [self expectationWithDescription:@"expect result return third location"];
    XCTestExpectation *expectationForeground = [self expectationWithDescription:@"expect result return third location"];
  [_geolocationHandler startListeningWithDesiredAccuracy: kCLLocationAccuracyBest
                                          distanceFilter:0
                       pauseLocationUpdatesAutomatically:NO
                         showBackgroundLocationIndicator:NO
                                            activityType:CLActivityTypeOther
                          allowBackgroundLocationUpdates:NO
                                           resultHandler:^(CLLocation * _Nullable location) {
    XCTAssertEqual(location, mockLocation);
    [expectationStream fulfill];
  }
                                            errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
    
  }];
    
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyHundredMeters
                                            resultHandler:^(CLLocation * _Nullable location) {
      XCTAssertEqual(location, mockLocation);
      [expectationForeground fulfill];
    } errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
        
    }];
  [_geolocationHandler locationManager:_mockLocationManager didUpdateLocations: @[mockLocation]];
  
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
  
  OCMVerify(never(), [self->_mockLocationManager stopUpdatingLocation]);
}

- (void)testStartListeningShouldNotStopListeningOnError {
  NSError *error = [NSError errorWithDomain:kCLErrorDomain code:kCLErrorDenied userInfo:nil];
  XCTestExpectation *expectation = [self expectationWithDescription:@"expect result return third location"];
  [_geolocationHandler startListeningWithDesiredAccuracy: kCLLocationAccuracyBest
                                          distanceFilter:0
                       pauseLocationUpdatesAutomatically:NO
                         showBackgroundLocationIndicator:NO
                                            activityType:CLActivityTypeOther
                          allowBackgroundLocationUpdates:NO
                                           resultHandler:^(CLLocation * _Nullable location) {
  }
                                            errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
    XCTAssertEqualObjects(errorCode, @"LOCATION_UPDATE_FAILURE");
    [expectation fulfill];
  }];
  
  [_geolocationHandler locationManager:_mockLocationManager didFailWithError:error];
  
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
  
  OCMVerify(never(), [self->_mockLocationManager stopUpdatingLocation]);
}

- (void)testStartListeningShouldNotReportErrorOnErrorDomainAndErrorLocationUnknown {
  NSError *error = [NSError errorWithDomain:kCLErrorDomain code:kCLErrorLocationUnknown userInfo:nil];
  CLLocation *mockLocation = [[CLLocation alloc] initWithLatitude:54.0 longitude:6.4];
  XCTestExpectation *expectation = [self expectationWithDescription:@"expect result return third location"];
  [_geolocationHandler startListeningWithDesiredAccuracy: kCLLocationAccuracyBest
                                          distanceFilter:0
                       pauseLocationUpdatesAutomatically:NO
                         showBackgroundLocationIndicator:NO
                                            activityType:CLActivityTypeOther
                          allowBackgroundLocationUpdates:NO
                                           resultHandler:^(CLLocation * _Nullable location) {
    [expectation fulfill];
  }
                                            errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
    XCTFail();
  }];
  
  [_geolocationHandler locationManager:_mockLocationManager didFailWithError:error];
  [_geolocationHandler locationManager:_mockLocationManager didUpdateLocations: @[mockLocation]];
  
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
  
  OCMVerify(never(), [self->_mockLocationManager stopUpdatingLocation]);
}

- (void)testListeningBackgroundGeolocationOnlyWhenAllowedAndEnabled {
    id geolocationHandlerMock = OCMPartialMock(_geolocationHandler);
    [geolocationHandlerMock setLocationManagerOverride:_mockLocationManager];
    OCMStub(ClassMethod([geolocationHandlerMock shouldEnableBackgroundLocationUpdates]))._andReturn([NSNumber numberWithBool:YES]);
    [geolocationHandlerMock startListeningWithDesiredAccuracy: kCLLocationAccuracyBest
                                            distanceFilter:0
                         pauseLocationUpdatesAutomatically:NO
                           showBackgroundLocationIndicator:NO
                                              activityType:CLActivityTypeOther
                            allowBackgroundLocationUpdates:YES
                                             resultHandler:^(CLLocation * _Nullable location) {
    }
                                              errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
      
    }];
    OCMVerify([_mockLocationManager setAllowsBackgroundLocationUpdates:YES]);
}

- (void)testNotListeningBackgroundGeolocationWhenNotEnabled {
    id geolocationHandlerMock = OCMPartialMock(_geolocationHandler);
    [geolocationHandlerMock setLocationManagerOverride:_mockLocationManager];
    OCMStub(ClassMethod([geolocationHandlerMock shouldEnableBackgroundLocationUpdates]))._andReturn([NSNumber numberWithBool:YES]);
    [geolocationHandlerMock startListeningWithDesiredAccuracy: kCLLocationAccuracyBest
                                            distanceFilter:0
                         pauseLocationUpdatesAutomatically:NO
                           showBackgroundLocationIndicator:NO
                                              activityType:CLActivityTypeOther
                            allowBackgroundLocationUpdates:NO
                                             resultHandler:^(CLLocation * _Nullable location) {
    }
                                              errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
      
    }];
    OCMVerify(never(), [_mockLocationManager setAllowsBackgroundLocationUpdates:YES]);
}

- (void)testKeepLocationManagerSettingsWhenRequestingCurrentPosition {
  id geolocationHandlerMock = OCMPartialMock(_geolocationHandler);
  [geolocationHandlerMock setLocationManagerOverride:_mockLocationManager];
  OCMStub(ClassMethod([geolocationHandlerMock shouldEnableBackgroundLocationUpdates]))
    ._andReturn([NSNumber numberWithBool:YES]);
  OCMStub([_mockLocationManager allowsBackgroundLocationUpdates])
    ._andReturn([NSNumber numberWithBool:YES]);
  if (@available(iOS 11.0, *)) {
    OCMStub([_mockLocationManager showsBackgroundLocationIndicator])
      ._andReturn([NSNumber numberWithBool:YES]);
  }
  [geolocationHandlerMock startListeningWithDesiredAccuracy: kCLLocationAccuracyBest
                                          distanceFilter:0
                       pauseLocationUpdatesAutomatically:NO
                         showBackgroundLocationIndicator:YES
                                            activityType:CLActivityTypeOther
                          allowBackgroundLocationUpdates:YES
                                           resultHandler:^(CLLocation * _Nullable location) {
  }
                                            errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
    
  }];
  OCMVerify([_mockLocationManager setAllowsBackgroundLocationUpdates:YES]);
  if (@available(iOS 11.0, *)) {
    OCMVerify([_mockLocationManager setShowsBackgroundLocationIndicator:YES]);
  }
  [geolocationHandlerMock requestPositionWithDesiredAccuracy: kCLLocationAccuracyBest
                                               resultHandler:^(CLLocation * _Nullable location) {}
                                                errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {}];
  OCMVerify(never(), [_mockLocationManager setAllowsBackgroundLocationUpdates:NO]);
  if (@available(iOS 11.0, *)) {
    OCMVerify(never(), [_mockLocationManager setShowsBackgroundLocationIndicator:NO]);
  }
}

@end
