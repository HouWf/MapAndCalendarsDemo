//
//  AuthorizationManager.h
//  MapDemo
//
//  Created by hzhy001 on 2019/3/21.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuthorizationManager : NSObject

#pragma mark - 网络连接
- (void)getkNetworkingPermission;
- (void)requestNetworkingFunction;

#pragma mark - 相册
- (void)getAlbumAuthority;
- (void)requestAlbumAuthority;

#pragma mark - 相机 、 麦克风
- (void)getMediaAuthority;
- (void)requestMediaAuthority;

#pragma mark - 定位
- (void)getLocationAuthority;
- (void)requestLoactionAuthority;

#pragma mark - 推送
- (void)getNotificationAuthority;

#pragma mark - 日历、备忘录
- (void)getEKAuthorizationAuthority;
- (void)requestEKAuthorizationAuthority;

#pragma mark - 通讯录
- (void)getAddressBookAuthority;
- (NSString *)requestAddressBookAuthority;

#pragma mark - 跳转设置页
- (void)openSettingView;

@end

NS_ASSUME_NONNULL_END
