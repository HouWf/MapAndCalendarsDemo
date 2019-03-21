//
//  LocationViewController.m
//  MapDemo
//
//  Created by hzhy001 on 2019/3/19.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "LocationViewController.h"
#import "ExchangeCoordinate.h"
#import "MapConfigManager.h"


@interface LocationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *latitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeTextField;
@property (weak, nonatomic) IBOutlet UILabel *latAndLonLabel;
@property (weak, nonatomic) IBOutlet UILabel *detaliAddressLabel;

@property (nonatomic, copy) NSString *latStr, *lonStr, *nameStr;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"三方导航管理";
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)addressClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.addressTextField.text.length) {
        __weak typeof(self) weakSelf = self;
        [[ExchangeCoordinate share] getCoordinateByAddress:self.addressTextField.text completionHandler:^(CLLocation * _Nonnull coorLocation) {
            __strong typeof(weakSelf) self = weakSelf;
            CLLocationCoordinate2D cor2d = coorLocation.coordinate;
            double lat = cor2d.latitude;
            double lon = cor2d.longitude;
            
            self.latStr = [NSString stringWithFormat:@"%f",lat];
            self.lonStr = [NSString stringWithFormat:@"%f",lon];
            self.nameStr = self.addressTextField.text;
            
            NSString *latLon = [NSString stringWithFormat:@"经度：%f \n纬度：%f",lat,lon];
            self.latAndLonLabel.text = latLon;
            
            self.latitudeTextField.text = self.latStr;
            self.longitudeTextField.text = self.lonStr;
            
            [self showMapUi];
        }];
    }
    else{
        self.latAndLonLabel.text = @"请输入详细地址";
    }
}

- (IBAction)latAndLonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.latitudeTextField.text.length && self.longitudeTextField.text.length) {
        __weak typeof(self) weakSelf = self;
        [[ExchangeCoordinate share] getAddressWithLatitude:self.latitudeTextField.text longitude:self.longitudeTextField.text complateHandler:^(NSString * _Nonnull address) {
            __strong typeof(weakSelf) self = weakSelf;
            self.detaliAddressLabel.text = address;
            
            self.latStr = self.latitudeTextField.text;
            self.lonStr = self.longitudeTextField.text;
            self.nameStr = address;
            
            [self showMapUi];
        }];
        
    }
    else{
        self.detaliAddressLabel.text = @"请输入经纬度";
    }
}

- (void)showMapUi{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MapConfigManager showMapUiWithViewController:self
                                             latitude:self.latStr
                                            longitude:self.lonStr
                                          addressName:self.nameStr
                                   supportPlateformas:@[]];
    });
}

@end
