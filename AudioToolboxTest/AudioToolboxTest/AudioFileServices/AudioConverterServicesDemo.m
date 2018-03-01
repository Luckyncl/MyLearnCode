//
//  AudioConverterServicesDemo.m
//  AudioToolboxTest
//
//  Created by Apple on 2018/2/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "AudioConverterServicesDemo.h"
#import <AudioToolbox/AudioToolbox.h>

@interface AudioConverterServicesDemo ()
{
     AudioConverterRef converterRef;
}
@end

@implementation AudioConverterServicesDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.



    /*
     概述
     音频转换器对象在各种线性PCM音频格式之间转换。 他们还可以在线性PCM和压缩格式之间进行转换。 支持的转换包括以下内容：
     PCM位深度

     PCM采样率

     PCM浮点数来自PCM整数

     PCM交错去往和去交错的PCM

     PCM压缩格式
     */

    OSStatus status ;




    AudioStreamBasicDescription pcmAsbd = {0};
    pcmAsbd.mSampleRate = 441000;
    pcmAsbd.mFormatID = kAudioFormatLinearPCM;
    pcmAsbd.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked;
    pcmAsbd.mChannelsPerFrame = 2;  // 双声道
    pcmAsbd.mFramesPerPacket = 1;
    pcmAsbd.mBitsPerChannel = 16;
    pcmAsbd.mBytesPerFrame = pcmAsbd.mBitsPerChannel / 8 * pcmAsbd.mChannelsPerFrame;
    pcmAsbd.mBytesPerPacket = pcmAsbd.mBytesPerFrame * pcmAsbd.mFramesPerPacket;



    /*   这里设置aac的 AudioStreamBasicDescription      */
    AudioStreamBasicDescription targetAsbd ;
    memset(&targetAsbd, 0, sizeof(targetAsbd));
    targetAsbd.mSampleRate       = 441000; // 采样率保持一致
    targetAsbd.mFormatID         = kAudioFormatMPEG4AAC;    // AAC编码 kAudioFormatMPEG4AAC kAudioFormatMPEG4AAC_HE_V2
    targetAsbd.mChannelsPerFrame = 2;
    targetAsbd.mFramesPerPacket  = 1024;                    // AAC一帧是1024个字节

    const OSType subtype = kAudioFormatMPEG4AAC;
    AudioClassDescription requestedCodecs[2] = {
        {
            kAudioEncoderComponentType,
            subtype,
            kAppleSoftwareAudioCodecManufacturer
        },
        {
            kAudioEncoderComponentType,
            subtype,
            kAppleHardwareAudioCodecManufacturer
        }
    };
    status = AudioConverterNewSpecific(&pcmAsbd, &targetAsbd, 2, requestedCodecs, &converterRef);


#pragma mark - 根据指定的编解码方式 创建 音频转换器

    //      AudioConverterNewSpecific(&pcmAsbd, &targetAsbd, <#UInt32 inNumberClassDescriptions#>, <#const AudioClassDescription * _Nonnull inClassDescriptions#>, <#AudioConverterRef  _Nullable * _Nonnull outAudioConverter#>)

    //  AudioClassDescription 用于描述 此结构用于描述系统上安装的编解码器


#pragma mark - 根据音频格式创建 音频转换器
    status = AudioConverterNew(&pcmAsbd, &targetAsbd, &converterRef);

    /*
     ****  重要 ： 对于一对pcm 格式进行转换的时候，支持
     1、当输入和输出格式mChannelsPerFrame字段不匹配时，添加和删除通道。 通道也可以使用kAudioConverterChannelMap属性重新排序和删除。
     2、采样率转换。
     3、当输入和输出格式（mFormatFlags＆kAudioFormatFlagIsNonInterleaved）值不匹配时交织和解交织

     ** 支持线性PCM和压缩格式之间的编码和解码。 音频格式服务（AudioToolbox / AudioFormat.h）中的函数返回有关系统支持的格式的信息。 使用编解码器时，您可以使用任何支持的PCM格式。 转换器对象在您的PCM格式与编解码器创建或使用的格式之间执行任何必要的额外转换。
     */



#pragma mark -  重置音频转换器对象，清除并清空其缓冲区。
    status = AudioConverterReset(converterRef);


#pragma mark - 将pcm转换成另一种pcm （有局限）

    /*
     注意： 此功能用于将一种线性PCM格式转换为另一种格式的特殊情况。 此功能无法执行采样率转换，不能用于转换为大多数压缩格式或从大多数压缩格式转换而来。 要执行这些类型的转换，请改用AudioConverterFillComplexBuffer。
     */
    //    AudioConverterConvertBuffer(converterRef, <#UInt32 inInputDataSize#>, <#const void * _Nonnull inInputData#>, <#UInt32 * _Nonnull ioOutputDataSize#>, <#void * _Nonnull outOutputData#>)




    /***************************************************/

    // 用于相同采样率之间 pcm 的转换
    /*    在输入和输出数据缓冲区大小之间存在差异的情况下，该功能无法进行转换。 这包括采样率转换和涉及大多数压缩格式的转换。 在这些情况下，改用AudioConverterFillComplexBuffer函数。    */
    //    AudioConverterConvertComplexBuffer(<#AudioConverterRef  _Nonnull inAudioConverter#>, <#UInt32 inNumberPCMFrames#>, <#const AudioBufferList * _Nonnull inInputData#>, <#AudioBufferList * _Nonnull outOutputData#>)





#pragma mark - 不同格式间的转换(常用)

    //    AudioConverterFillComplexBuffer(converterRef, <#AudioConverterComplexInputDataProc  _Nonnull inInputDataProc#>, <#void * _Nullable inInputDataProcUserData#>, <#UInt32 * _Nonnull ioOutputDataPacketSize#>, <#AudioBufferList * _Nonnull outOutputData#>, <#AudioStreamPacketDescription * _Nullable outPacketDescription#>)



    //     AudioConverterComplexInputDataProc
    // ******* ==> 提供音频数据进行转换的回调函数。 当转换器准备好新的输入数据时，会重复调用此回调。
    //    typedef OSStatus
    //    (*AudioConverterComplexInputDataProc)(  AudioConverterRef               inAudioConverter,
    //                                          UInt32 *                        ioNumberDataPackets,
    //                                          AudioBufferList *               ioData,
    //                                          AudioStreamPacketDescription * __nullable * __nullable outDataPacketDescription,
    //                                          void * __nullable               inUserData);



    //    AudioStreamPacketDescription
    //在输入时，必须指向一个能够保存ioOutputDataPacketSize参数中指定的数据包描述数量的内存块。 （请参阅音频格式服务参考以了解可用于确定音频格式是否使用数据包说明的功能。 如果输出不为NULL，并且音频转换器的输出格式使用数据包描述，则此参数包含数据包描述。


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
