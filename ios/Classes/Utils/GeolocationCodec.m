//
//  GeolocatorCodec.m
//  geolocator
//
//  Created by Maurits van Beusekom on 20/05/2019.
//

#import "GeolocationCodec.h"

@implementation GeolocationCodec

+ (NSDictionary *) decodeLocationOptions:(NSString *)jsonString {
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData: [jsonString dataUsingEncoding:NSUTF8StringEncoding]
                 options:0
                 error:&error];
    
    if(error) {
        return nil;
    }
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        return object;
    } else {
        return nil;
    }
}

@end
