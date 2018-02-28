//
//  ExtendedAudioFileServicesDemo.m
//  AudioToolboxTest
//
//  Created by luckyncl on 2018/2/4.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ExtendedAudioFileServicesDemo.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NSString+encode.h"
@interface ExtendedAudioFileServicesDemo ()
{
    AudioStreamBasicDescription dataFormat;
    AudioFileID audioFileID;
}
@end

@implementation ExtendedAudioFileServicesDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    /*
     ExtendedAudioFile提供高级音频文件访问，建立
     在AudioFile和AudioConverter API集之上。 它提供了一个单一的
     统一接口来读写编码和未编码的文件。  它比audiofileServices会更加常用一些 并且更加的方便
     */


    //  测试音频.m4a      1538048 有效帧数  一共所有的帧数1541120
    //   NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"441" ofType:@"mp3"];

    NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"测试音频" ofType:@"aac"];
    NSURL *mp3Url = [NSURL URLWithString:[mp3Path stringByURLEncode]];
    //    NSURL *mp3Url = nil;
    //   mp3Url = [NSURL fileURLWithPath:[@"/Users/Apple/Desktop/测试音.m4a" stringByURLEncode]];



    NSData *mp3Data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:mp3Path]];

    NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                                 objectAtIndex:0];
    NSString *filePath = [documentsFolder stringByAppendingPathComponent:@"Recording.aac"];

    BOOL isSuccess = [mp3Data writeToFile:filePath atomically:YES];

    if (!isSuccess) {
        NSLog(@"不能写入");
    }

    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"文件不存在");
        return;
    }



    CFURLRef mp3UrlRef = (__bridge CFURLRef)[NSURL URLWithString:filePath];


#pragma mark- 创建文件


    //如果要创建的文件是压缩格式，则可以将inStreamDesc参数中的采样率设置为0.在所有情况下，扩展文件对象的编码转换器可能会以不同于采样率的采样率生成音频。 该文件将以编码器产生的音频格式创建。

    //        创建或打开文件的标志。 如果设置了kAudioFileFlags_EraseFile标志，则擦除现有的文件。 如果该标志没有设置，那么如果URL指向一个已经存在的文件，则该函数失败
    //    ExtAudioFileCreateWithURL(<#CFURLRef  _Nonnull inURL#>, <#AudioFileTypeID inFileType#>, <#const AudioStreamBasicDescription * _Nonnull inStreamDesc#>, <#const AudioChannelLayout * _Nullable inChannelLayout#>, <#UInt32 inFlags#>, <#ExtAudioFileRef  _Nullable * _Nonnull outExtAudioFile#>)


#pragma mark- 打开文件
    ExtAudioFileRef audioFileRef;
    OSStatus status ;
    // 注意这里的打开只能去读数据  ，而不是去写的
    //    status =  ExtAudioFileOpenURL(mp3UrlRef, &audioFileRef);
    //
    //    if ([self checkStatus:status WithTips:@"打开文件错误"]) {
    //        return;
    //    }


#pragma mark- 将audioFileId 转换成 扩展音频文件对象（音频上下文）
    status = AudioFileOpenURL(mp3UrlRef, kAudioFileReadWritePermission, 0, &audioFileID);
    if ([self checkStatus:status WithTips:@"AudioFileOpenURL 打开文件失败"]) {
        return;
    }





    ////     注意 如果使用了这个方法，你必须 在 关闭 audioFileRef 以后 再关闭 audioFileID
    status = ExtAudioFileWrapAudioFileID(audioFileID, YES, &audioFileRef);
    //
    if ([self checkStatus:status WithTips:@"转换失败"]) {
        return;
    }




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

    size = sizeof(dataFormat);


    status = ExtAudioFileGetProperty(audioFileRef, kExtAudioFileProperty_FileDataFormat, &size, &dataFormat);

    if ([self checkStatus:status WithTips:@"获取文件数据格式失败！"]) {
        return;
    }



    //    AudioStreamBasicDescription audioDescription ;
    //    audioDescription.mFormatFlags = kLinearPCMFormatFlagIsFloat | kLinearPCMFormatFlagIsNonInterleaved | kAudioFormatFlagsNativeEndian;
    //    audioDescription.mFormatID = kAudioFormatLinearPCM;
    //    audioDescription.mBitsPerChannel = sizeof (float) * 8;
    //    audioDescription.mChannelsPerFrame = dataFormat.mChannelsPerFrame;
    //    audioDescription.mBytesPerPacket =
    //    audioDescription.mBytesPerFrame = dataFormat.mChannelsPerFrame * (audioDescription.mBitsPerChannel/8);
    //    audioDescription.mFramesPerPacket = 1;
    //    audioDescription.mSampleRate = dataFormat.mSampleRate;
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





#pragma mark- 读写音频数据属性

    /*
     如果扩展音频文件对象具有应用程序数据格式，则对象的转换器将文件数据转换为应用程序格式。

     这个函数只能在一个线程上运行。 如果您希望应用程序读取多个线程上的音频文件，请改为使用音频文件服务。
     */


    UInt32 lengthOfFrames = 0;
    UInt64 lengthOfFramesTemp;
#warning 注意： 虽然 ExtAudioFileGetProperty(ExtAudioFileRef inExtAudioFile, ExtAudioFilePropertyID  inPropertyID,UInt32 * ioPropertyDataSize,void *outPropertyData)
    //      虽然这里的ioProperDataSize 指明的是32位的但是对于  ExtaudioFileGetProperty 针对 kExtAudioFileProperty_FileLengthFrames 这个属性的时候，需要用UInt64的来去使用io数据


    size = sizeof(lengthOfFramesTemp);


    status = ExtAudioFileGetProperty(audioFileRef, kExtAudioFileProperty_FileLengthFrames,&size , &lengthOfFramesTemp);

    lengthOfFrames = (UInt32)lengthOfFramesTemp;

    if ([self checkStatus:status WithTips:@"获取音频帧数出错！"]) {
        return;
    }


    size = sizeof(dataFormat);
    status = ExtAudioFileGetProperty(audioFileRef, kExtAudioFileProperty_FileDataFormat, &size, &dataFormat);

    //    对于 kaudioFormatFlagIsNonInterleaved
    /*
     通常，当使用ASBD时，这些字段描述完整的布局
                         本说明书所表示的缓冲区中的样本数据 -
                         通常那些缓冲区由一个AudioBuffer表示
                         包含在AudioBufferList中。

                         但是，当ASBD具有kAudioFormatFlagIsNonInterleaved标志时，
                         AudioBufferList具有不同的结构和语义。在这种情况下，ASBD
                         字段将描述包含在其中的一个AudioBuffers的格式
                         该列表，并且列表中的每个AudioBuffer被确定为具有单个（单声道）
                         音频数据通道。然后，ASBD的mChannelsPerFrame将指示
                         AudioBufferList中包含的AudioBuffers总数 -
                         每个缓冲区包含一个通道。这主要用于
                         此列表的AudioUnit（和AudioConverter）表示 - 并且不会被发现
                         在这个结构的AudioHardware使用中。
     */
    /*
     创建音频缓冲区列表
     */
    int numberOfBuffers = dataFormat.mFormatFlags & kAudioFormatFlagIsNonInterleaved ? dataFormat.mChannelsPerFrame : 1;
    AudioBufferList *audioBufferList = malloc(sizeof(audioBufferList) + sizeof(AudioBuffer)* (numberOfBuffers - 1));

    //
    audioBufferList->mNumberBuffers = numberOfBuffers;
    /*
     注意这里如果穿件的缓冲区比较大的话 这里会有一些问题了
     */
    lengthOfFrames = 0;



    status =  ExtAudioFileRead(audioFileRef, &lengthOfFrames, audioBufferList);



    if ([self checkStatus:status WithTips:@"读取音频数据出错"]) {
        return;
    }



    size = sizeof(dataFormat);
    //    （对于一些属性值是可变的时候，必须先调用AudioFileGetPropertyInfo 获取属性所占大小以后在调用AudioFileGetProperty）
    status =   AudioFileGetProperty(audioFileID, kAudioFilePropertyDataFormat, &size, &dataFormat);


    //    NSLog(@"size == %d  isWritable ==== %d   fromat == %d",audioFileType,isWritable,audioStreamBasicDescription);

    if ([self checkStatus:status WithTips:@"获取属性错误"]) {
        return;
    }






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
