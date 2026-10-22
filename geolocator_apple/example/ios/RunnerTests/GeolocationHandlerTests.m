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
  CLLocationManager *_mockOneTimeLocationManager;
  
  GeolocationHandler *_geolocationHandler;
}

- (void)setUp {
  _mockLocationManager = OCMClassMock(CLLocationManager.class);
  _mockOneTimeLocationManager = OCMClassMock(CLLocationManager.class);
  
  _geolocationHandler = [[GeolocationHandler alloc] init];
  [_geolocationHandler setLocationManagerOverride:_mockLocationManager];
  [_geolocationHandler setOneTimeLocationManagerOverride:_mockOneTimeLocationManager];
}

#pragma mark - Test requesting current location

- (void)testGetCurrentPositionShouldCallStartUpdatingLocation {
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable location) {}
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {}];
  
  OCMVerify(times(1), [self->_mockOneTimeLocationManager setDesiredAccuracy:kCLLocationAccuracyBest]);
  OCMVerify(times(1), [self->_mockOneTimeLocationManager startUpdatingLocation]);
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
  
  [_geolocationHandler locationManager:_mockOneTimeLocationManager didUpdateLocations: @[firstLocation]];
  [_geolocationHandler locationManager:_mockOneTimeLocationManager didUpdateLocations: @[secondLocation]];
  
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
  
  OCMVerify(times(1), [self->_mockOneTimeLocationManager stopUpdatingLocation]);
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
  
  [_geolocationHandler locationManager:_mockOneTimeLocationManager didUpdateLocations: @[location]];
  
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
  
  OCMVerify(times(1), [self->_mockOneTimeLocationManager stopUpdatingLocation]);
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
  
  [_geolocationHandler locationManager:_mockOneTimeLocationManager didFailWithError: error];
  
  [self waitForExpectationsWithTimeout:5.0 handler:nil];
  
  OCMVerify(times(1), [self->_mockOneTimeLocationManager stopUpdatingLocation]);
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

- (void)testRequestPositionShouldFailWhenLocationStaysUnknownPastGracePeriod {
  NSError *error = [NSError errorWithDomain:kCLErrorDomain code:kCLErrorLocationUnknown userInfo:nil];
  [_geolocationHandler setLocationUnknownGracePeriodOverride:0.1];

  XCTestExpectation *expectation = [self expectationWithDescription:@"expect the request to fail once the grace period elapses"];
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable location) {
    XCTFail(@"no position was reported");
  }
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
    XCTAssertEqualObjects(errorCode, GeolocatorErrorLocationUpdateFailure);
    [expectation fulfill];
  }];

  // Core Location keeps reporting the error while it cannot determine a position.
  [_geolocationHandler locationManager:_mockOneTimeLocationManager didFailWithError: error];
  [_geolocationHandler locationManager:_mockOneTimeLocationManager didFailWithError: error];

  [self waitForExpectationsWithTimeout:5.0 handler:nil];

  OCMVerify(times(1), [self->_mockOneTimeLocationManager stopUpdatingLocation]);
}

- (void)testRequestPositionShouldReturnLocationArrivingWithinGracePeriod {
  NSError *error = [NSError errorWithDomain:kCLErrorDomain code:kCLErrorLocationUnknown userInfo:nil];
  CLLocation *location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(54.1, 6.4)
                                                       altitude:0.0
                                             horizontalAccuracy:0
                                               verticalAccuracy:0
                                                      timestamp:[NSDate date]];
  [_geolocationHandler setLocationUnknownGracePeriodOverride:0.2];

  XCTestExpectation *resultExpectation = [self expectationWithDescription:@"expect the location to be returned"];
  XCTestExpectation *errorExpectation = [self expectationWithDescription:@"expect no error after the grace period"];
  errorExpectation.inverted = YES;
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable result) {
    XCTAssertEqual(result, location);
    [resultExpectation fulfill];
  }
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
    [errorExpectation fulfill];
  }];

  [_geolocationHandler locationManager:_mockOneTimeLocationManager didFailWithError: error];
  [_geolocationHandler locationManager:_mockOneTimeLocationManager didUpdateLocations: @[location]];

  [self waitForExpectations:@[resultExpectation, errorExpectation] timeout:1.0];
}

- (void)testGracePeriodOfPreviousRequestShouldNotFailTheNextRequest {
  NSError *error = [NSError errorWithDomain:kCLErrorDomain code:kCLErrorLocationUnknown userInfo:nil];
  [_geolocationHandler setLocationUnknownGracePeriodOverride:0.2];

  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable location) {}
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {}];
  [_geolocationHandler locationManager:_mockOneTimeLocationManager didFailWithError: error];

  // A new request replaces the pending one before its grace period elapses.
  XCTestExpectation *errorExpectation = [self expectationWithDescription:@"expect the new request not to fail"];
  errorExpectation.inverted = YES;
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable location) {}
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
    [errorExpectation fulfill];
  }];

  [self waitForExpectations:@[errorExpectation] timeout:0.5];
}


- (void)testConcurrentRequestsShouldAllReceiveTheLocation {
  CLLocation *location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(54.1, 6.4)
                                                       altitude:0.0
                                             horizontalAccuracy:0
                                               verticalAccuracy:0
                                                      timestamp:[NSDate date]];

  XCTestExpectation *firstExpectation = [self expectationWithDescription:@"expect the first request to receive the location"];
  XCTestExpectation *secondExpectation = [self expectationWithDescription:@"expect the second request to receive the location"];
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable result) {
    XCTAssertEqual(result, location);
    [firstExpectation fulfill];
  }
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
    XCTFail(@"no error was reported");
  }];
  // A second request while the first one is still pending.
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable result) {
    XCTAssertEqual(result, location);
    [secondExpectation fulfill];
  }
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
    XCTFail(@"no error was reported");
  }];

  [_geolocationHandler locationManager:_mockOneTimeLocationManager didUpdateLocations: @[location]];

  [self waitForExpectations:@[firstExpectation, secondExpectation] timeout:5.0];

  OCMVerify(times(1), [self->_mockOneTimeLocationManager stopUpdatingLocation]);
}

- (void)testConcurrentRequestsShouldAllReceiveTheError {
  NSError *error = [NSError errorWithDomain:kCLErrorDomain code:kCLErrorDenied userInfo:nil];

  XCTestExpectation *firstExpectation = [self expectationWithDescription:@"expect the first request to fail"];
  XCTestExpectation *secondExpectation = [self expectationWithDescription:@"expect the second request to fail"];
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable location) {
    XCTFail(@"no position was reported");
  }
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
    XCTAssertEqualObjects(errorCode, GeolocatorErrorLocationUpdateFailure);
    [firstExpectation fulfill];
  }];
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable location) {
    XCTFail(@"no position was reported");
  }
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
    XCTAssertEqualObjects(errorCode, GeolocatorErrorLocationUpdateFailure);
    [secondExpectation fulfill];
  }];

  [_geolocationHandler locationManager:_mockOneTimeLocationManager didFailWithError: error];

  [self waitForExpectations:@[firstExpectation, secondExpectation] timeout:5.0];

  OCMVerify(times(1), [self->_mockOneTimeLocationManager stopUpdatingLocation]);
}

- (void)testConcurrentRequestsShouldAllFailWhenLocationStaysUnknownPastGracePeriod {
  NSError *error = [NSError errorWithDomain:kCLErrorDomain code:kCLErrorLocationUnknown userInfo:nil];
  [_geolocationHandler setLocationUnknownGracePeriodOverride:0.1];

  XCTestExpectation *firstExpectation = [self expectationWithDescription:@"expect the first request to fail"];
  XCTestExpectation *secondExpectation = [self expectationWithDescription:@"expect the second request to fail"];
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable location) {
    XCTFail(@"no position was reported");
  }
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
    [firstExpectation fulfill];
  }];
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable location) {
    XCTFail(@"no position was reported");
  }
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
    [secondExpectation fulfill];
  }];

  [_geolocationHandler locationManager:_mockOneTimeLocationManager didFailWithError: error];

  [self waitForExpectations:@[firstExpectation, secondExpectation] timeout:5.0];
}

- (void)testRequestAfterACompletedRequestShouldOnlyAnswerTheNewRequest {
  CLLocation *firstLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(54.0, 6.4)
                                                            altitude:0.0
                                                  horizontalAccuracy:0
                                                    verticalAccuracy:0
                                                           timestamp:[NSDate date]];
  CLLocation *secondLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(54.1, 6.4)
                                                             altitude:0.0
                                                   horizontalAccuracy:0
                                                     verticalAccuracy:0
                                                            timestamp:[NSDate date]];

  __block NSUInteger firstCalls = 0;
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable location) {
    firstCalls += 1;
  }
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {}];
  [_geolocationHandler locationManager:_mockOneTimeLocationManager didUpdateLocations: @[firstLocation]];

  XCTestExpectation *expectation = [self expectationWithDescription:@"expect the new request to receive the new location"];
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable location) {
    XCTAssertEqual(location, secondLocation);
    [expectation fulfill];
  }
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {}];
  [_geolocationHandler locationManager:_mockOneTimeLocationManager didUpdateLocations: @[secondLocation]];

  [self waitForExpectationsWithTimeout:5.0 handler:nil];
  XCTAssertEqual(firstCalls, 1);
}

- (void)testJoiningRequestShouldKeepTheMostAccurateAccuracy {
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyHundredMeters
                                            resultHandler:^(CLLocation * _Nullable location) {}
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {}];
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable location) {}
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {}];
  // A less accurate request does not lower the accuracy the pending requests asked for.
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyKilometer
                                            resultHandler:^(CLLocation * _Nullable location) {}
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {}];

  OCMVerify(times(1), [self->_mockOneTimeLocationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters]);
  OCMVerify(times(2), [self->_mockOneTimeLocationManager setDesiredAccuracy:kCLLocationAccuracyBest]);
  OCMVerify(never(), [self->_mockOneTimeLocationManager setDesiredAccuracy:kCLLocationAccuracyKilometer]);
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

- (void)testKeepLocationManagerSettingsWhenRequestingCurrentPosition1 {
  [_geolocationHandler startListeningWithDesiredAccuracy:kCLLocationAccuracyThreeKilometers
                                          distanceFilter:kCLLocationAccuracyThreeKilometers
                       pauseLocationUpdatesAutomatically:NO
                         showBackgroundLocationIndicator:YES
                                            activityType:CLActivityTypeOther
                          allowBackgroundLocationUpdates:YES
                                           resultHandler:^(CLLocation * _Nullable location) {
  }
                                            errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
    
  }];
  OCMVerify([_mockLocationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers]);
  OCMVerify([_mockLocationManager setDistanceFilter:kCLLocationAccuracyThreeKilometers]);
  
  [_geolocationHandler requestPositionWithDesiredAccuracy:kCLLocationAccuracyBest
                                            resultHandler:^(CLLocation * _Nullable location) {}
                                             errorHandler:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {}];
  OCMVerify([_mockOneTimeLocationManager setDesiredAccuracy:kCLLocationAccuracyBest]);
  OCMVerify([_mockOneTimeLocationManager setDistanceFilter:kCLDistanceFilterNone]);
  
  OCMVerify(never(), [_mockLocationManager setDesiredAccuracy:kCLLocationAccuracyBest]);
  OCMVerify(never(), [_mockLocationManager setDistanceFilter:kCLDistanceFilterNone]);
}

@end
