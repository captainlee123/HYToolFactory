//
//  HYMediaTool.m
//  HYToolFactory
//
//  Created by 李诚 on 2018/9/17.
//  Copyright © 2018年 李诚. All rights reserved.
//

#import "HYMediaTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation HYMediaTool

/*
 *  TODO: 视频压缩
 *  @param  videoURL        本地地址
 *  @param  outfilePath     导出地址
 *  @param  presetName      清晰度 (AVAssetExportPresetMediumQuality)
 */
+ (void)videoCompress:(NSURL *)videoURL outfilePath:(NSString *)outfilePath presetName:(NSString *)presetName completion:(hy_mediaBlock)completion {
    //视频压缩
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:presetName];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputURL = [NSURL fileURLWithPath:outfilePath];
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exportSession.status;
        switch (exportStatus) {
            case AVAssetExportSessionStatusFailed: {
                // log error to text view
                NSError *exportError = exportSession.error;
                NSLog (@"视频转码失败: %@", exportError);
                completion(nil);
                break;
            }
            case AVAssetExportSessionStatusCompleted: {
                NSLog(@"视频转码成功");
                completion(outfilePath);
                break;
            }
        }
    }];
}


/**
 **   函数作用 :播放声音
 **   函数参数 :
 **   函数返回值:
 **/
+ (void)playSound:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
    AudioServicesPlaySystemSound(soundID);
}

@end
