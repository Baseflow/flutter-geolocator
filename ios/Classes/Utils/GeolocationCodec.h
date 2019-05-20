//
//  GeolocatorCodec.h
//  geolocator
//
//  Created by Maurits van Beusekom on 20/05/2019.
//

#import <Foundation/Foundation.h>

@interface GeolocationCodec : NSObject
+ (NSDictionary *) decodeLocationOptions:(NSString *)jsonString;
@end
