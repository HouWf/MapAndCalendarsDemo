//
//  ExchangeCoordinate.h
//  MapDemo
//
//  Created by hzhy001 on 2019/3/19.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExchangeCoordinate : NSObject

+ (instancetype)share;

/**
 根据地址获取经纬度

 @param address 地址信息
 @param completion 回调
 */
- (void)getCoordinateByAddress:(NSString *)address
             completionHandler:(void(^)(CLLocation *coorLocation))completion;

/**
 根据经纬度获取地址信息

 @param latitudeStr 经度
 @param longitudeStr 纬度
 @param complation 回调
 */
- (void)getAddressWithLatitude:(NSString *)latitudeStr
                     longitude:(NSString *)longitudeStr
               complateHandler:(void(^)(NSString *address))complation;


@end

NS_ASSUME_NONNULL_END
