//
//  Macros.h
//  MapDemo
//
//  Created by hzhy001 on 2019/3/20.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#define singleton_shareManager \
+ (instancetype)shareManager;

#define singleton_implementation(className) \
static className *_instance; \
+ (instancetype)shareManager{ \
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [[self alloc] init];\
    });\
    return _instance;\
}\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [super allocWithZone:zone];\
    });\
    return _instance;\
}

#define AuthorizationStatusRestricted   @"无法授权"

#define AuthorizationStatusDenied       @"用户拒绝访问日历"

#define Calendars_Visit_Error           @"访问日历错误"

#define Calendars_Remove_Error          @"移除日程失败"

#define Calendars_NotFound_Error        @"未找到日程提醒"

#endif /* Macros_h */
