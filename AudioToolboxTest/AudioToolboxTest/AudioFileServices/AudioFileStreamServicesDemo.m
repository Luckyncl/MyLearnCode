//
//  AudioFileStreamServicesDemo.m
//  AudioToolboxTest
//
//  Created by Apple on 2018/2/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "AudioFileStreamServicesDemo.h"

@interface AudioFileStreamServicesDemo ()

@end

@implementation AudioFileStreamServicesDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//http://msching.github.io/blog/2014/07/09/audio-in-ios-3/ 可以观看文章地址

    /*
     音频文件流的使用步骤：
     1、通过调用AudioFileStreamOpen函数创建一个新的音频文件流解析器。 将指针传递给音频数据和元数据的回调函数（AudioFileStream_PacketsProc和AudioFileStream_PropertyListenerProc）。 AudioFileStreamOpen函数为您提供了对新解析器的引用。
     2、获取一些流式数据。 当有数据传递给解析器时调用AudioFileStreamParseBytes函数。 按顺序将数据发送到解析器，如果可能的话，没有间隙。
     1、当解析器获取音频数据的可用缓冲区时，它会调用您的音频数据回调。 您的回调可以播放数据，将其写入文件或以其他方式处理。
     2、当解析器获取元数据时，它会调用属性回调 - 这又可以通过调用AudioFileStreamGetPropertyInfo和AudioFileStreamGetProperty函数来获取属性值。
     3、当完成分析流时，调用AudioFileStreamClose函数关闭和释放解析器。

     音频文件流服务支持的文件格式：
     AIFF、AIFC、WAVE、CAF、NeXT、ADTS、MPEG Audio Layer 3、AAC

     */


#pragma mark - 创建音频流解析器
    /*
     第一个参数是 上下文对象， 第二个参数为 歌曲属性监听的回调，每解析出一个歌曲属性，就会调用一次， 第三个参数是 分离音频帧的回调，每解析出一部分帧就会调用一次
     第四个参数 AudioFileTypeID 是文件类型的标识，通过这个参数来帮助 AudioFileStream 对文件格式进行解析。 如果不知道文件的确定类型 就传入0
     第五个参数 常 保存起来用作后续一些方法的参数使用
     */

    //    typedef void (*AudioFileStream_PropertyListenerProc)(
    //                                                         void *                            inClientData,
    //                                                         AudioFileStreamID                inAudioFileStream,
    //                                                         AudioFileStreamPropertyID        inPropertyID,
    //                                                         AudioFileStreamPropertyFlags *    ioFlags);

    //    typedef void (*AudioFileStream_PacketsProc)(
    //                                               void *                            inClientData,
    //                                               UInt32                            inNumberBytes,
    //                                               UInt32                            inNumberPackets,
    //                                               const void *                    inInputData,
    //                                               AudioStreamPacketDescription    *inPacketDescriptions);
    //

    //    AudioFileStreamOpen(<#void * _Nullable inClientData#>, <#AudioFileStream_PropertyListenerProc  _Nonnull inPropertyListenerProc#>, <#AudioFileStream_PacketsProc  _Nonnull inPacketsProc#>, <#AudioFileTypeID inFileTypeHint#>, <#AudioFileStreamID  _Nullable * _Nonnull outAudioFileStream#>)



#pragma mark - 解析数据

    //    extern OSStatus
    //    AudioFileStreamParseBytes(
    //                              AudioFileStreamID                inAudioFileStream,
    //                              UInt32                            inDataByteSize,
    //                              const void * __nullable            inData,
    //                              AudioFileStreamParseFlags        inFlags)


    /*
     注意第四个参数： 音频文件流标志。 如果传递给解析器的最后一个数据存在不连续性，请设置kAudioFileStreamParseFlag_Discontinuity标志。
     kAudioFileStreamParseFlag_Discontinuity  一般这个表示都是设置了seek以后使用
     */


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
