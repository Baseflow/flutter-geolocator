//
//  GeocodeTask.m
//  geolocator
//
//  Created by Maurits van Beusekom on 20/05/2019.
//

#import "GeocodeTask.h"


@implementation GeocodeTask

- (instancetype)initWithContext:(TaskContext *)context completionHandler:(CompletionHandler)completionHandler {
    self = [super initWithContext:context completionHandler:completionHandler];
    if (self) {
        //
    }
    
    return self;
}

- (void)geocodeCompletionHandlerPlacemarks:(NSArray<CLPlacemark *> *)placemarks errorCode:(NSString *)errorCode error:(NSError *)error {
    if (placemarks != nil) {
        [self processPlacemarks:placemarks];
    }
    
    if (error != nil) {
        [self handleErrorCode:errorCode message:error.localizedDescription];
    }
    
    [self stopTask];
}

- (void)processPlacemarks:(NSArray<CLPlacemark *> *)placemarks {
    NSMutableArray<NSDictionary *> *locations = [[NSMutableArray alloc] init];
    
    for (CLPlacemark *placemark in  placemarks) {
        [locations addObject:[placemark toDictionary]];
    }
    
    if (locations.count > 0) {
        [[self context] resultHandler](locations);
    } else {
        [self handleErrorCode:@"ERROR_GEOCODING_ADDRESSNOTFOUND" message:@"Could not find any result for the supplied address or coordinates."];
    }
}

- (NSString *)languageCode:(NSLocale *)locale {
    if (@available(iOS 10.0, *)) {
        return [locale languageCode];
    } else {
        return [[locale localeIdentifier] substringToIndex:2];
    }
}

@end


@implementation ForwardGeocodeTask {
    NSString *_address;
    NSLocale *_locale;
}

- (instancetype)initWithContext:(TaskContext *)context completionHandler:(CompletionHandler)completionHandler {
    self = [super initWithContext:context completionHandler:completionHandler];
    if (self) {
        //
    }
    
    [self parseArguments:context.arguments];
    return self;
}

- (void)parseArguments:(id)arguments {
    if ([arguments isKindOfClass:[NSDictionary class]]) {
        _address = arguments[@"address"];
        
        if (arguments[@"localeIdentifier"] != nil) {
            _locale = [[NSLocale alloc] initWithLocaleIdentifier:arguments[@"localeIdentifier"]];
        }
    } else {
        _address = nil;
    }
}

- (void)startTask {
    if (_address == nil) {
        [self handleErrorCode:@"NO_ADDRESS_SUPPLIED" message:@"Please supply a valid string containing the address to lookup"];
        
        [self stopTask];
        return;
    }
    
    [self geocodeAddress:_address];
}

- (void)geocodeAddress:(NSString *)address {
    CLGeocoder *geocoding = [[CLGeocoder alloc] init];
    
    if (@available(iOS 11.0, *)) {
        [geocoding geocodeAddressString:address inRegion:nil preferredLocale:_locale completionHandler:^(NSArray< CLPlacemark *> *__nullable placemarks, NSError *__nullable error) {
            [self geocodeCompletionHandlerPlacemarks:placemarks errorCode:@"ERROR_GEOCODING_ADDRESS" error:error];
        }];
    } else {
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        NSArray<NSString * > *defaultLanguages;
        
        if (_locale != nil) {
            defaultLanguages = [standardUserDefaults arrayForKey:@"AppleLanguages"];
            [standardUserDefaults setValue:[self languageCode:_locale] forKey:@"AppleLanguages"];
        }
        
        [geocoding geocodeAddressString:address completionHandler:^(NSArray< CLPlacemark *> *__nullable placemarks, NSError *__nullable error) {
            [self geocodeCompletionHandlerPlacemarks:placemarks errorCode:@"ERROR_GEOCODING_ADDRESS" error:error];
            
            if (self->_locale != nil) {
                [standardUserDefaults setValue:defaultLanguages forKey:@"AppleLanguages"];
            }
        }];
    }
}

@end


@implementation ReverseGeocodeTask {
    CLLocation *_location;
    NSLocale *_locale;
}

- (instancetype)initWithContext:(TaskContext *)context completionHandler:(CompletionHandler)completionHandler {
    self = [super initWithContext:context completionHandler:completionHandler];
    if (self) {
        //
    }
    
    [self parseArguments:context.arguments];
    return self;
}

- (void)parseArguments:(id)arguments {
    if ([arguments isKindOfClass:[NSDictionary class]]) {
        CLLocationDegrees latitude = ((NSNumber *) arguments[@"latitude"]).doubleValue;
        CLLocationDegrees longitude = ((NSNumber *) arguments[@"longitude"]).doubleValue;
        
        _location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        if (arguments[@"localeIdentifier"] != nil) {
            _locale = [[NSLocale alloc] initWithLocaleIdentifier:(NSString *) arguments[@"localeIdentifier"]];
        }
    } else {
        _location = nil;
    }
}

- (void)startTask {
    if (_location == nil) {
        [self handleErrorCode:@"NO_COORDINATES_SUPPLIED" message:@"Please supply valid latitude and longitude values."];
        [self stopTask];
        return;
    }
    
    
    [self reverseToAddress:_location];
}

- (void)reverseToAddress:(CLLocation *)location {
    CLGeocoder *geocoding = [[CLGeocoder alloc] init];
    
    if (@available(iOS 11.0, *)) {
        [geocoding reverseGeocodeLocation:location preferredLocale:_locale completionHandler:^(NSArray< CLPlacemark *> *__nullable placemarks, NSError *__nullable error) {
            [self geocodeCompletionHandlerPlacemarks:placemarks errorCode:@"ERROR_REVERSEGEOCODING_LOCATION" error:error];
        }];
    } else {
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        NSArray<NSString * > *defaultLanguages;
        
        if (_locale != nil) {
            defaultLanguages = [standardUserDefaults arrayForKey:@"AppleLanguages"];
            [standardUserDefaults setValue:[self languageCode:_locale] forKey:@"AppleLanguages"];
        }
        
        [geocoding reverseGeocodeLocation:location completionHandler:^(NSArray< CLPlacemark *> *__nullable placemarks, NSError *__nullable error) {
            [self geocodeCompletionHandlerPlacemarks:placemarks errorCode:@"ERROR_REVERSEGEOCODING_LOCATION" error:error];
            
            if (self->_locale != nil) {
                [standardUserDefaults setValue:defaultLanguages forKey:@"AppleLanguages"];
            }
        }];
    }
}

@end
