//
//  ViewController.m
//  MapDemo
//
//  Created by hzhy001 on 2019/3/19.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "ViewController.h"
#import "LocationViewController.h"
#import "CalendarsViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray <NSString *>*itemTitles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"首页";
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.itemTitles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    indexPath.row == 0 ? [self pushToLocationCtr] : [self pushToCalendars];
}

- (void)pushToLocationCtr{
    LocationViewController *locationCtr = [[LocationViewController alloc] init];
    [self.navigationController pushViewController:locationCtr animated:YES];
}

- (void)pushToCalendars{
    CalendarsViewController *calendarCtr = [[CalendarsViewController alloc] init];
    [self.navigationController pushViewController:calendarCtr animated:YES];
}

#pragma mark - lazy
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSArray *)itemTitles{
    if (!_itemTitles) {
        
        _itemTitles = @[@"管理地图导航", @"管理日历日程"];
    }
    return _itemTitles;
}

@end
