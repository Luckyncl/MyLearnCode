//
//  AudioQueueRecorder.m
//  AudioToolboxTest
//
//  Created by Apple on 2018/3/8.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "AudioQueueTool.h"


@interface AudioQueueTool ()
{
    AudioStreamBasicDescription  mDataFormat;                  //
    AudioQueueRef                mQueue;                        //
    AudioQueueBufferRef          mBuffers[kNumberBuffers];
    AudioFileID                  mAudioFile;
    UInt32                       bufferByteSize;
    SInt64                       mCurrentPacket;
    AudioFileTypeID              mFileTypeID;                   // 文件格式
}


@end




@implementation AudioQueueTool



void DeriveBufferSize (AudioQueueRef audioQueue,AudioStreamBasicDescription *ASBDescription, Float64 seconds,UInt32                       *outBufferSize) {
    
    //    在这个例子中，上限设置为320 KB。这对应于大约五秒钟的立体声，采样速率为96 kHz的24位音频。
    static const int maxBufferSize = 0x50000;
    
    
    //对于CBR音频数据，从AudioStreamBasicDescription结构中获取（恒定）数据包大小。使用此值作为最大数据包大小。
    // 该分配具有确定要记录的音频数据是CBR还是VBR的副作用。如果它是VBR，则音频队列的AudioStreamBasicDescription结构列出字节数据包的值为0。
    int maxPacketSize = (*ASBDescription).mBytesPerPacket;
    
    //    对于VBR音频数据，查询音频队列以获取估计的最大数据包大小。
    if (maxPacketSize == 0) {
        UInt32 maxVBRPacketSize = sizeof(maxPacketSize);
        AudioQueueGetProperty(audioQueue,kAudioQueueProperty_MaximumOutputPacketSize,&maxPacketSize,&maxVBRPacketSize);
    }
    
    
    //   以字节为单位导出缓冲区大小。
    Float64 numBytesForTime =
    (*ASBDescription).mSampleRate * maxPacketSize * seconds;
    
    //     如果需要，将缓冲区大小限制为先前设置的上限。
    *outBufferSize = numBytesForTime < maxBufferSize ? numBytesForTime : maxBufferSize;
}



static void HandleInputBuffer(
                              void * __nullable               inUserData,
                              AudioQueueRef                   inAQ,
                              AudioQueueBufferRef             inBuffer,
                              const AudioTimeStamp *          inStartTime,
                              UInt32                          inNumberPacketDescriptions,
                              const AudioStreamPacketDescription * __nullable inPacketDescs)
{
    
    AudioQueueTool *tool = (__bridge AudioQueueTool *)inUserData;
    
    // 输入数据等于0 ， 并且 每个数据包的字节数不为零的时候
    if (inNumberPacketDescriptions == 0 && tool -> mDataFormat.mBytesPerPacket != 0) {
        inNumberPacketDescriptions = inBuffer->mAudioDataByteSize / tool->mDataFormat.mBytesPerPacket;
    }
    
    
    OSStatus status = noErr;
    status = AudioFileWritePackets(tool->mAudioFile, false, inBuffer->mAudioDataByteSize, inPacketDescs, tool->mCurrentPacket, &inNumberPacketDescriptions, inBuffer->mAudioData);
    
    if (!checkStatus(status, @"写入出错！")) {
        tool->mCurrentPacket += inNumberPacketDescriptions;
    }
    
    if (tool.isRecording == NO ) {
        return;
    }
    
    
    
//    inPacketDescs指针指向的数据包描述的数量。适用
//    仅用于输出队列，并且仅适用于可变比特率（VBR）音频格式。 通过
//    0表示输入队列（不需要数据包描述）
    
//    一组数据包描述。 仅适用于输出队列，仅适用于输出队列
//             可变比特率（VBR）音频格式。 对输入队列传递NULL（无数据包
//             描述是必需的）。
    AudioQueueEnqueueBuffer(tool->mQueue, inBuffer, 0,NULL);
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        AudioStreamBasicDescription audioDescription = {0} ;
//        audioDescription.mFormatFlags = kLinearPCMFormatFlagIsBigEndian | kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
//        audioDescription.mFormatID = kAudioFormatLinearPCM;
//        audioDescription.mBitsPerChannel = 16;
//        audioDescription.mChannelsPerFrame = 2;      // 双通道
//        audioDescription.mBytesPerPacket = audioDescription.mBytesPerFrame = audioDescription.mChannelsPerFrame * (audioDescription.mBitsPerChannel/8);
//        audioDescription.mFramesPerPacket = 1;
//        audioDescription.mSampleRate = kSampleteRate;
        
        
//        audioDescription.mFormatFlags = kAudioFormatFlagIsNonMixable;
        audioDescription.mFormatID = kAudioFormatMPEG4AAC;
        audioDescription.mBitsPerChannel = 16;
        audioDescription.mChannelsPerFrame = 2;      // 双通道
      
        audioDescription.mBytesPerFrame = audioDescription.mChannelsPerFrame * (audioDescription.mBitsPerChannel/8);
        audioDescription.mBytesPerPacket = 1024 * audioDescription.mBytesPerFrame;
        
        audioDescription.mFramesPerPacket = 1024;
        audioDescription.mSampleRate = kSampleteRate;
        
        
        
        // 16 * 2 * /8 * 1024
        // MP3 是 1052
//        bufferByteSize = 2048 ;    // 注意这里  缓冲区大小 需要足够，如果缓冲区大小不够的话，就不会调用HandleInputBuffer
        mDataFormat = audioDescription;
        mFileTypeID = kAudioFileAIFFType;
    }
    return self;
}




- (void)startRecord{
//    AudioQueueInputCallback
//    指向描述要记录的音频数据格式的结构的指针。 对于
//             线性PCM，只支持交织格式。 压缩格式受支持。
    
//    [[AVAudioSession sharedInstance] setActive:YES error:nil];
//
//    // category
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
//
    
    AudioQueueTool *tool = self;
    OSStatus status = noErr;
    status = AudioQueueNewInput(&mDataFormat, HandleInputBuffer, (__bridge void *)self, NULL, NULL, 0, &mQueue);
    
    if (checkStatus(status, @"创建audioQueue出错")) {
        return;
    }

    NSURL *fileURL = [NSURL fileURLWithPath:tool.fileUrl];
    CFURLRef fileRef = (__bridge CFURLRef)fileURL;
    
    UInt32 dataFormatSize = sizeof (tool->mDataFormat);
    status = AudioQueueGetProperty (tool->mQueue,kAudioQueueProperty_StreamDescription,&tool->mDataFormat,&dataFormatSize);
    
    if (checkStatus(status, @"ss")) {
        return;
    }
    status = AudioFileCreateWithURL(fileRef, tool->mFileTypeID, &tool->mDataFormat, kAudioFileFlags_EraseFile, &tool->mAudioFile);
    
    if (checkStatus(status, @"创建文件失败！")) {
        return;
    }
    
    
    /*   计算缓冲区   这里没有什么用*/
    DeriveBufferSize(mQueue, &mDataFormat, 0.5,  &bufferByteSize);
    
    for (int i = 0; i < kNumberBuffers; ++i) {
        AudioQueueAllocateBuffer(tool->mQueue,tool->bufferByteSize,&tool->mBuffers[i]);
        AudioQueueEnqueueBuffer (tool->mQueue,tool->mBuffers[i], 0, NULL);
    }
    
    tool->mCurrentPacket = 0;
    _isRecording = YES;
    
    
    // 立即开始录音
    AudioQueueStart(tool->mQueue, NULL);
    NSLog(@"开始录音");
    
    
}




- (void)finishRecord{
    OSStatus status;
    NSLog(@"停止录音");
    AudioQueueTool *tool = self;
    AudioQueueStop (tool->mQueue,true);
    _isRecording = NO;
    status = AudioQueueDispose (tool->mQueue, true );
    if (checkStatus(status, @"关闭audioQueue失败")) {
        return;
    }
    
    status = AudioFileClose (tool->mAudioFile);
    if (checkStatus(status, @"关闭文件失败")) {
        return;
    }
}



- (void)pauseRecord
{
    if (_isRecording) {
        AudioQueuePause(mQueue);
    }
}



@end
