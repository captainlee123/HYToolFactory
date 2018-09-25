//
//  HYCommonTool.m
//  QAService
//
//  Created by captain on 15/9/6.
//  Copyright (c) 2015年 李诚. All rights reserved.
//

#import "HYCommonTool.h"
#include <sys/sysctl.h>
#import <CommonCrypto/CommonDigest.h>


//竖屏下iPhone X上下刘海
#define HY_iPhoneXTopLex                   24.f
#define HY_iPhoneXBotLex                   34.f

@implementation HYCommonTool

/*
 * 函数作用: 获取uuid
 * 函数参数:
 * 函数返回值: uuid
 */
+ (NSString *)uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    
    NSMutableString *uuid = [NSMutableString stringWithString:result];
    return [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

/*
 *  将string转换成MD5格式数据
 *  需引进库<CommonCrypto/CommonDigest.h>
 */
+ (NSString *)stringToMD5Value:(NSString *)string
{
    if (string==nil)
    {
        return nil;
    }
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

/**
 *  @Author 有点坑, 15-07-26 17:07:00
 *
 *  TODO:获取文本的绘制size
 *
 *  @param text
 *  @param size
 *  @param font
 */
+ (CGRect)getRectFromString:(NSString *)string withRestrictSize:(CGSize)size font:(UIFont *)font {
    if (!string || string.length == 0) {
        return CGRectZero;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    
    return [attributedString boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil];
}


//对url进行unicode编码
+ (NSString *)convertUrlString:(NSString *)url {
//    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
//    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
//    return [url stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


/**
 *  @author 有点坑, 15-05-15 17:05:27
 *
 *  TODO:获取输入框去高亮部分的 长度
 */
+ (NSInteger)getTextCountWithoutMarked:(id)object {
    return [HYCommonTool getTextCountWithoutMarked:object isAscii:NO];
}

/*
 *  获取输入框去高亮部分的 ascii码长度
 *  一个中文算2个字符
 */
+ (NSInteger)getTextAsciiCountWithoutMarked:(id)object {
    return [HYCommonTool getTextCountWithoutMarked:object isAscii:YES];
}


+ (NSInteger)getTextCountWithoutMarked:(id)object isAscii:(BOOL)isAscii {
    NSInteger count = 0;
    
    if ([object isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)object;
        UITextRange *markedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:markedRange.start offset:0];
        
        if (!position) {
            // 没有高亮选择的字，则对已输入的文字进行字数统计
            count = isAscii ? [HYCommonTool asciiLengthOfString:textView.text] : [textView.text length];
        }else {
            // 有高亮选择的字符串，则对非高亮文字进行统计
            NSString *markString = [textView textInRange:markedRange];
            count = isAscii ? ([HYCommonTool asciiLengthOfString:textView.text] - [HYCommonTool asciiLengthOfString:markString]) : (textView.text.length - markString.length);
        }
    }
    if ([object isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)object;
        UITextRange *markedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:markedRange.start offset:0];
        
        if (!position) {
            // 没有高亮选择的字，则对已输入的文字进行字数统计
            count = isAscii ? [HYCommonTool asciiLengthOfString:textField.text] : [textField.text length];
        }else {
            // 有高亮选择的字符串，则对非高亮文字进行统计
            NSString *markString = [textField textInRange:markedRange];
            count = isAscii ? ([HYCommonTool asciiLengthOfString:textField.text] - [HYCommonTool asciiLengthOfString:markString]) : (textField.text.length - markString.length);
        }
    }
    
    return count;
}

+ (NSUInteger)asciiLengthOfString:(NSString *)text {
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        
        
        unichar uc = [text characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    return asciiLength;
}

#pragma mark =============== 货币相关 ====================
/**
 *  @author 有点坑, 15-08-30 12:08:43
 *
 *  TODO:货币乘法
 *
 *  @param multiplierValue   乘数
 *  @param multiplicandValue 被乘数
 */
+ (NSDecimalNumber *)decimalNumberMutiplyWithMultiplierValue:(NSString *)multiplierValue multiplicandValue:(NSInteger)multiplicandValue {
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", multiplierValue]];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld", (long)multiplicandValue]];
    NSDecimalNumber *product = [multiplicandNumber decimalNumberByMultiplyingBy:multiplierNumber];
    return product;
}

/**
 *  @author 有点坑, 15-08-30 12:08:36
 *
 *  TODO:货币加法
 *
 *  @param addValue    加数
 *  @param addentValue 被加数
 */
+ (NSDecimalNumber *)decimalNumberAddWithAddNumber:(NSDecimalNumber *)addNumber addentNumber:(NSDecimalNumber *)addentNumber {
    NSDecimalNumber *product = [addNumber decimalNumberByAdding:addentNumber];
    return product;
}

+ (NSString *)decimalNumberAddWithAddValue:(NSString *)addValue addentValue:(NSString *)addentValue {
    NSDecimalNumber *addNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", addValue]];
    NSDecimalNumber *addentNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", addentValue]];
    NSDecimalNumber *product = [addNumber decimalNumberByAdding:addentNumber];
    return [product stringValue];
}

/**
 *  @author 有点坑, 15-09-14 11:09:46
 *
 *  TODO:货币减法
 *
 *  @param subtractionValue 被减数
 *  @param subtrahendValue  减数
 */
+ (NSString *)decimalNumberSubtractingWithSubtractionValue:(NSString *)subtractionValue subtrahendValue:(NSString *)subtrahendValue {
    NSDecimalNumber *subtraction = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", subtractionValue]];
    NSDecimalNumber *subtrahend = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", subtrahendValue]];
    NSDecimalNumber *product = [subtraction decimalNumberBySubtracting:subtrahend];
    return [product stringValue];
}




/*检测是否在iPhone“设置”中打开推送*/
+ (BOOL)appIsOpenForRemoteNotifications {
    BOOL isteredForRemoteNotifications = [UIApplication sharedApplication].isRegisteredForRemoteNotifications;
    /* tang */
    isteredForRemoteNotifications = [self pushNotificationsEnabled];
    
    return isteredForRemoteNotifications;
}

/* iOS8.0 检测通知是否开启的方法 */
+ (BOOL)pushNotificationsEnabled {
    UIUserNotificationType types = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
    return (types & UIUserNotificationTypeAlert);
}

//相对路径转绝对地址
+ (NSString *)relativeUrlToAbsolute:(NSString *)relativeUrl {
    if (![relativeUrl hasPrefix:@"http"]) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"sys_config"];
        NSString *completeUrl;
        
        if ([relativeUrl hasPrefix:@"ysqn"]) {
            //七牛
            NSDictionary *qiniuConfig = dict[@"qiniu_config"];
            completeUrl = [NSString stringWithFormat:@"%@%@", qiniuConfig[@"qiniu_host"], relativeUrl];
        }else {
            completeUrl = [NSString stringWithFormat:@"%@%@", dict[@"img_host"], relativeUrl];
        }
        
        return [HYCommonTool convertUrlString:completeUrl];
    }
    return [HYCommonTool convertUrlString:relativeUrl];
}

/// 打开设置界面
+ (void)openSystemSetting {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}


#pragma mark ============== iPhone X 适配 =============
/// 判断是否iPhone X
+ (BOOL)isiPhoneX {
    NSString *platform = [HYCommonTool phonePlatform];
    
    if ([platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"]) {
        //真机iPhone X
        return YES;
    }else if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) {
        //模拟器iPhone X
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
        if (screenW == 375 && screenH == 812) {
            return YES;
        }
    }
    
    return NO;
}

/// iPhone X 底部预留高度
+ (CGFloat)bottomReservedSpacing {
    return ([HYCommonTool isiPhoneX] ? HY_iPhoneXBotLex : 0);
}
/// iPhone X 顶部预留高度
+ (CGFloat)topReservedSpacing {
    return ([HYCommonTool isiPhoneX] ? HY_iPhoneXTopLex : 0);
}

#pragma mark ============== 手机、邮箱、纯数字等校验 =============
/// 校验是否为手机号码  11位
+ (BOOL)isMobilePhone:(NSString *)phone {
    phone = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (phone.length == 0) {
        return NO;
    }
    
    NSString *regx = @"^(1\\d{10})$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regx];
    BOOL isValid = [predicate evaluateWithObject:phone];
    return isValid;
}

/// 校验是否为邮箱
+ (BOOL)isEmail:(NSString *)email {
    if (email.length == 0) {
        return NO;
    }
    
    NSString *regx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regx];
    BOOL isValid = [predicate evaluateWithObject:email];
    return isValid;
}

/// 检验是否为合法身份证 （只校验长度）
+ (BOOL)isIDCardNo:(NSString *)cardNo {
    if (cardNo.length == 15 || cardNo.length == 18) {
        return YES;
    }
    
    return NO;
}

/// 检验是否为合法身份证 （只校验长度）
+ (BOOL)isAllNumber:(NSString *)string {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\n"] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    return [string isEqualToString:filtered];
}

/// 检查是否符合密码规则 (26个英文字母+数字)
+ (BOOL)isPassword:(NSString *)str  {
    NSString *regex = @"^[A-Za-z0-9_]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}


#pragma mark ============== 设备信息 ===============
/**
 *  TODO:获取当前设备的名称 更新到IPhone X 和 IPad4
 */
+ (NSString *)deviceName {
    NSString *platform = [HYCommonTool phonePlatform];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}

/// 获取设备平台信息
+ (NSString *)phonePlatform {
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    return platform;
}

/*获取系统版本*/
+ (NSString *)systemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

/*app版本*/
+ (NSString *)appVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

/*设备类型*/
+ (NSString *)deviceModel {
    return [[UIDevice currentDevice] model];
}

/*设备国际化区域*/
+ (NSString *)deviceLocal {
    return [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
}

/*获取项目名称*/
+ (NSString *)getProjectName {
    NSString *projectName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return projectName;
}

#pragma mark ============== 基本数据类型处理 ==============
/// json对象转字符串
+ (NSString *)jsonToString:(id)object {
    if (!object || ![object isKindOfClass:[NSObject class]] || [object isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:NULL];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSMutableString *str = [[NSMutableString alloc] initWithString:jsonString];
    str = [NSMutableString stringWithString:[str stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
    return str;
}

/// 字符串转json对象
+ (id)stringToJsonObject:(NSString *)jsonString {
    if (!jsonString || ![jsonString isKindOfClass:[NSString class]] || jsonString.length == 0) {
        return nil;
    }
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
}

/// 将字符串转换为数据
+ (NSArray *)convertStringToArr:(NSString *)string {
    if (string && string.length > 0) {
        return [string componentsSeparatedByString:@","];
    }else {
        return @[];
    }
}



@end
