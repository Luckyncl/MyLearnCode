//
//  ViewController.m
//  AudioToolboxTest
//
//  Created by Apple on 2018/1/4.
//  Copyright © 2018年 Apple. All rights reserved.
//     http://www.cocoachina.com/ios/20170721/19969.html
// https://developer.apple.com/documentation/audiotoolbox/audio_file_services?language=objc
// http://www.cocoachina.com/industry/20140722/9216.html

//  http://www.code4app.com/thread-27323-1-1.html


/*
// http://yoferzhang.com/post/20160811OCMemoryManagement/   内存管理
 Objective-C运行时编程指南（Objective-C Runtime Programming Guide） https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Introduction/Introduction.html
 */





#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NSString+encode.h"
#import "AudioFileServicesDemo.h"
#import "AudioQueueTool.h"
@interface ViewController ()
{
    AudioStreamBasicDescription dataFormat;
    AudioFileID audioFileID;

    AudioQueueRef audioQueueRef;  // 音频队列上下文
    BOOL isStop;                 // 是否停止了
    BOOL isStart;                // 是否开始了
    
    UITableView *tableView;

}

@property (nonatomic, strong) AudioQueueTool *tool;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.



    OSStatus status ;


//  测试音频.m4a      ssssssssss1538048 有效帧数  一共所有的帧数1541120
//   NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"441" ofType:@"mp3"];

   NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"测试音频" ofType:@"aac"];
   NSURL *mp3Url = [NSURL URLWithString:[mp3Path stringByURLEncode]];
//    NSURL *mp3Url = nil;
//   mp3Url = [NSURL fileURLWithPath:[@"/Users/Apple/Desktop/测试音.m4a" stringByURLEncode]];



   NSData *mp3Data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:mp3Path]];

    NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                                 objectAtIndex:0];
    NSString *filePath = [documentsFolder stringByAppendingPathComponent:@"Recording.caf"];

//   BOOL isSuccess = [mp3Data writeToFile:filePath atomically:YES];
//
//    if (!isSuccess) {
//        NSLog(@"不能写入");
//    }
//
//    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        NSLog(@"文件不存在");
//        return;
//    }


    self.tool = [AudioQueueTool new];
//    AudioStreamBasicDescription  mDataFormat;                  //
//    AudioQueueRef                mQueue;                        //
//    AudioQueueBufferRef          mBuffers[kNumberBuffers];
//    AudioFileID                  mAudioFile;
//    UInt32                       bufferByteSize;
//    SInt64                       mCurrentPacket;
//    bool                         mIsRunning;
//    AudioFileTypeID              mFileTypeID;
    
    

    
//    AudioStreamBasicDescription outAudioStreamBasicDescription = {0}; // Always initialize the fields of a new audio stream basic description structure to zero, as shown here: ...
//    outAudioStreamBasicDescription.mSampleRate = inAudioStreamBasicDescription.mSampleRate; // The number of frames per second of the data in the stream, when the stream is played at normal speed. For compressed formats, this field indicates the number of frames per second of equivalent decompressed data. The mSampleRate field must be nonzero, except when this structure is used in a listing of supported formats (see “kAudioStreamAnyRate”).
//    outAudioStreamBasicDescription.mFormatID = kAudioFormatMPEG4AAC; // kAudioFormatMPEG4AAC_HE does not work. Can't find `AudioClassDescription`. `mFormatFlags` is set to 0.
//    outAudioStreamBasicDescription.mFormatFlags = kMPEG4Object_AAC_LC; // Format-specific flags to specify details of the format. Set to 0 to indicate no format flags. See “Audio Data Format Identifiers” for the flags that apply to each format.
//    outAudioStreamBasicDescription.mBytesPerPacket = 0; // The number of bytes in a packet of audio data. To indicate variable packet size, set this field to 0. For a format that uses variable packet size, specify the size of each packet using an AudioStreamPacketDescription structure.
//    outAudioStreamBasicDescription.mFramesPerPacket = 1024; // The number of frames in a packet of audio data. For uncompressed audio, the value is 1. For variable bit-rate formats, the value is a larger fixed number, such as 1024 for AAC. For formats with a variable number of frames per packet, such as Ogg Vorbis, set this field to 0.
//    outAudioStreamBasicDescription.mBytesPerFrame = 0; // The number of bytes from the start of one frame to the start of the next frame in an audio buffer. Set this field to 0 for compressed formats. ...
//    outAudioStreamBasicDescription.mChannelsPerFrame = 1; // The number of channels in each frame of audio data. This value must be nonzero.
//    outAudioStreamBasicDescription.mBitsPerChannel = 0; // ... Set this field to 0 for compressed formats.
    
  

  
    
    
    self.tool.fileUrl = filePath;
    

   CFURLRef mp3UrlRef = (__bridge CFURLRef)[NSURL URLWithString:filePath];








//    size = sizeof(dataFormat);
//    status = ExtAudioFileSetProperty(audioFileRef, kExtAudioFileProperty_ClientDataFormat, size, &dataFormat);
//
//    if ([self checkStatus:status WithTips:@"设置pcm格式失败"]) {
//        return;
//    }


    /**/
    //    status = ExtAudioFileSeek(audioFileRef, 1);
    //
    //    if ([self checkStatus:status WithTips:@"设置偏移量失败"]) {
    //        return;
    //    }



}


- (BOOL)checkStatus:(OSStatus)status WithTips:(NSString *)tips
{
//    ostatus的网站
//    https://www.osstatus.com/
    if (status != noErr) {
        
        NSLog(@"[\n产生了错误===osstatus ==  %d \n %@]",status,tips);
        return YES;
    }else{
        return NO;
    }
}

- (IBAction)record:(id)sender {
    if (isStart) {
        return;
    }else{
        [self.tool startRecord];
        isStart = YES;
    }
}



- (IBAction)stop:(id)sender {
    
    if (isStart) {
        [self.tool finishRecord];
        isStart = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.


    /*
     char *aacBuf;

     if(!aacBuf){
     aacBuf = malloc(inBufferList.mBuffers[0].mDataByteSize);
     }

     // 初始化一个输出缓冲列表
     AudioBufferList outBufferList;
     outBufferList.mNumberBuffers              = 1;
     outBufferList.mBuffers[0].mNumberChannels = inBufferList.mBuffers[0].mNumberChannels;
     outBufferList.mBuffers[0].mDataByteSize   = inBufferList.mBuffers[0].mDataByteSize; // 设置缓冲区大小
     outBufferList.mBuffers[0].mData           = aacBuf; // 设置AAC缓冲区
     UInt32 outputDataPacketSize               = 1;
     if (AudioConverterFillComplexBuffer(m_converter, inputDataProc, &inBufferList, &outputDataPacketSize, &outBufferList, NULL) != noErr){
     return;
     }
     AudioFrame *audioFrame = [AudioFrame new];
     audioFrame.timestamp = timeStamp;
     audioFrame.data = [NSData dataWithBytes:aacBuf length:outBufferList.mBuffers[0].mDataByteSize];

     char exeData[2];
     exeData[0] = _configuration.asc[0];
     exeData[1] = _configuration.asc[1];
     audioFrame.audioInfo =[NSData dataWithBytes:exeData length:2];
     */
}



@end
