//
//  MapManager.m
//  MapDemo
//
//  Created by hzhy001 on 2019/3/20.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "MapManager.h"
#import <MapKit/MapKit.h>

@interface MapManager ()

@property (nonatomic, strong) UIAlertController *alertVeiw;

@property (nonatomic, strong) NSMutableArray *schems;

@end

@implementation MapManager

singleton_implementation(MapManager);

/**
 跳转Apple地图
 
 @param lat 经度
 @param lon 纬度
 @param adname 地址名称
 */
- (void)mapAppleWithLat:(NSString *)lat
                    lon:(NSString *)lon
            addressName:(NSString *)adname{
    CLLocationCoordinate2D coor2d = [self getCoord2DWithLat:lat lon:lon];
    MKPlacemark *mark = [[MKPlacemark alloc] initWithCoordinate:coor2d addressDictionary:nil];
    
    MKMapItem *fromLocation = [MKMapItem mapItemForCurrentLocation];
    fromLocation.name = @"我的位置";
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:mark];
    toLocation.name = adname;
    [MKMapItem openMapsWithItems:@[fromLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}

/**
 百度地图
 
 @param lat 经度
 @param lon 纬度
 @param adname 名称
 */
- (void)baiduLocationWithLat:(NSString *)lat
                         lon:(NSString *)lon
                 addressName:(NSString *)adname{
    //坐标转换
    CLLocationCoordinate2D afterLocation = [self getCoord2DWithLat:lat lon:lon];
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name:%@&mode=driving&src=MapDemo",afterLocation.latitude, afterLocation.longitude, adname]
                           stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

/**
 高德地图
 
 @param lat 经度
 @param lon 纬度
 @param adname 名称
 */
- (void)gaodeLocationWithLat:(NSString *)lat
                         lon:(NSString *)lon
                 addressName:(NSString *)adname{
    
    CLLocationCoordinate2D afterLocation = [self getCoord2DWithLat:lat lon:lon];
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=MapDemo&sid=BGVIS1&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=0",@"我的位置",afterLocation.latitude, afterLocation.longitude, adname]
                           stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

/**
 腾讯地图
 
 @param lat 经度
 @param lon 纬度
 @param adname 名称
 */
- (void)tencentLocationWithLat:(NSString *)lat
                           lon:(NSString *)lon
                   addressName:(NSString *)adname{
    CLLocationCoordinate2D desCoordinate = [self getCoord2DWithLat:lat lon:lon];
    NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&from=我的位置&to=%@&tocoord=%f,%f&policy=1&referer=MapDemo", adname, desCoordinate.latitude, desCoordinate.longitude]
                           stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

/**
 谷歌地图
 
 @param lat 经度
 @param lon 纬度
 @param adname 名称
 */
- (void)googleLocationWithLat:(NSString *)lat
                          lon:(NSString *)lon
                  addressName:(NSString *)adname{
    
    CLLocationCoordinate2D afterLocation = [self getCoord2DWithLat:lat lon:lon];
    NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"我的位置",adname,afterLocation.latitude, afterLocation.longitude]
                           stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

/**
 获取2D
 
 @param lat 经度
 @param lon 纬度
 */
- (CLLocationCoordinate2D)getCoord2DWithLat:(NSString *)lat
                                        lon:(NSString *)lon{
    CLLocationDegrees newLat = [lat doubleValue];
    CLLocationDegrees newLon = [lon doubleValue];
    CLLocationCoordinate2D coor2d = CLLocationCoordinate2DMake(newLat, newLon);
    return coor2d;
}

@end
