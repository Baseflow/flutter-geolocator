@import geolocator_apple.Private;
@import XCTest;

#import <CoreLocation/CoreLocation.h>
#import <TargetConditionals.h>

@interface ActivityTypeMapperTests : XCTestCase
@end

@implementation ActivityTypeMapperTests

- (void)testMaritimeOnSupportedSystems {
#if (TARGET_OS_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 270000) || \
    (TARGET_OS_OSX && __MAC_OS_X_VERSION_MAX_ALLOWED >= 270000)
  if (@available(iOS 27.0, macOS 27.0, *)) {
    XCTAssertEqual([ActivityTypeMapper toCLActivityType:@5], CLActivityTypeMaritime);
    return;
  }
#endif
  XCTSkip(@"Requires an iOS 27 or macOS 27 SDK and runtime.");
}

- (void)testMaritimeFallsBackOnOlderSystems {
#if (TARGET_OS_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 270000) || \
    (TARGET_OS_OSX && __MAC_OS_X_VERSION_MAX_ALLOWED >= 270000)
  if (@available(iOS 27.0, macOS 27.0, *)) {
    XCTSkip(@"The fallback requires an older SDK or runtime.");
  }
#endif
  XCTAssertEqual([ActivityTypeMapper toCLActivityType:@5], CLActivityTypeOtherNavigation);
}

@end
