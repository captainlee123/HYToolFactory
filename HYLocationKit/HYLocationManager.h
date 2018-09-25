//
//  LocationManager.h
//  CitySelect
//
//  Created by 李诚 on 15/4/14.
//  Copyright (c) 2015年 李诚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/*
 Attention:
    在info.plist文件中添加
    NSLocationWhenInUseUsageDescription
 */

/// GPS信号强弱
typedef NS_ENUM(NSInteger, HYLocationStrength) {
    HYLocationStrengthNone = 0,
    HYLocationStrengthWeak = 1,
    HYLocationStrengthNormal = 2,
    HYLocationStrengthFull = 3
};

@interface HYLocationObj : NSObject

//信号强度
@property (nonatomic, assign) HYLocationStrength    strenth;

//地名位置标识
///administrativeArea-省级名称  locality-市级名称
@property (nonatomic, strong) CLPlacemark   *placemark;

@property (nonatomic, assign) double        latitude;

@property (nonatomic, assign) double        longtitude;

@property (nonatomic, strong) NSError       *error;

@end

typedef void(^hy_locationBlock)(HYLocationObj *locationObj);

@interface HYLocationManager : NSObject

//上一次成功定位的数据
@property (nonatomic, strong) HYLocationObj *lastLocationObj;

/**
 *  TODO:创建单例
 */
+ (instancetype)shareInstance;

/**
 *  TODO:释放单例
 */
+ (void)freeInstance;

/**
 *  TODO:开启定位
 *  定位成功后会关闭定位
 */
- (void)startLocationCompletion:(hy_locationBlock)completion;

@end
