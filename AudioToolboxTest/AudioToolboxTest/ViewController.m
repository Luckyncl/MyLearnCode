//
//  ViewController.m
//  AudioToolboxTest
//
//  Created by Apple on 2018/1/4.
//  Copyright © 2018年 Apple. All rights reserved.
//     http://www.cocoachina.com/ios/20170721/19969.html
// https://developer.apple.com/documentation/audiotoolbox/audio_file_services?language=objc
// http://www.cocoachina.com/industry/20140722/9216.html

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NSString+encode.h"
@interface ViewController ()
{
    AudioStreamBasicDescription dataFormat;
    AudioFileID audioFileID;
}
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

/*
   ExtendedAudioFile提供高级音频文件访问，建立
   在AudioFile和AudioConverter API集之上。 它提供了一个单一的
   统一接口来读写编码和未编码的文件。  它比audiofileServices会更加常用一些 并且更加的方便
*/
   

//  测试音频.m4a      1538048 有效帧数  一共所有的帧数1541120
   NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"441" ofType:@"mp3"];

//   NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"测试音频" ofType:@"m4a"];
   NSURL *mp3Url = [NSURL URLWithString:[mp3Path stringByURLEncode]];
    
//   mp3Url = [NSURL URLWithString:[@"/Users/luckyncl/Desktop/测试音频.m4a" stringByURLEncode]];

//   NSData *mp3Data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:mp3Path]];
    
   CFURLRef mp3UrlRef = (__bridge CFURLRef)mp3Url;

    
#pragma mark- 创建文件
    

    //如果要创建的文件是压缩格式，则可以将inStreamDesc参数中的采样率设置为0.在所有情况下，扩展文件对象的编码转换器可能会以不同于采样率的采样率生成音频。 该文件将以编码器产生的音频格式创建。

//        创建或打开文件的标志。 如果设置了kAudioFileFlags_EraseFile标志，则擦除现有的文件。 如果该标志没有设置，那么如果URL指向一个已经存在的文件，则该函数失败
   // ExtAudioFileCreateWithURL(<#CFURLRef  _Nonnull inURL#>, <#AudioFileTypeID inFileType#>, <#const AudioStreamBasicDescription * _Nonnull inStreamDesc#>, <#const AudioChannelLayout * _Nullable inChannelLayout#>, <#UInt32 inFlags#>, <#ExtAudioFileRef  _Nullable * _Nonnull outExtAudioFile#>)
    
    
#pragma mark- 打开文件
    ExtAudioFileRef audioFileRef;
    OSStatus status ;
    // 注意这里的打开只能去读数据  ，而不是去写的
    status =  ExtAudioFileOpenURL(mp3UrlRef, &audioFileRef);

    if ([self checkStatus:status WithTips:@"打开文件错误"]) {
        return;
    }

   
#pragma mark-  没扩展音频文件对象 转换成 扩展音频文件对象
//   status = AudioFileOpenURL(mp3UrlRef, kAudioFileReadPermission, 0, &audioFileID);
//    if ([self checkStatus:status WithTips:@"AudioFileOpenURL 打开文件失败"]) {
//        return;
//    }
//
////     注意 如果使用了这个方法，你必须 在 关闭 audioFileRef 以后 再关闭 audioFileID
//    status = ExtAudioFileWrapAudioFileID(audioFileID, YES, &audioFileRef);
//
//    if ([self checkStatus:status WithTips:@"转换失败"]) {
//        return;
//    }

#pragma mark- 获取音频文件属性 和设置音频文件属性

/*
     ExtAudioFileGetPropertyInfo       获取音频属性信息

     ExtAudioFileSetProperty           设置音频属性

 */






    //    kExtAudioFileProperty_FileDataFormat

//     音频文件的格式，只读的
    
//    kExtAudioFileProperty_FileChannelLayout
//     文件的通道数        可读可写          设置它之前 需要先设置 kExtAudioFileProperty_ClientDataFormat
    
//    kExtAudioFileProperty_ClientDataFormat
//    在编解码非pcm文件的时候必须设置这个属性 也就是说进行文件转换的时候  **  非常重要  **
//    您的应用程序的音频流格式。 值是一个读/写AudioStreamBasicDescription结构。
    
//    kExtAudioFileProperty_ClientChannelLayout
//        音频流通道数     读/写          设置他的时候 先设置 kExtAudioFileProperty_ClientDataFormat
    
//    kExtAudioFileProperty_CodecManufacturer  可读可写
//您必须在设置kExtAudioFileProperty_ClientDataFormat属性之前指定此属性，然后触发创建编解码器。 在iOS中使用此属性可通过指定kAppleHardwareAudioCodecManufacturer或kAppleSoftwareAudioCodecManufacturer在硬件或软件编码器之间进行选择。

//    kExtAudioFileProperty_AudioConverter  只读属性   ** 重要 **
//     它会获取一个 AudioConverterRef 解码器上下文
//    如果您更改转换器的任何属性（例如比特率），则必须设置kExtAudioFileProperty_ConverterConfig属性。 当你这样做时，使用NULL配置就足够了。 设置该属性可确保输出文件的数据格式与converter.kAppleSoftwareAudioCodecManufacturer生成的格式一致。
    
 //    kExtAudioFileProperty_AudioFile  只读
 //    与扩展音频文件对象关联的音频文件对象。 值是一个只读的AudioFileID对象。

//    kExtAudioFileProperty_FileMaxPacketSize   只读
//     音频包的最大字节数
    
//    kExtAudioFileProperty_ClientMaxPacketSize  只读
//    您的应用程序音频数据格式的最大数据包大小（字节）。 值是一个只读的UInt32。
    
//   kExtAudioFileProperty_FileLengthFrames
//    文件一共多少帧  对于 pcm文件是可读写的，对于非pcm文件是 只读的
    
//    kExtAudioFileProperty_ConverterConfig    ** 可读可写  **
//    扩展音频文件对象的相关音频转换器的配置，由kAudioConverterPropertySettings属性指定。 值是一个读/写CFArray对象。
//    将此属性的值设置为NULL，强制转换器输出格式与文件数据格式重新同步。
  
    
//    kExtAudioFileProperty_IOBufferSizeBytes  可读可写， （用于编码的缓冲区大小）
//    扩展音频文件对象的关联音频转换器用于读取或写入关联音频文件的缓冲区的大小。 值是一个读写UInt32
//    只有存在基础音频转换器对象时，此属性才具有值

    
//    kExtAudioFileProperty_IOBuffer    可读可写   ******
//     用于编码的缓冲区
//此属性的值指向扩展音频文件对象在应用程序和文件数据格式之间转换时用于磁盘I / O的内存。 您可能希望您的应用程序在多个扩展音频文件对象之间共享此内存。 如果是这样，你可以设置这个属性指向你指定的缓冲区 - 当调用ExtAudioFileSetProperty函数时传递一个指针指向一个指针。 设置此属性后，您的应用程序必须设置kExtAudioFileProperty_IOBufferSizeBytes属性。

    
    
//    kExtAudioFileProperty_PacketTable
//  此属性可用于覆盖音频文件中的启动和剩余信息，还可检索扩展音频文件对象的当前启动和剩余帧信息。 如果基础文件类型不提供数据包表信息，则尝试获取此属性的值将返回错误。
    
#pragma mark- 获取audioFileRef 相关联的 audioFile对象
    AudioFileTypeID audioFileType = 0;
    UInt32 size = 0;
    UInt32 isWritable;
 
/*
    如果是通过audioFileRef 获取的 audioFileId 那么是当关闭 audioFileRef的时候就关闭了audioFileId
 */
    size = sizeof(audioFileID);
    status =  ExtAudioFileGetProperty(audioFileRef, kExtAudioFileProperty_AudioFile, &size, &audioFileID);
    if ([self checkStatus:status WithTips:@"获取audioFileRef 相关联的 audioFile对象 失败"]) {
        return;
    }
    
#pragma mark- 读写音频数据

    /*
     如果扩展音频文件对象具有应用程序数据格式，则对象的转换器将文件数据转换为应用程序格式。

     这个函数只能在一个线程上运行。 如果您希望应用程序读取多个线程上的音频文件，请改为使用音频文件服务。
     */

    UInt64 lengthOfFrames ;

    size = sizeof(lengthOfFrames);
    status = ExtAudioFileGetProperty(audioFileRef, kExtAudioFileProperty_FileLengthFrames,&size , &lengthOfFrames);
    if ([self checkStatus:status WithTips:@"获取音频帧数出错！"]) {
        return;
    }
 
    
    
    size = sizeof(dataFormat);
    status = ExtAudioFileGetProperty(audioFileRef, kExtAudioFileProperty_FileDataFormat, &size, &dataFormat);


    int numberOfBuffers = dataFormat.mFormatFlags & kAudioFormatFlagIsNonInterleaved ? dataFormat.mChannelsPerFrame : 1;
    AudioBufferList *audioBufferList = malloc(sizeof(audioBufferList) + sizeof(AudioBuffer)* (numberOfBuffers - 1));

    audioBufferList->mNumberBuffers = numberOfBuffers;
    
    status =  ExtAudioFileRead(audioFileRef, &lengthOfFrames, audioBufferList);

    if ([self checkStatus:status WithTips:@"读取音频数据出错"]) {
        return;
    }



//    UInt32 isWritableSize = sizeof(isWritable);
        //  获取audiofile文件  属性所占的大小，以及该属性是否可以被设置  ()
    status =  AudioFileGetPropertyInfo(audioFileID, kAudioFilePropertyFileFormat, &size, &isWritable);
    

    
    status = AudioFileGetProperty(audioFileID, kAudioFilePropertyFileFormat, &size, &audioFileType);
    
    
    // 用于判断文件格式
    if (audioFileType == kAudioFileAAC_ADTSType) {
        NSLog(@"读取的是是  kAudioFileAAC_ADTSType  文件");
    }
    NSLog(@"%d===",kAudioFileMP3Type);
    NSLog(@"isWritable == %d",isWritable);

    size = sizeof(dataFormat);
//    （对于一些属性值是可变的时候，必须先调用AudioFileGetPropertyInfo 获取属性所占大小以后在调用AudioFileGetProperty）
    status =   AudioFileGetProperty(audioFileID, kAudioFilePropertyDataFormat, &size, &dataFormat);
 

//    NSLog(@"size == %d  isWritable ==== %d   fromat == %d",audioFileType,isWritable,audioStreamBasicDescription);

    if ([self checkStatus:status WithTips:@"获取属性错误"]) {
        return;
    }
    


    //  ===========  文件读取      ==========
    
    // 读取多少字节数
//    AudioFileReadBytes(<#AudioFileID  _Nonnull inAudioFile#>, <#Boolean inUseCache#>, <#SInt64 inStartingByte#>, <#UInt32 * _Nonnull ioNumBytes#>, <#void * _Nonnull outBuffer#>)

    
    // 对于 kAudioFilePropertyAudioDataPacketCount 和 kAudioFilePropertyAudioDataByteCount 这两个音频属性需要uint64数据来获取
    UInt64 audioPacketCount;
    size = sizeof(audioPacketCount);
    
    status = AudioFileGetProperty(audioFileID, kAudioFilePropertyAudioDataPacketCount, &size, &audioPacketCount);

    
    UInt64 audioDataByteCount;
    status = AudioFileGetProperty(audioFileID, kAudioFilePropertyAudioDataByteCount, &size, &audioDataByteCount);
    

//    173053
    if ([self checkStatus:status WithTips:@"读取数据包数量失败"]) {
        return;
    }
    
    // 需要读取的音频包的数量
    UInt32 ioNumPackets = audioPacketCount;
    
#pragma mark-: 获取文件中最大数据包所占的字节数
    UInt32 uperBound = 0;
    size = sizeof(uperBound);
    
    // 获取理论上音频数据包的最大值
    status =  AudioFileGetProperty(audioFileID, kAudioFilePropertyPacketSizeUpperBound, &size, &uperBound);
    if ([self checkStatus:status WithTips:@"获取理论上数据包大小出错"]) {
        return;
    }
    
    UInt32 maxPacketSize = 0;
    size = sizeof(maxPacketSize);
    
    // 获取实际中文件的最大值
    status = AudioFileGetProperty(audioFileID, kAudioFilePropertyMaximumPacketSize, &size, &maxPacketSize);
    
    // 经测试对于m4a文件 理论上每个数据包的最大值 和 实际中每个数据包的最大值都是 734 字节
//    aac 文件 理论上每个数据包所占的字节数为 1536字节  实际上所占 为 537
//    mp3 理论上应该有 1052字节  实际上有 523
    
    if ([self checkStatus:status WithTips:@"获取最大包大小出错"]) {
        return;
    }
    

   
#pragma mark- :读取音频包数据 这里是读取了所有的的帧所占的字节数
    UInt32 ioNumBytes = ioNumPackets * maxPacketSize;
    
    AudioStreamPacketDescription *outPacketDescriptions = NULL;
    UInt32 descSize = sizeof(AudioStreamPacketDescription) *ioNumPackets;
    outPacketDescriptions = (AudioStreamPacketDescription *)malloc(descSize);
    SInt64 startIndexPacket = 0;  // 这里需要实例化
    void *outBuffer = (void *)malloc(ioNumBytes);
    void *inBuffer  = NULL;

    //441.mp3总的大小为 6055184
    status =  AudioFileReadPacketData(audioFileID, NO, &ioNumBytes, outPacketDescriptions, startIndexPacket, &ioNumPackets, outBuffer);
  //  总结： audioFileReadPacketData 在读取方面进行了优化，输出的字节数会小于等于 输入的自己数，当然这样说就是废话，优化的结果就是  输出的字节数是 小于等于输入字节数所形成的整数帧的总大小，也就是说最后读取的数据都是完整的帧数
//    memcpy(void *__dst, <#const void *__src#>, <#size_t __n#>)]
    
    NSData *data = [[NSData alloc] initWithBytes:outBuffer length:ioNumBytes];
    
    if (status == kAudioFileEndOfFileError) {
    
        NSLog(@"读取的数量超过文件结尾了");
    }
    
    if ([self checkStatus:status WithTips:@"读取数据出错"]) {
        return;
    }

    // 已经被废弃了
    // AudioFileReadPackets(<#AudioFileID  _Nonnull inAudioFile#>, <#Boolean inUseCache#>, <#UInt32 * _Nonnull outNumBytes#>, <#AudioStreamPacketDescription * _Nullable outPacketDescriptions#>, <#SInt64 inStartingPacket#>, <#UInt32 * _Nonnull ioNumPackets#>, <#void * _Nullable outBuffer#>)
    
#pragma mark-:  ================ 获取音频包列表信息的时候对于aac文件和mp3文件会获取失败   =======================
    
//    AudioFilePacketTableInfo
//    他包含有关文件中有效帧数以及开始和结束位置的信息。
//    有些数据格式可能包含内容不完全有效的数据包，但表示启动或剩余
//    不打算播放的帧。 例如，具有100个AAC包的文件名义上是1024×100 = 102400帧
//    数据的。 然而，第2112帧可能是启动帧，可能会有一些
//    添加的余数帧的数量，以填充1024帧的完整数据包。 启动和剩余帧应该是
//    丢弃。 文件中的数据包总数与每个数据包的帧数相乘（或计算每个数据包的帧数
//    单独针对每个分组格式的可变帧）减去mPrimingFrames，减去mRemainderFrame，应该
//    等于mNumberValidFrames
    AudioFilePacketTableInfo packTableInfo;
    size = sizeof(packTableInfo);
    
    /*
        注意对 aac 文件进行 kAudioFilePropertyPacketTableInfo 获取的时候会出错误，
        可能的原因猜测： aac 不是apple 默认的存储模式，所以 默认情况下对他获取，有问题
     */
    status = AudioFileGetProperty(audioFileID, kAudioFilePropertyPacketTableInfo, &size, &packTableInfo);
    if (status != noErr) {
        NSLog(@"对于aac文件进行有效帧获取会出错");
        size = 0;
    }
   

    
#pragma mark- AudioFramePacketTranslation  帧数和数据包进行转换  可以用于计算原始帧的总长度
//    AudioFramePacketTranslation
//     是用于pack和帧进行转换的的 500736
    
    AudioFramePacketTranslation packTranslation;
    packTranslation.mPacket = audioPacketCount;
    size = sizeof(packTranslation);
    size = 0;
    AudioFileGetPropertyInfo(audioFileID, kAudioFilePropertyPacketToFrame, &size, &isWritable);
    
    status = AudioFileGetProperty(audioFileID, kAudioFilePropertyPacketToFrame, &size, &packTranslation);
    
    if ([self checkStatus:status WithTips:@"帧数和数据包进行转换失败"]) {

        return;
    }

    
#pragma mark- :获取 文件指针偏移量
    
    SInt64 offSet;
    size = sizeof(offSet);
    status = AudioFileGetProperty(audioFileID, kAudioFilePropertyDataOffset, &size, &offSet);
    
    if ([self checkStatus:status WithTips:@"获取偏移量失败"]) {
        return;
    }
    
    
#pragma mark-: byte 和 音频数据包进行转化 注意 对于m4a 文件会出错误，mp3文件和aac文件的话不会出错误

    AudioBytePacketTranslation bytePackTranslation;
    bytePackTranslation.mPacket = audioPacketCount ;
//    bytePackTranslation.mByteOffsetInPacket= 0;
//    bytePackTranslation.mFlags = kBytePacketTranslationFlag_IsEstimate;
    size = sizeof(bytePackTranslation);
    status = AudioFileGetProperty(audioFileID, kAudioFilePropertyPacketToByte, &size, &bytePackTranslation);
    if ([self checkStatus:status WithTips:@"byte 和 音频数据包进行转化"]) {
        NSLog(@"对于m4a 文件会出错误，mp3文件和aac文件的话不会出错误");
    }
//
    
    
//     写音频数据
//     AudioFileWritePackets(<#AudioFileID  _Nonnull inAudioFile#>, <#Boolean inUseCache#>, <#UInt32 inNumBytes#>, <#const AudioStreamPacketDescription * _Nullable inPacketDescriptions#>, <#SInt64 inStartingPacket#>, <#UInt32 * _Nonnull ioNumPackets#>, <#const void * _Nonnull inBuffer#>)
    
    
    
#pragma mark:- 关闭文件
  
    status = ExtAudioFileDispose(audioFileRef);
    if ([self checkStatus:status WithTips:@"关闭文件出错"]) {
        return;
    }
//    status = AudioFileClose(audioFileID);
//    if ([self checkStatus:status WithTips:@"关闭文件出错"]) {
//        return;
//    }


    NSLog(@"测试完毕");

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

/*
sample 采样率，定义了每秒从连续信号中提取并组成离散信号的采样个数，用Hz表示
frame  帧，  一个音频帧
channel  通道，  一个次采样包括几个采样点
packet  帧数的集合，一个packet 包含多少个帧由文件格式决定， pcm文件 一个packet对应一个帧，而mp3文件一个packet对应1152个采样

 MP3 一帧采样为1152个， aac 每帧对应采样1024个，  一个AAC加上ADTS头以后就编程了ADTS AAC帧
 比特率 = 采样频率×采样位数×声道数
 pcm大小 = 采样频率×采样位数×声道数x时间/8
 */



/*

    AudioToolbox 是用于音频播放，录制，流处理的工具接口，
 AUAudioUnit
 这个类定义了一个音频单元的主机接口。

 AUAudioUnitBus
 在类定义的音频单元上的输入或输出连接点。

 AUAudioUnitBusArray
 的类定义了一个音频单元的输入或输出总线的容器。

 AUAudioUnitPreset
 所述类描述了一种通过音频单元显影剂提供的定制的参数设置的接口。这些预设通常会产生有用的声音或起点。

 AUAudioUnitV2Bridge
 所述类在包装2版的音频单元的子类。
 AUAudioUnitV2Bridge
 AUAudioUnit

 AUParameter
 一个
 AUParameter
 对象表示一个音频单元参数。

 AUParameterGroup
 一个对象表示一组相关的音频单元参数。一个参数组对于其子女是符合KVC的。
 AUParameterGroup

 AUParameterNode
 一个对象表示音频单元的参数树中的节点。节点是一个或一个类的实例。
 AUParameterNode
 AUParameter
 AUParameterGroup

 AUParameterTree
 一个对象是一个顶级群节点，表示所有的音频单元的参数。音频单元的参数被组织成一个包含组和参数的树（组可以嵌套）。
 AUParameterTree

 提供的主要的服务
 Audio Converter Services  音频转换服务
 Audio File Services       音频文件服务
 Audio File Stream Services     音频流服务
 Audio Format Services          音频格式服务
 Audio Queue Services           音频队列服务
 Audio Session Services         音频会话服务
 Audio Toolbox Debugging        音频调试服务
 Audio Unit Processing Graph Services   音频单元处理服务
 Extended Audio File Services           扩展的音频文件服务
 System Sound Services                   系统声音服务
 AudioToolbox Structures                音频工具箱结构
 AudioToolbox Enumerations              音频工具箱枚举
 AudioToolbox Constants                 音频工具箱功能
 AudioToolbox Functions                 音频工具箱数据类型

 #include <AudioToolbox/AUComponent.h>
 #include <AudioToolbox/AUGraph.h>
 #include <AudioToolbox/AudioComponent.h>
 #include <AudioToolbox/AudioConverter.h>
 #include <AudioToolbox/AudioFile.h>
 #include <AudioToolbox/AudioFileStream.h>
 #include <AudioToolbox/AudioFormat.h>
 #include <AudioToolbox/AudioOutputUnit.h>
 #include <AudioToolbox/AudioQueue.h>
 #include <AudioToolbox/AudioServices.h>
 #include <AudioToolbox/AudioUnitParameters.h>
 #include <AudioToolbox/AudioUnitProperties.h>
 #include <AudioToolbox/CAFFile.h>
 #include <AudioToolbox/ExtendedAudioFile.h>
 #include <AudioToolbox/MusicDevice.h>
 #include <AudioToolbox/MusicPlayer.h>
 */






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
