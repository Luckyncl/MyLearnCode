//
//  AudioQueueServicesAPI.m
//  AudioToolboxTest
//
//  Created by Apple on 2018/3/2.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "AudioQueueServicesAPI.h"
#import <AudioToolbox/AudioToolbox.h>
@interface AudioQueueServicesAPI ()
{

    AudioQueueRef audioQueueRef;  // 音频队列上下文
}
@end

@implementation AudioQueueServicesAPI

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.



    OSStatus status ;

    /*      Audio Queue Services        */
    /*
     音频队列是用于录制或播放音频的软件对象。 一个音频队列完成以下工作：

     1、连接到音频硬件

     2、管理内存

     3、根据需要使用编解码器来压缩音频格式

     4、调解播放或录制
     音频队列服务使您能够以线性PCM，压缩格式（如Apple Lossless和AAC）以及用户已安装编解码器的其他格式录制和播放音频。 音频队列服务还支持多个音频队列的预定播放和同步以及音频与视频的同步。
     */

#pragma mark - 创建播放队列
    // 创建一个新的播放音频队列对象。
    AudioStreamBasicDescription indataFormat;
    //    inCallbackRunLoop为AudioQueueOutputCallback需要在的哪个RunLoop上被回调，如果传入NULL的话就会再AudioQueue的内部RunLoop中被回调，所以一般传NULL就可以了；
    //
    //    inCallbackRunLoopMode为RunLoop模式，如果传入NULL就相当于kCFRunLoopCommonModes，也传NULL就可以了；
    //inFlags是保留字段，目前没作用，传0；
    //     status = AudioQueueNewOutput(indataFormat, <#AudioQueueOutputCallback  _Nonnull inCallbackProc#>, <#void * _Nullable inUserData#>, NULL, NULL, 0, &audioQueueRef);


    //    播放的回调  在音频队列完成获取缓冲区时调用回调
    //    typedef void (*AudioQueueOutputCallback)(
    //                                             void * __nullable       inUserData,
    //                                             AudioQueueRef           inAQ,
    //                                             AudioQueueBufferRef     inBuffer);


#pragma mark - 创建录音队列

    AudioStreamBasicDescription inputFormat;
    // AudioQueueNewInput(inputFormat, <#AudioQueueInputCallback  _Nonnull inCallbackProc#>, <#void * _Nullable inUserData#>, <#CFRunLoopRef  _Nullable inCallbackRunLoop#>, <#CFStringRef  _Nullable inCallbackRunLoopMode#>, <#UInt32 inFlags#>, <#AudioQueueRef  _Nullable * _Nonnull outAQ#>)

    //    typedef void (*AudioQueueInputCallback)(
    //                                            void * __nullable               inUserData,
    //                                            AudioQueueRef                   inAQ,
    //                                            AudioQueueBufferRef             inBuffer,
    //                                            const AudioTimeStamp *          inStartTime,
    //                                            UInt32                          inNumberPacketDescriptions,
    //                                            const AudioStreamPacketDescription * __nullable inPacketDescs);



    //    AudioQueueDispose(<#AudioQueueRef  _Nonnull inAQ#>, <#Boolean inImmediate#>)
    //如果传递true，则音频队列立即被处理（即，同步）。 如果您通过false，则在处理所有排队缓冲区（即，异步）之前不会进行处理。
    //   处置音频队列也会处理其资源，包括其缓冲区。 调用此函数后，您将无法再与音频队列交互。 另外，音频队列不再调用任何回调。




    // 传入 NULL 会立即启动
    AudioQueueStart(audioQueueRef, NULL);

    /*   解码入队缓冲区以准备 播放。    */
    //    AudioQueuePrime(audioQueueRef, <#UInt32 inNumberOfFramesToPrepare#>, <#UInt32 * _Nullable outNumberOfFramesPrepared#>)


    //    调用AudioQueueEnqueueBuffer。
    //
    //    调用AudioQueuePrime。
    //
    //    调用AudioQueueStart。



    /*   重置音频队列的解码状态   */

    /*  排入最后一个音频队列缓冲区后调用AudioQueueFlush，以确保所有缓冲数据以及正在处理的所有音频数据都被记录或播放。 如果您不调用此函数，则音频队列解码器中陈旧的数据可能会干扰播放或记录下一组缓冲区。

     如果要确保所有入队数据都到达目的地，请在调用AudioQueueStop之前调用此函数。
     */
    AudioQueueFlush(audioQueueRef);



    /*                暂停播放或者录制                  */
    /* 暂停音频队列不会影响缓冲区或重置音频队列。 要恢复播放或录音，请拨打AudioQueueStart。  */
    AudioQueuePause(audioQueueRef);


    /*   audioQueueueStop 调用后会自动调用  AudioQueueReset   */
    AudioQueueReset(audioQueueRef);


}



@end
