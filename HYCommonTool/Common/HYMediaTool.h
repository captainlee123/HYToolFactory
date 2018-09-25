//
//  HYMediaTool.h
//  HYToolFactory
//
//  Created by 李诚 on 2018/9/17.
//  Copyright © 2018年 李诚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 *  多媒体相关
 */

typedef void(^hy_mediaBlock)(id arg);

@interface HYMediaTool : NSObject

/*
 *  TODO: 视频压缩
 *  @param  videoURL        本地地址
 *  @param  outfilePath     导出地址
 *  @param  presetName      清晰度 (AVAssetExportPresetMediumQuality)
 */
+ (void)videoCompress:(NSURL *)videoURL outfilePath:(NSString *)outfilePath presetName:(NSString *)presetName completion:(hy_mediaBlock)completion;


/**
 **   函数作用 :播放声音
 **   函数参数 :
 **   函数返回值:
 **/
+ (void)playSound:(NSString *)name;

@end
