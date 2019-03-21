//
//  CalendarsManager.m
//  MapDemo
//
//  Created by hzhy001 on 2019/3/20.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "CalendarsManager.h"
#import <EventKitUI/EventKitUI.h>

@interface CalendarsManager ()

@property (nonatomic, strong) EKEventStore  *eventStor;

@end

@implementation CalendarsManager

static CalendarsManager *_calendars;

singleton_implementation(CalendarsManager);

/**
 读取授权状态

 @return 是否可用
 */
- (NSError *)checkAuthorizationStatus {
    EKAuthorizationStatus autStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    NSError *error;

    if (autStatus == EKAuthorizationStatusRestricted) {
        error = [NSError errorWithDomain:AuthorizationStatusRestricted code:400 userInfo:nil];
    }
    else if (autStatus == EKAuthorizationStatusDenied){
        error = [NSError errorWithDomain:AuthorizationStatusDenied code:400 userInfo:nil];
    }
    return error;
}

- (void)saveCalendarsWithTitle:(NSString *)eventTitle
                      location:(NSString *)location
                     startDate:(NSDate *)startDate
                       endDate:(NSDate *)endDate
                  alarmOffsets:(NSArray <NSNumber *>*)alarmOffsets
                complateHandle:(calendarsBlock)complate{
//    NSError *checkResult = [self checkAuthorizationStatus];
//    if (checkResult) {
//        complate(checkResult, @"");
//        return;
//    }
    
    if ([self.eventStor respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        __weak typeof(self) weakSelf = self;
        [self.eventStor requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
            __strong typeof(weakSelf) self = weakSelf;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *refreshError;
                if (error) {
                    refreshError = [NSError errorWithDomain:Calendars_Visit_Error code:400 userInfo:nil];
                    complate(refreshError, @"");
                }
                else if (!granted){
                    refreshError = [NSError errorWithDomain:AuthorizationStatusDenied code:100 userInfo:nil];
                    complate(refreshError, @"");
                }
                else{
                    
                    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
                    [tempFormatter setDateFormat:DEFAULT_FORMAT];
                    
                    EKEvent *event = [EKEvent eventWithEventStore:self.eventStor];
                    event.title = eventTitle;
                    event.location = location;
                    event.allDay = NO;
                    event.startDate = startDate;
                    event.endDate = endDate;
                    
                    if (alarmOffsets.count != 0) {
                        for (NSNumber *timeNumb in alarmOffsets) {
                            NSInteger offset = [timeNumb integerValue];
                            [event addAlarm:[EKAlarm alarmWithRelativeOffset:-offset]];
                        }
                    }
                    else{
                        [event addAlarm:[EKAlarm alarmWithRelativeOffset:-3600]];
                    }
                    
                    [event setCalendar:[self.eventStor defaultCalendarForNewEvents]];
                    
                    NSError *resultError;
                    [self.eventStor saveEvent:event span:EKSpanThisEvent error:&resultError];
                    if (error) {
                        complate(error, @"");
                    }
                    else{
                        complate(resultError, event.eventIdentifier);
                    }
                    
                    //                    EKEventEditViewController *eventVc = [[EKEventEditViewController alloc] init];
                    //                    eventVc.eventStore = self.eventStor;
                    //                    eventVc.editViewDelegate = self;
                    //                    eventVc.event = event;
                    //                    [vc presentViewController:eventVc animated:YES completion:nil];
                }
            });
        }];
    }
}

- (void)removeCalendarsWithIdentifier:(NSString *)identifier
                       complateHandle:(calendarsBlock)complate{
    
    EKEvent *currentEvent = [self.eventStor eventWithIdentifier:identifier];
    NSError *erro;
    if (currentEvent) {
        [self.eventStor removeEvent:currentEvent span:EKSpanThisEvent error:&erro];
        if (erro) {
            erro = [NSError errorWithDomain:Calendars_Remove_Error code:404 userInfo:nil];
            complate(erro, @"");
        }
        else{
            complate(erro, identifier);
        }
    }
    else{
        erro = [NSError errorWithDomain:Calendars_NotFound_Error code:404 userInfo:nil];
        complate(erro, @"");
    }
}

- (void)removeCalendarsWithStartDate:(NSDate *)startDate
                             endDate:(NSDate *)endDate{
    NSPredicate *predicate = [self.eventStor predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
    NSArray *currentEvents = [self.eventStor eventsMatchingPredicate:predicate];
    for (EKEvent *eventin in currentEvents) {
        [self removeCalendarsWithIdentifier:eventin.eventIdentifier complateHandle:^(NSError * _Nonnull error, NSString * _Nonnull identifier) {
            if (!error) {
                NSLog(@"identifier: %@ 移除成功", eventin.eventIdentifier);
            }
            else{
                NSLog(@"identifier: %@ 移除失败", eventin.eventIdentifier);
            }
        }];
    }
}

- (EKEvent *)getDateEventWithIdentifier:(NSString *)identifier{
    EKEvent *event = [self.eventStor eventWithIdentifier:identifier];
    return event;
}

- (NSArray <EKEvent *> *)getDateEventWithStartDate:(NSDate *)startDate
                          endDate:(NSDate *)endDate{
    NSPredicate *predicate = [self.eventStor predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
    NSArray *currentEvents = [self.eventStor eventsMatchingPredicate:predicate];
    return currentEvents;
    
//    [self.eventStor enumerateEventsMatchingPredicate:predicate usingBlock:^(EKEvent * _Nonnull event, BOOL * _Nonnull stop) {
//        NSLog(@"event:%@",event.title);
//    }];
}

- (void)resetAlarmWithIdentifier:(NSString *)identifier
                           title:(NSString *)title
                        location:(NSString *)location
                       startDate:(NSDate *)startDate
                         endDate:(NSDate *)endDate
                    alarmOffsets:(NSArray <NSNumber *>*)alarmOffsets
                  complateHandle:(calendarsBlock)complate{
    
    EKEvent *event = [self getDateEventWithIdentifier:identifier];
    if (event) {
        event.title     = title.length     ? title : event.title;
        event.location  = location.length  ? location : event.location;
        event.startDate = startDate != nil ? startDate : event.startDate;
        event.endDate   = endDate != nil   ? endDate : event.endDate;
        
        NSArray *alarms = alarmOffsets;
        if (alarms.count == 0 || alarms == nil) {
            alarms = @[@(3600)];
        }
        
        [self removeCalendarsWithIdentifier:identifier complateHandle:^(NSError * _Nonnull error, NSString * _Nonnull identifier) {
            [self saveCalendarsWithTitle:event.title
                                location:event.location
                               startDate:event.startDate
                                 endDate:event.endDate
                            alarmOffsets:alarms
                          complateHandle:^(NSError * _Nonnull error, NSString * _Nonnull identifier) {
                                complate(error, identifier);
                            }];
        }];
    }
    else{
        NSError *error = [NSError errorWithDomain:@"未找到指定提醒" code:400 userInfo:nil];
        complate(error, @"");
    }
}

#pragma mark - private
- (NSDate *)dateFromString:(NSString *)dateString
                    format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    [formatter setDateFormat:format];
    [formatter setLocale:locale];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

#pragma mark - Lazy
- (EKEventStore *)eventStor{
    if (!_eventStor) {
        
        _eventStor = [[EKEventStore alloc] init];
    }
    return _eventStor;
}

@end
