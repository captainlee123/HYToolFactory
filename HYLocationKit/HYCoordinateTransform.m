//
//  HYCoordinateTransform.m
//  TDTNJ_AGS
//
//  Created by Cheng Lee-iHooyah on 4/29/14.
//  Copyright (c) 2014 ihooyah.com. All rights reserved.
//

#import "HYCoordinateTransform.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

static const double pi = 3.14159265358979324;

// https://on4wp7.codeplex.com/SourceControl/changeset/view/21483#353936
// Krasovsky 1940
//
// a = 6378245.0, 1/f = 298.3
// b = a * (1 - f)
// ee = (a^2 - b^2) / a^2;
static const double a = 6378245.0;
static const double ee = 0.00669342162296594323;


#define LAT_OFFSET_0(x,y) (-100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x)))
#define LAT_OFFSET_1 ((20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0)
#define LAT_OFFSET_2 ((20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0)
#define LAT_OFFSET_3 ((160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0)

#define LON_OFFSET_0(x,y) (300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x)))
#define LON_OFFSET_1 ((20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0)
#define LON_OFFSET_2 ((20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0)
#define LON_OFFSET_3 ((150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0)

#define RANGE_LON_MAX 137.8347
#define RANGE_LON_MIN 72.004
#define RANGE_LAT_MAX 55.8271
#define RANGE_LAT_MIN 0.8293
// jzA = 6378245.0, 1/f = 298.3
// b = a * (1 - f)
// ee = (a^2 - b^2) / a^2;
#define jzA 6378245.0
#define jzEE 0.00669342162296594323

@interface HYCoordinateTransform ()

+ (BOOL)outOfChinaWithWGLat:(double)wgLat WGLon:(double)wgLon;

+ (double)transformLatWithX:(double)x Y:(double)y;

+ (double)transformLonWithX:(double)x Y:(double)y;

@end

@implementation HYCoordinateTransform

//GPS 坐标转为火星坐标
+ (void)transfromWithWGLat:(double)wgLat WGLon:(double)wgLon outMGLat:(double *)mgLat outMGLon:(double *)mgLon {
    if ([self outOfChinaWithWGLat:wgLat WGLon:wgLon]) {
        *mgLat = wgLat;
        *mgLon = wgLon;
        return;
    }
    double dLat =[self transformLatWithX:wgLon - 105.0 Y:wgLat - 35.0] ;
    double dLon =[self transformLonWithX:wgLon - 105.0 Y:wgLat - 35.0] ;
    
    double radLat = wgLat / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    *mgLat = wgLat + dLat;
    *mgLon = wgLon + dLon;
}

// 经纬度是否超出中国范围
+ (BOOL)outOfChinaWithWGLat:(double)wgLat WGLon:(double)wgLon {
    if (wgLon < 72.004 || wgLon > 137.8347)
        return YES;
    if (wgLat < 0.8293 || wgLat > 55.8271)
        return YES;
    return NO;
}


+ (double)transformLatWithX:(double)x Y:(double)y {
    
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return ret;
}

+ (double)transformLonWithX:(double)x Y:(double)y {
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
}


+ (double)transformLat:(double)x bdLon:(double)y
{
    double ret = LAT_OFFSET_0(x, y);
    ret += LAT_OFFSET_1;
    ret += LAT_OFFSET_2;
    ret += LAT_OFFSET_3;
    return ret;
}

+ (double)transformLon:(double)x bdLon:(double)y
{
    double ret = LON_OFFSET_0(x, y);
    ret += LON_OFFSET_1;
    ret += LON_OFFSET_2;
    ret += LON_OFFSET_3;
    return ret;
}

//是否中国运营商
+ (BOOL)chinaCarrier {
    static BOOL cCarrier = YES;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //https://en.wikipedia.org/wiki/Mobile_country_code
        //460 -> China
        //454 -> HK
        //466 -> Taiwan
        //455 -> Macau
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = [info subscriberCellularProvider];
        if (carrier) {
            NSString  *code = [carrier mobileCountryCode];
            if (code && code.length > 0) {
                cCarrier = [code isEqualToString:@"460"];
            }
            else {
                NSString *name = [carrier carrierName];
                if (name && name.length > 0) {
                    NSRange range  = [name rangeOfString:@"中国"];
                    cCarrier = range.location  != NSNotFound;
                }
            }
        }
    });
    
    return cCarrier;
}

// 是不不需要转换坐标
+ (BOOL)noNeedTransForm:(double)lat bdLon:(double)lon {
    BOOL chinaCarrie = [self chinaCarrier];
    if (!chinaCarrie) {
        return YES;
    }
    
    return [self outOfChinaWithWGLat:lat WGLon:lon];
//    if (lon < RANGE_LON_MIN || lon > RANGE_LON_MAX)
//        return true;
//    if (lat < RANGE_LAT_MIN || lat > RANGE_LAT_MAX)
//        return true;
//    return false;
}

+ (CLLocationCoordinate2D)gcj02Encrypt:(double)ggLat bdLon:(double)ggLon
{
    CLLocationCoordinate2D resPoint;
    double mgLat;
    double mgLon;
    if ([self noNeedTransForm:ggLat bdLon:ggLon]) {
        resPoint.latitude = ggLat;
        resPoint.longitude = ggLon;
        return resPoint;
    }
    double dLat = [self transformLat:(ggLon - 105.0) bdLon:(ggLat - 35.0)];
    double dLon = [self transformLon:(ggLon - 105.0) bdLon:(ggLat - 35.0)];
    double radLat = ggLat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - jzEE * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((jzA * (1 - jzEE)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (jzA / sqrtMagic * cos(radLat) * M_PI);
    mgLat = ggLat + dLat;
    mgLon = ggLon + dLon;
    
    resPoint.latitude = mgLat;
    resPoint.longitude = mgLon;
    return resPoint;
}



+ (CLLocationCoordinate2D)gcj02Decrypt:(double)gjLat gjLon:(double)gjLon {
    CLLocationCoordinate2D  gPt = [self gcj02Encrypt:gjLat bdLon:gjLon];
    double dLon = gPt.longitude - gjLon;
    double dLat = gPt.latitude - gjLat;
    CLLocationCoordinate2D pt;
    pt.latitude = gjLat - dLat;
    pt.longitude = gjLon - dLon;
    return pt;
}

+ (CLLocationCoordinate2D)bd09Decrypt:(double)bdLat bdLon:(double)bdLon
{
    CLLocationCoordinate2D gcjPt;
    double x = bdLon - 0.0065, y = bdLat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) - 0.000003 * cos(x * M_PI);
    gcjPt.longitude = z * cos(theta);
    gcjPt.latitude = z * sin(theta);
    return gcjPt;
}

+(CLLocationCoordinate2D)bd09Encrypt:(double)ggLat bdLon:(double)ggLon
{
    CLLocationCoordinate2D bdPt;
    double x = ggLon, y = ggLat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) + 0.000003 * cos(x * M_PI);
    bdPt.longitude = z * cos(theta) + 0.0065;
    bdPt.latitude = z * sin(theta) + 0.006;
    return bdPt;
}


+ (CLLocationCoordinate2D)wgs84ToGcj02:(CLLocationCoordinate2D)location
{
    return [self gcj02Encrypt:location.latitude bdLon:location.longitude];
}

+ (CLLocationCoordinate2D)gcj02ToWgs84_2:(CLLocationCoordinate2D)location {
    
    CLLocationCoordinate2D wgLoc = location;
         CLLocationCoordinate2D currGcLoc, dLoc;
         while (1) {
                 currGcLoc = [self wgs84ToGcj02:wgLoc];
                  dLoc.latitude = location.latitude - currGcLoc.latitude;
                  dLoc.longitude = location.longitude - currGcLoc.longitude;
                  if (fabs(dLoc.latitude) < 1e-7 && fabs(dLoc.longitude) < 1e-7) {  // 1e-7 ~ centimeter level accuracy
                      // Result of experiment:
                      //   Most of the time 2 iterations would be enough for an 1e-8 accuracy (milimeter level).
                      //
                        return wgLoc;
                      }
                  wgLoc.latitude += dLoc.latitude;
                  wgLoc.longitude += dLoc.longitude;
             }
         
         return wgLoc;
    
}
+ (CLLocationCoordinate2D)gcj02ToWgs84:(CLLocationCoordinate2D)location
{
    return [self gcj02Decrypt:location.latitude gjLon:location.longitude];
}


+ (CLLocationCoordinate2D)wgs84ToBd09:(CLLocationCoordinate2D)location
{
    CLLocationCoordinate2D gcj02Pt = [self gcj02Encrypt:location.latitude
                                                  bdLon:location.longitude];
    return [self bd09Encrypt:gcj02Pt.latitude bdLon:gcj02Pt.longitude] ;
}


+ (CLLocationCoordinate2D)wgs4490ToBd09:(CLLocationCoordinate2D)location {
    //dx = -0.000447
    //dy = -0.0002676
    CLLocationCoordinate2D wgs84 = CLLocationCoordinate2DMake(location.latitude + 0.0002676, location.longitude + 0.000447);
    CLLocationCoordinate2D gcj02Pt = [self gcj02Encrypt:wgs84.latitude
                                                  bdLon:wgs84.longitude];
    return [self bd09Encrypt:gcj02Pt.latitude bdLon:gcj02Pt.longitude] ;
}
+ (CLLocationCoordinate2D)gcj02ToBd09:(CLLocationCoordinate2D)location
{
    return  [self bd09Encrypt:location.latitude bdLon:location.longitude];
}

+ (CLLocationCoordinate2D)bd09ToGcj02:(CLLocationCoordinate2D)location
{
    return [self bd09Decrypt:location.latitude bdLon:location.longitude];
}

+ (CLLocationCoordinate2D)bd09ToWgs84:(CLLocationCoordinate2D)location
{
    CLLocationCoordinate2D gcj02 = [self bd09ToGcj02:location];
    return [self gcj02ToWgs84_2:gcj02];
    //return [self gcj02Decrypt:gcj02.latitude gjLon:gcj02.longitude];
}


+ (CLLocationCoordinate2D)bd09To4490:(CLLocationCoordinate2D)location {
    /*
     1、假定有需要转换的百度坐标（B0，L0）(B为纬度、L为经度)；
     2、调用百度的坐标转换接口服务http://api.map.baidu.com/ag/coord/convert，此接口的坐标转换是单向的，只允许外部坐标转为百度坐标，经过坐标转换后，得到坐标（B1，L1）；
     3、公式计算，B3 = 2 * B0 – B1，L3 = 2 * L0 –L1，得到近似GPS坐标（B3，L3）；
     4、GPS转天地图，因天地图可能经过加密，暂假设当前城市的天地图与标准WGS84存在某一坐标值偏移（dB,dL），那最终百度坐标转为天地图坐标是（B3+dB, L3+dL）。
     dx = -0.000447
     dy = -0.0002676
     */
    CLLocationCoordinate2D gcj02 = [self bd09ToGcj02:location];
    CLLocationCoordinate2D wgs84 =  [self gcj02ToWgs84:gcj02];
    
    return CLLocationCoordinate2DMake(wgs84.latitude - 0.0002676, wgs84.longitude - 0.000447);
}

+ (CLLocationCoordinate2D)wgs84ToWgs4490:(CLLocationCoordinate2D)wgs84 {
     return CLLocationCoordinate2DMake(wgs84.latitude - 0.0002676, wgs84.longitude - 0.000447);
}

@end
