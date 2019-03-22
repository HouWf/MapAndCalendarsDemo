//
//  CalendarsViewController.m
//  MapDemo
//
//  Created by hzhy001 on 2019/3/21.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "CalendarsViewController.h"
#import "CalendarsManager.h"

#define Calendars_identifier @"Calendars_identifier"

@interface CalendarsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) NSUserDefaults *userDefault;

@end

@implementation CalendarsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"日历管理";
}

- (IBAction)saveClick:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    NSDate *start = [[CalendarsManager shareManager] dateFromString:@"2019-03-22 12:00:00" format:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *end = [[CalendarsManager shareManager] dateFromString:@"2019-03-22 13:00:00" format:@"yyyy-MM-dd HH:mm:ss"];
    
    [[CalendarsManager shareManager] saveCalendarsWithTitle:@"测试日历"
                                                   location:@"汇智大厦"
                                                  startDate:start
                                                    endDate:end
                                                        url:@"https://www.baidu.com"
                                               alarmOffsets:@[@(3600), @(7200)]
                                             complateHandle:^(NSError * _Nonnull error, NSString * _Nonnull identifier) {
                                                 __strong typeof(weakSelf) self = weakSelf;
                                                 if (!error) {
                                                     NSLog(@"identifier: %@",identifier);
                                                     self.textView.text = identifier;
                                                     [self saveIdentifier:identifier];
                                                 }
                                                 else{
                                                     NSLog(@"添加日程失败 ：%@",error.domain);
                                                 }
                                             }];
}

- (IBAction)deleteClick:(UIButton *)sender {
    NSString *identifier = [self readIdentifier];
    [[CalendarsManager shareManager] removeCalendarsWithIdentifier:identifier complateHandle:^(NSError * _Nonnull error, NSString * _Nonnull identifier) {
        if (error) {
            self.textView.text = error.domain;
        }
        else{
            self.textView.text = @"移除成功";
            [self.userDefault removeObjectForKey:Calendars_identifier];
        }
    }];
}

- (IBAction)resetClick:(UIButton *)sender {
    NSString *identifier = [self readIdentifier];
    [[CalendarsManager shareManager] resetAlarmWithIdentifier:identifier
                                                        title:@"更改名字"
                                                     location:@""
                                                    startDate:nil
                                                      endDate:nil
                                                          url:@""
                                                 alarmOffsets:@[]
                                               complateHandle:^(NSError * _Nonnull error, NSString * _Nonnull identifier) {
        if (!error) {
            [self saveIdentifier:identifier];
            self.textView.text = @"更新成功";
        }
        else{
            self.textView.text =[NSString stringWithFormat:@"更新失败:%@",error.domain];
        }
    }];
}

- (IBAction)checkClick:(UIButton *)sender {
    NSString *identifier = [self readIdentifier];
    EKEvent *event = [[CalendarsManager shareManager] getDateEventWithIdentifier:identifier];
    if (event) {
        self.textView.text = [NSString stringWithFormat:@"日程：%@ \n地址：%@",event.title, event.location];
    }
    else{
        self.textView.text = @"未找到指定日程";
    }
}

- (void)saveIdentifier:(NSString *)identifier{
    [self.userDefault setObject:identifier forKey:Calendars_identifier];
    [self.userDefault synchronize];
}

- (NSString *)readIdentifier{
    return [self.userDefault objectForKey:Calendars_identifier];
}

- (NSUserDefaults *)userDefault{
    if (!_userDefault) {
        
        _userDefault = [NSUserDefaults standardUserDefaults];
    }
    return _userDefault;
}

@end
