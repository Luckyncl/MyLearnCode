//
//  RunLoopTool.m
//  RunLoopDemo
//
//  Created by Apple on 2017/11/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RunLoopTool.h"

@implementation RunLoopTool

- (void)domeLogCompletion:(void(^)(void))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"  开始打印了  。。    %@",[NSThread currentThread]);

        for (NSInteger i = 0; i< 1000; i++) {
            NSLog(@"[\n   第%ldge  \n]",i);
        }

        completion();
    });
}



@end
