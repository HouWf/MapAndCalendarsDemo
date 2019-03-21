//
//  ExchangeCoordinate.m
//  MapDemo
//
//  Created by hzhy001 on 2019/3/19.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "ExchangeCoordinate.h"


@interface ExchangeCoordinate ()

@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation ExchangeCoordinate

static ExchangeCoordinate *exchan;

+ (instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        exchan = [[self alloc] init];
    });
    return exchan;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        exchan = [super allocWithZone:zone];
    });
    return exchan;
}

- (void)getCoordinateByAddress:(NSString *)address completionHandler:(void(^)(CLLocation *coorLocation))completion{
    
    self.geocoder = [[CLGeocoder alloc] init];
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error && placemarks.count != 0) {
            CLPlacemark *placemark = placemarks[0];
            CLLocation *adLocation = placemark.location;
            NSDictionary *addressDic = placemark.addressDictionary;
            NSLog(@"addressDic: %@",addressDic);
            completion(adLocation);
        }
        else{
            NSLog(@"error :%@ \n placemarks.count %ld",error, placemarks.count);
            completion(nil);
        }
    }];
//    [self.geocoder cancelGeocode];
}

- (void)getAddressWithLatitude:(NSString *)latitudeStr longitude:(NSString *)longitudeStr complateHandler:(void(^)(NSString *address))complation{
    self.geocoder = [[CLGeocoder alloc] init];
    CLLocationDegrees lat = [latitudeStr doubleValue];
    CLLocationDegrees lon = [longitudeStr doubleValue];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error && placemarks.count != 0) {
            
            CLPlacemark *placemark = placemarks[0];
            NSString *address = placemark.name;
            complation(address);
        }
        else{
            complation(@"未找到地址信息");
        }
    }];
}

@end
