//
//  AudioFileServicesDemo.m
//  AudioToolboxTest
//
//  Created by luckyncl on 2018/2/4.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "AudioFileServicesDemo.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NSString+encode.h"
@interface AudioFileServicesDemo ()
{
    AudioStreamBasicDescription dataFormat;
    AudioFileID audioFileID;
}
@end

@implementation AudioFileServicesDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    //  测试音频.m4a      1538048 有效帧数  一共所有的帧数1541120
    //   NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"441" ofType:@"mp3"];
    
    NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"测试音频" ofType:@"aac"];
    NSURL *mp3Url = [NSURL URLWithString:[mp3Path stringByURLEncode]];
    
    NSData *mp3Data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:mp3Path]];
    
    
    CFURLRef mp3UrlRef = (__bridge CFURLRef)mp3Url;
    
    //  AudioFileOpenWithCallbacks(<#void * _Nonnull inClientData#>, <#AudioFile_ReadProc  _Nonnull inReadFunc#>, <#AudioFile_WriteProc  _Nullable inWriteFunc#>, <#AudioFile_GetSizeProc  _Nonnull inGetSizeFunc#>, <#AudioFile_SetSizeProc  _Nullable inSetSizeFunc#>, <#AudioFileTypeID inFileTypeHint#>, <#AudioFileID  _Nullable * _Nonnull outAudioFile#>)
    // AudioFileID相当于文件句柄
    OSStatus status ;
    //    打开文件
    status = AudioFileOpenURL(mp3UrlRef, kAudioFileReadPermission, kAudioFileMP3Type, &audioFileID);
    
    if ([self checkStatus:status WithTips:@"打开文件错误"]) {
        return;
    }
    
    /*
     AudioFilePropertyID 音频属性ID
     kAudioFilePropertyFileFormat
     音频数据文件的格式。
     
     kAudioFilePropertyDataFormat
     包含音频数据格式的音频流基本描述。
     
     kAudioFilePropertyFormatList
     为了支持AAC SBR这样的编码数据流可以被解码为多个目的格式的格式，这个属性的值是这些格式的一个音频格式列表项值（声明为）。通常情况下，这是一个音频格式列表项目，在该属性中具有相同的音频流基本描述。AudioFormat.hkAudioFilePropertyDataFormat
     
     kAudioFilePropertyIsOptimized
     指示指定的音频文件是否已被优化，即准备开始向其写入声音数据。值0表示文件需要优化。值1指示文件当前被优化。
     
     kAudioFilePropertyMagicCookieData
     指向由调用者设置的内存的指针。某些文件类型要求在将数据包写入音频文件之前提供魔术cookie。在您致电之前或如果存在魔法cookie，请设置此属性。
     AudioFileWriteBytes
     AudioFileWritePackets
     
     kAudioFilePropertyAudioDataByteCount
     表示指定文件中音频数据的字节数。
     
     kAudioFilePropertyAudioDataPacketCount
     表示指定文件中的音频数据包的数量。
     
     kAudioFilePropertyMaximumPacketSize
     指定指定文件中数据的最大数据包大小。
     
     kAudioFilePropertyDataOffset
     指示指定音频数据文件中的字节偏移量。
     
     kAudioFilePropertyChannelLayout
     音频通道布局结构。
     
     kAudioFilePropertyDeferSizeUpdates
     默认值（0）总是更新标题。如果设置为1，则每次写入数据时都不执行更新标题中的文件大小。相反，更新被推迟到文件被读取，优化或关闭。这个过程更有效率，但并不安全。如果应用程序在大小更新之前崩溃，则文件可能不可读。
     
     kAudioFilePropertyDataFormatName
     这个常量在macOS 10.5及更高版本中已被弃用。不使用。相反，使用（在头文件中声明）。kAudioFormatProperty_FormatNameAudioFormat.h
     
     kAudioFilePropertyMarkerList
     表示文件中定义的音频文件标记的对象列表。
     CFStringRef
     
     kAudioFilePropertyRegionList
     文件中定义的音频文件区域值的列表。
     
     kAudioFilePropertyPacketToFrame
     通过填充字段的音频帧数据包转换结构并返回字段。该字段被忽略。 mPacketmFramemFrameOffsetInPacket
     
     kAudioFilePropertyFrameToPacket
     通过与所述的音频帧分组转换结构填写字段，并返回和字段。mFramemPacketmFrameOffsetInPacket
     
     kAudioFilePropertyPacketToByte
     通过音频字节数据包转换结构填写字段并返回字段。该字段被忽略。如果该字段中的值是一个估计值，那么该字段将被设置在该字段中。mPacketmBytemByteOffsetInPacketmBytekBytePacketTranslationFlag_IsEstimatemFlags
     
     kAudioFilePropertyByteToPacket
     通过与音频字节的数据包转换结构填写现场并返回和领域。如果该字段中的值是一个估计值，那么该字段将被设置在该字段中。mBytemPacketmByteOffsetInPacketmBytekBytePacketTranslationFlag_IsEstimatemFlags
     
     kAudioFilePropertyChunkIDs
     文件中每种块的四字符代码的数组。
     
     kAudioFilePropertyInfoDictionary
     CF字典包含有关文件中数据的信息。
     
     kAudioFilePropertyPacketTableInfo
     获取或设置支持文件类型的音频文件包表信息结构。当设置的结构中，的值的总和，并且字段必须是相同的帧中的所有数据包的总数目。如果不是，则返回a。为了确保这个结果，得到属性的值，并确保你设置的三个值的总和与你得到的三个值的总和相同。 mNumberValidFramesmPrimingFramesmRemainderFramesparamErr
     
     kAudioFilePropertyPacketSizeUpperBound
     文件中的理论最大包大小。而不实际扫描整个文件来找到最大的包，因为可以和发生该值是。kAudioFilePropertyMaximumPacketSize
     
     kAudioFilePropertyReserveDuration
     预计要写入的数据的持续时间（秒）。在写入任何数据之前设置此属性，以保留数据包表的文件头中的空间以及在音频数据之前出现的其他信息。否则，数据包表可能会写在文件末尾，从而阻止文件流式传输。
     
     kAudioFilePropertyEstimatedDuration
     估计持续时间，以秒为单位 如果可以在不扫描整个文件的情况下计算该持续时间，或者已经扫描了所有的音频数据包，则该值准确地反映了音频数据的持续时间。
     
     kAudioFilePropertyBitRate
     某些文件类型的实际比特率（文件中的音频数据比特数除以文件的持续时间）以及其他文件类型的标称比特率（编码器设置为的比特率）。
     
     kAudioFilePropertyID3Tag
     void*指向您的应用程序设置的内存的值，以包含完全格式化的ID3标记。
     
     kAudioFilePropertySourceBitDepth
     对于压缩数据，此属性的值是源的位深度，未压缩的音频流的SInt32值（如果已知）。如果未压缩的源文件是浮点格式，则位深度表示为负数。例如，的属性值-32被用于float和的属性值-64表示double。
     
     kAudioFilePropertyAlbumArtwork
     专辑名
     CFDataRef
     
     kAudioFilePropertyAudioTrackCount
     kAudioFilePropertyUseAudioTrack
     
     */
    
    
    
    
    
    //    AudioFilePropertyID
    
    AudioFileTypeID audioFileType = 0;
    UInt32 size = 0;
    UInt32 isWritable;
    
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
    
#pragma mark-:  获取音频包列表信息的时候对于aac,和 mp3 文件会获取失败  猜测原因： 由于aac和mp3文件是一节节的，不像m4a文件一样只是一个容器，所以。。。
    
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
    
    
    //     写音频数据
    //     AudioFileWritePackets(<#AudioFileID  _Nonnull inAudioFile#>, <#Boolean inUseCache#>, <#UInt32 inNumBytes#>, <#const AudioStreamPacketDescription * _Nullable inPacketDescriptions#>, <#SInt64 inStartingPacket#>, <#UInt32 * _Nonnull ioNumPackets#>, <#const void * _Nonnull inBuffer#>)
    
    
    
    //    关闭文件
    AudioFileClose(audioFileID);
    NSLog(@"操作成功");

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)checkStatus:(OSStatus)status WithTips:(NSString *)tips
{
    //    ostatus的网站
    //    https://www.osstatus.com/
    if (status != noErr) {
        
        NSLog(@"[\n产生了错误===osstatus ==%d \n %@]",status,tips);
        return YES;
    }else{
        return NO;
    }
}




@end
