//
//  AudioQueueRecorder.h
//  AudioToolboxTest
//
//  Created by Apple on 2018/3/8.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CheckStatus.h"
#import <AVFoundation/AVFoundation.h>

static const int kNumberBuffers = 3;
static const int kSampleteRate  = 441000;
static const int kBufferSize = 2048;


@interface AudioQueueTool : NSObject

@property (nonatomic, copy)NSString *fileUrl;   // 录制的地址

@property (nonatomic, assign)BOOL isRecording;


- (void)pauseRecord;

- (void)finishRecord;

- (void)startRecord;

@end
