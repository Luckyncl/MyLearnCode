//
//  ViewController.m
//  RunLoopDemo
//
//  Created by Apple on 2017/11/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ViewController.h"
#import <CoreFoundation/CoreFoundation.h>

#import "RunLoopTool.h"
@interface ViewController ()
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) RunLoopTool *tool;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.




}



- (IBAction)click:(UIButton *)sender {

//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1f repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"      。。。。定时器开始了。。。     ");
//    }];
//
//    self.timer = timer;
//
//    [self.timer fire];

    //    NSDefaultRunLoopMode;
    //    UITrackingRunLoopMode;
    //    NSRunLoopCommonModes;

//
//    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:100.f]];
//
//    NSLog(@"[\n=====-- %@ ---========\n]",[NSRunLoop currentRunLoop]);

      // 和 while 循环  结合 构成了一个消息循环泵
    // 这样的好处是什么？   可以紧凑代码  eg： 比如某个实例对象，有一个方法去处理一个耗时的操作，这个方法是一个异步的，需求是必须找个方法调用完以后，才能调用别的代码一般的方法就是使用GCD的栅栏函数，或者是在异步方法的回调里面调用别的方法，现在这里使用runloop来处理runloop以后就不需要了

        // ** 注意这里 虽然while内加了runloop 造成了while循环有了等待时间
    //   [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:100.f]]
    // 这个函数是有返回值的，当有事件处理，和到达时间以后，while循环才继续进行

    while (1) {
        BOOL isSucces =  [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:100.f]];
        //        NSLog(@"[\nlllllllllll ====%ld \n]",isSucces);
        NSLog(@"[\n=====-- %@ ---========\n]",[NSRunLoop currentRunLoop]);
    }
//

//    RunLoopTool *tool = [[RunLoopTool alloc] init];
//    self.tool = tool;
//
//    __weak __block typeof(tool) weakTool = tool;
//
//    __block BOOL isDone = NO;
//    [weakTool domeLogCompletion:^{
//        isDone = YES;
//    }];
//
//    //
//    while (!isDone) {
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.f]];
//    }

//    weakTool = nil;
}


/*           */
- (IBAction)button:(UIButton *)sender {


    NSLog(@"[][[][][][[][][][[][][]][][[][][][][");

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
