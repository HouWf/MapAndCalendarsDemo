//
//  AuthorizationManager.m
//  MapDemo
//
//  Created by hzhy001 on 2019/3/21.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "AuthorizationManager.h"
#import <CoreTelephony/CTCellularData.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>
#import <EventKit/EventKit.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

@interface AuthorizationManager ()<CLLocationManagerDelegate>

@end

@implementation AuthorizationManager

#pragma mark - 网络连接
/**
 请求权限
 */
- (void)getkNetworkingPermission{
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
        switch (state) {
            case kCTCellularDataRestricted:
                NSLog(@"Restricrted");
                break;
            case kCTCellularDataNotRestricted:
                NSLog(@"Not Restricted");
                break;
            case kCTCellularDataRestrictedStateUnknown:
                NSLog(@"Unknown");
                break;
            default:
                break;
        };
    };
}

/**
 检测权限
 */
- (void)requestNetworkingFunction{
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    switch (state) {
        case kCTCellularDataRestricted:
            NSLog(@"Restricrted");
            break;
        case kCTCellularDataNotRestricted:
            NSLog(@"Not Restricted");
            break;
        case kCTCellularDataRestrictedStateUnknown:
            NSLog(@"Unknown");
            break;
        default:
            break;
    }
}

#pragma mark - 相册
/**
 请求权限
 */
- (void)requestAlbumAuthority{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            NSLog(@"Authorized");
        }else{
            NSLog(@"Denied or Restricted");
        }
    }];
}

/**
 iOS 8 之后检测权限
 
 iOS 9 之前检测权限 ALAuthorizationStatus
 
 */
- (void)getAlbumAuthority{
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoAuthorStatus) {
        case PHAuthorizationStatusAuthorized:
            NSLog(@"Authorized");
            break;
        case PHAuthorizationStatusDenied:
            NSLog(@"Denied");
            break;
        case PHAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            break;
        case PHAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            break;
    }
}

#pragma mark - 相机 、 麦克风
/**
 请求权限
 */
- (void)requestMediaAuthority{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
        if (granted) {
            NSLog(@"Authorized");
        }else{
            NSLog(@"Denied or Restricted");
        }
    }];
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {//麦克风权限
        if (granted) {
            NSLog(@"Authorized");
        }else{
            NSLog(@"Denied or Restricted");
        }
    }];
}

/**
 检测权限
 */
- (void)getMediaAuthority{
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//相机权限
//    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];//麦克风权限
    switch (AVstatus) {
        case AVAuthorizationStatusAuthorized:
            NSLog(@"Authorized");
            break;
        case AVAuthorizationStatusDenied:
            NSLog(@"Denied");
            break;
        case AVAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            break;
        case AVAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            break;
    }
}

#pragma mark - 定位
/**
 请求权限
 */
- (void)requestLoactionAuthority{
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    [manager requestAlwaysAuthorization];//一直获取定位信息
    [manager requestWhenInUseAuthorization];//使用的时候获取定位信息
    manager.delegate = self;
}

/**
 检测权限
 */
- (void)getLocationAuthority{
    BOOL isLocation = [CLLocationManager locationServicesEnabled];
    if (!isLocation) {
        NSLog(@"not turn on the location");
    }
    CLAuthorizationStatus CLstatus = [CLLocationManager authorizationStatus];
    switch (CLstatus) {
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"Always Authorized");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"AuthorizedWhenInUse");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"Denied");
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            break;
    }
}

// !!!: CLLocationManagerDelegate 检测定位权限是否改变
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"Always Authorized");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"AuthorizedWhenInUse");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"Denied");
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            break;
    }
}

#pragma mark - 推送

/**
 请求权限 ：分系统
 */
- (void)requestNotificaitonAuthority{
    
//    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
}

/**
 检测权限
 */
- (void)getNotificationAuthority{
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    switch (settings.types) {
        case UIUserNotificationTypeNone:
            NSLog(@"None");
            break;
        case UIUserNotificationTypeAlert:
            NSLog(@"Alert Notification");
            break;
        case UIUserNotificationTypeBadge:
            NSLog(@"Badge Notification");
            break;
        case UIUserNotificationTypeSound:
            NSLog(@"sound Notification'");
            break;
            
        default:
            break;
    }
}

#pragma mark - 日历、备忘录
/**
 获取权限
 */
- (void)requestEKAuthorizationAuthority{
    EKEventStore *store = [[EKEventStore alloc]init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"Authorized");
        }else{
            NSLog(@"Denied or Restricted");
        }
    }];
}

/**
 检测是否有日历、备忘录权限
 */
- (void)getEKAuthorizationAuthority{
    EKAuthorizationStatus EKstatus = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
    switch (EKstatus) {
        case EKAuthorizationStatusAuthorized:
            NSLog(@"Authorized");
            break;
        case EKAuthorizationStatusDenied:
            NSLog(@"Denied'");
            break;
        case EKAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            break;
        case EKAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            break;
    }
}

#pragma mark - 通讯录
/**
 请求权限
 block同步实现（return返回值的方式，一直等待）
 block异步实现（使用block返回）
 */
- (NSString *)requestAddressBookAuthority{
    dispatch_semaphore_t signal = dispatch_semaphore_create(1);
    __block NSString * result;
    
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            result = @"Authorized";
        }else{
            result = @"Denied or Restricted";
        }
        dispatch_semaphore_signal(signal);
    }];
    
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return result;
}

/**
 检测权限
 */
- (void)getAddressBookAuthority{
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (status) {
        case CNAuthorizationStatusAuthorized:
        {
            NSLog(@"Authorized:");
        }
            break;
        case CNAuthorizationStatusDenied:{
            NSLog(@"Denied");
        }
            break;
        case CNAuthorizationStatusRestricted:{
            NSLog(@"Restricted");
        }
            break;
        case CNAuthorizationStatusNotDetermined:{
            NSLog(@"NotDetermined");
        }
            break;
    }
}

#pragma mark - 跳转设置页
- (void)openSettingView{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

@end
