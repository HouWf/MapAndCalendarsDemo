//
//  CalendarsManager.h
//  MapDemo
//
//  Created by hzhy001 on 2019/3/20.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "Macros.h"

NS_ASSUME_NONNULL_BEGIN

#define DEFAULT_FORMAT @"yyyy-MM-dd HH:mm:ss"

typedef void(^calendarsBlock)(NSError *error, NSString *identifier);

@interface CalendarsManager : NSObject

singleton_shareManager;
/**
 读取授权状态
 
 @return 是否可用
 */
- (NSError *)checkAuthorizationStatus;

/**
 添加日历提醒
 已读取用户授权

 @param eventTitle      标题
 @param location        位置名称
 @param startDate       开始时间
 @param endDate         结束时间
 @param alarmOffsets    提醒时间数组，默认提前一小时 单位：秒 
 @param complate        回调
 */
- (void)saveCalendarsWithTitle:(NSString *)eventTitle
                      location:(NSString *)location
                     startDate:(NSDate *)startDate
                       endDate:(NSDate *)endDate
                  alarmOffsets:(NSArray <NSNumber *>*)alarmOffsets
                complateHandle:(calendarsBlock)complate;

/**
 根据identifier删除提醒

 @param identifier  event_identifier
 @param complate    回调
 */
- (void)removeCalendarsWithIdentifier:(NSString *)identifier
                       complateHandle:(calendarsBlock)complate;

/**
 根据时间段删除日历提醒


 @param startDate 开始时间
 @param endDate 结束时间
 */
- (void)removeCalendarsWithStartDate:(NSDate *)startDate
                             endDate:(NSDate *)endDate;

/**
 根据Id查找提醒事件

 @param identifier id
 @return EKEvent
 */
- (EKEvent *)getDateEventWithIdentifier:(NSString *)identifier;

/**
 获取Event数组

 @param startDate   开始时间
 @param endDate     结束时间
 @return EKEvent数组
 */
- (NSArray <EKEvent *> *)getDateEventWithStartDate:(NSDate *)startDate
                                           endDate:(NSDate *)endDate;

/**
 更新日历日程

 @param identifier 需要更新的日程ID
 @param title 标题
 @param location 定位
 @param startDate 开始时间
 @param endDate 结束时间
 @param alarmOffsets 提醒间隔
 @param complate 回调
 */
- (void)resetAlarmWithIdentifier:(NSString *)identifier
                           title:(NSString *)title
                        location:(NSString *)location
                       startDate:(NSDate *)startDate
                         endDate:(NSDate *)endDate
                    alarmOffsets:(NSArray <NSNumber *>*)alarmOffsets
                  complateHandle:(calendarsBlock)complate;

/**
 字符串转时间

 @param dateString 时间字符串
 @param format format
 @return date
 */
- (NSDate *)dateFromString:(NSString *)dateString
                    format:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
