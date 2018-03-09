//
//  CheckStatus.h
//  AudioToolboxTest
//
//  Created by Apple on 2018/3/8.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>


#define checkStatus(status,tips) [CheckStatus checkStatus:status WithTips:tips]

@interface CheckStatus : NSObject

/*   检查 出错  返回Yes      */
+ (BOOL)checkStatus:(OSStatus)status WithTips:(NSString *)tips;

@end
