//
//  LocationManager.m
//  CitySelect
//
//  Created by 李诚 on 15/4/14.
//  Copyright (c) 2015年 李诚. All rights reserved.
//

#import "HYLocationManager.h"

@implementation HYLocationObj

@end

@interface HYLocationManager () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) hy_locationBlock  completionBlock;

@end

static HYLocationManager *_locationManager = nil;

@implementation HYLocationManager

/**
 *  TODO:创建单例
 */
+ (instancetype)shareInstance {
    @synchronized(self) {
        if (!_locationManager) {
            _locationManager = [[self alloc] init];
        }
    }
    return _locationManager;
}

/**
 *  @author 李诚, 15-04-17 11:04:28
 */
+ (void)freeInstance {
    _locationManager = nil;
}


- (instancetype)init{
    self = [super init];
    if (self) {
        // Initialization code
        //初始化位置管理器
        self.locationManager = [[CLLocationManager alloc] init];
        //设置代理
        self.locationManager.delegate = self;
        //设置位置经度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        //设置每隔100米更新位置
        self.locationManager.distanceFilter = 1000;
    }
    return self;
}

- (void)dealloc{
    self.locationManager.delegate = nil;
}

/**
 *  TODO:开启定位
 *
 *  @param complectionHandler
 */
- (void)startLocationCompletion:(hy_locationBlock)completion {
    self.completionBlock = completion;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

/*是否允许定位*/
- (BOOL)allowLoaction {
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
            NSLog(@"定位功能可用");
            return YES;
        }
    else {
        NSLog(@"定位功能不可用，提示用户或忽略");
        return NO;
    }
}

#pragma mark ===== CLLocationManagerDelegate ============
//协议中的方法，作用是每当位置发生更新时会调用的委托方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *newLocation = [locations lastObject];
    
    HYLocationObj *locObj = [[HYLocationObj alloc] init];
    //经纬度
    locObj.longtitude = newLocation.coordinate.longitude;
    locObj.latitude = newLocation.coordinate.latitude;
    //信号精度
    HYLocationStrength strength = HYLocationStrengthFull;
    if (newLocation.horizontalAccuracy <= 0){
        strength = HYLocationStrengthNone;
    }
    else if (newLocation.horizontalAccuracy > 163){
        strength = HYLocationStrengthWeak;
    }
    else if (newLocation.horizontalAccuracy > 48){
        strength = HYLocationStrengthNormal;
    }
    locObj.strenth = strength;
    
    __weak HYLocationManager *weakSlef = self;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: newLocation completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            locObj.placemark = placemark;
            
            self.lastLocationObj = locObj;
            
            if (weakSlef.completionBlock){
                weakSlef.completionBlock(locObj);
                weakSlef.completionBlock = nil;
                [weakSlef.locationManager stopUpdatingLocation];
            }
        }else{
            //NSLog(@"解析地址出错:%d,-%@-",__LINE__,error);
            locObj.error = error;
            if (self.completionBlock){
                self.completionBlock(locObj);
                self.completionBlock = nil;
                [self.locationManager stopUpdatingLocation];
            }
        }
    }];
}

/// 获取定位信息失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (self.completionBlock){
        HYLocationObj *locObj = [[HYLocationObj alloc] init];
        locObj.error = error;
        
        self.completionBlock(locObj);
        self.completionBlock = nil;
        [self.locationManager stopUpdatingLocation];
    }
}

@end
