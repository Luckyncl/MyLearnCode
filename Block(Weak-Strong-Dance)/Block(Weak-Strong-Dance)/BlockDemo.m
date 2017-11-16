//
//  BlockDemo.m
//  Block(Weak-Strong-Dance)
//
//  Created by Apple on 2017/11/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "BlockDemo.h"

@implementation BlockDemo

- (void)demoLog
{
    NSLog(@"[\n   ======   demoLog  self == %@ \n]",self);
}


- (void)dealloc
{
    NSLog(@"[\n  销毁了 class == %@  \n]",[self class]);
}
@end
