//
//  HYCommonTool.h
//  QAService
//
//  Created by captain on 15/9/6.
//  Copyright (c) 2015年 李诚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface HYCommonTool : NSObject

/*
 * 函数作用: 获取uuid
 * 函数参数:
 * 函数返回值: uuid
 */
+(NSString *)uuid;

/*
 *  将string转换成MD5格式数据
 *  需引进库<CommonCrypto/CommonDigest.h>
 */
+ (NSString *)stringToMD5Value:(NSString *)string;

/**
 *  @Author 有点坑, 15-07-26 17:07:00
 *
 *  TODO:获取文本的绘制size
 *
 *  @param text
 *  @param size
 *  @param font
 */
+ (CGRect)getRectFromString:(NSString *)string withRestrictSize:(CGSize)size font:(UIFont *)font;




//对url进行unicode编码
+ (NSString *)convertUrlString:(NSString *)url;

/**
 *  @author 有点坑, 15-05-15 17:05:27
 *
 *  TODO:获取输入框去高亮部分的 长度
 */
+ (NSInteger)getTextCountWithoutMarked:(id)object;

/*
 *  获取输入框去高亮部分的 ascii码长度
 *  一个中文算2个字符
 */
+ (NSInteger)getTextAsciiCountWithoutMarked:(id)object;


/**
 *
 *  获取ascii码长度
 */
+ (NSUInteger)asciiLengthOfString:(NSString *)text;


#pragma mark =============== 货币相关 ====================
/**
 *  @author 有点坑, 15-08-30 12:08:43
 *
 *  TODO:货币乘法
 *
 *  @param multiplierValue   乘数
 *  @param multiplicandValue 被乘数
 */
+ (NSDecimalNumber *)decimalNumberMutiplyWithMultiplierValue:(NSString *)multiplierValue multiplicandValue:(NSInteger)multiplicandValue;

/**
 *  @author 有点坑, 15-08-30 12:08:36
 *
 *  TODO:货币加法
 *
 *  @param addValue    加数
 *  @param addentValue 被加数
 */
+ (NSDecimalNumber *)decimalNumberAddWithAddNumber:(NSDecimalNumber *)addNumber addentNumber:(NSDecimalNumber *)addentNumber;

+ (NSString *)decimalNumberAddWithAddValue:(NSString *)addValue addentValue:(NSString *)addentValue;

/**
 *  @author 有点坑, 15-09-14 11:09:46
 *
 *  TODO:货币减法
 *
 *  @param subtractionValue 被减数
 *  @param subtrahendValue  减数
 */
+ (NSString *)decimalNumberSubtractingWithSubtractionValue:(NSString *)subtractionValue subtrahendValue:(NSString *)subtrahendValue;






/*检测是否在iPhone“设置”中打开推送*/
+ (BOOL)appIsOpenForRemoteNotifications;

//相对路径转绝对地址
+ (NSString *)relativeUrlToAbsolute:(NSString *)relativeUrl;



/// 打开设置界面
+ (void)openSystemSetting;


#pragma mark ============== iPhone X 适配 =============
/// 判断是否iPhone X
+ (BOOL)isiPhoneX;
/// iPhone X 底部预留高度
+ (CGFloat)bottomReservedSpacing;
/// iPhone X 顶部预留高度
+ (CGFloat)topReservedSpacing;


#pragma mark ============== 手机、邮箱、纯数字等校验 =============
/// 校验是否为手机号码
+ (BOOL)isMobilePhone:(NSString *)phone;

/// 校验是否为邮箱
+ (BOOL)isEmail:(NSString *)email;

/// 检验是否为合法身份证 （只校验长度）
+ (BOOL)isIDCardNo:(NSString *)cardNo;

/// 是否为全数字
+ (BOOL)isAllNumber:(NSString *)string;

/// 检查是否符合密码规则(26个英文字母+数字)
+ (BOOL)isPassword:(NSString *)str;

#pragma mark ========== 设备信息 ===============
/**
 *  TODO:获取当前设备的名称 更新到IPhone X 和 IPad4
 */
+ (NSString *)deviceName;

/*获取系统版本*/
+ (NSString *)systemVersion;

/*app版本*/
+ (NSString *)appVersion;

/*设备类型*/
+ (NSString *)deviceModel;

/*设备国际化区域*/
+ (NSString *)deviceLocal;

/*获取项目名称*/
+ (NSString *)getProjectName;


#pragma mark ============== 基本数据类型处理 ==============
/// json对象转字符串
+ (NSString *)jsonToString:(id)object;

/// 字符串转json对象
+ (id)stringToJsonObject:(NSString *)jsonString;

/// 将字符串转换为数据
+ (NSArray *)convertStringToArr:(NSString *)string;

@end
