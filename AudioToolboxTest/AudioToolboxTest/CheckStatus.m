//
//  CheckStatus.m
//  AudioToolboxTest
//
//  Created by Apple on 2018/3/8.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "CheckStatus.h"

@implementation CheckStatus

+ (BOOL)checkStatus:(OSStatus)status WithTips:(NSString *)tips
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
@end
