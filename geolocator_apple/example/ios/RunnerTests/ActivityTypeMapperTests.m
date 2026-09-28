@import geolocator_apple.Private;
@import XCTest;

#import <CoreLocation/CoreLocation.h>
#import <TargetConditionals.h>

@interface ActivityTypeMapperTests : XCTestCase
@end

@implementation ActivityTypeMapperTests

- (void)testExistingActivityTypesKeepTheirNativeMappings {
  XCTAssertEqual([ActivityTypeMapper toCLActivityType:@0], CLActivityTypeAutomotiveNavigation);
  XCTAssertEqual([ActivityTypeMapper toCLActivityType:@1], CLActivityTypeFitness);
  XCTAssertEqual([ActivityTypeMapper toCLActivityType:@2], CLActivityTypeOtherNavigation);
  if (@available(iOS 12.0, *)) {
    XCTAssertEqual([ActivityTypeMapper toCLActivityType:@3], CLActivityTypeAirborne);
  } else {
    XCTAssertEqual([ActivityTypeMapper toCLActivityType:@3], CLActivityTypeOther);
  }
  XCTAssertEqual([ActivityTypeMapper toCLActivityType:@4], CLActivityTypeOther);
}

- (void)testMaritimeUsesTheSupportedActivityType {
#if (TARGET_OS_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 270000) || \
    (TARGET_OS_OSX && __MAC_OS_X_VERSION_MAX_ALLOWED >= 270000)
  if (@available(iOS 27.0, macOS 27.0, *)) {
    XCTAssertEqual([ActivityTypeMapper toCLActivityType:@5], CLActivityTypeMaritime);
    return;
  }
#endif
  XCTAssertEqual([ActivityTypeMapper toCLActivityType:@5], CLActivityTypeOtherNavigation);
}

- (void)testMissingAndUnknownActivityTypesStillUseOther {
  XCTAssertEqual([ActivityTypeMapper toCLActivityType:nil], CLActivityTypeOther);
  XCTAssertEqual([ActivityTypeMapper toCLActivityType:@(-1)], CLActivityTypeOther);
  XCTAssertEqual([ActivityTypeMapper toCLActivityType:@99], CLActivityTypeOther);
}

@end
