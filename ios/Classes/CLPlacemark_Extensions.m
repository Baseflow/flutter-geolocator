//
// Created by Razvan Lung(long1eu) on 2019-02-20.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "CLPlacemark_Extensions.h"


@implementation CLPlacemark (CLPlacemark_Extensions)
- (NSDictionary *)toDictionary {
    NSMutableDictionary<NSString *, NSObject *> *dict = [[NSMutableDictionary alloc] initWithDictionary:@{
            @"name": self.name == nil ? @"" : self.name,
            @"isoCountryCode": self.ISOcountryCode == nil ? @"" : self.ISOcountryCode,
            @"country": self.country == nil ? @"" : self.country,
            @"thoroughfare": self.thoroughfare == nil ? @"" : self.thoroughfare,
            @"subThoroughfare": self.subThoroughfare == nil ? @"" : self.subThoroughfare,
            @"postalCode": self.postalCode == nil ? @"" : self.postalCode,
            @"administrativeArea": self.administrativeArea == nil ? @"" : self.administrativeArea,
            @"subAdministrativeArea": self.subAdministrativeArea == nil ? @"" : self.subAdministrativeArea,
            @"locality": self.locality == nil ? @"" : self.locality,
            @"subLocality": self.subLocality == nil ? @"" : self.subLocality,
    }];


    if ([self location] != nil) {
        dict[@"location"] = [[self location] toDictionary];
    }

    return dict;
}

@end
