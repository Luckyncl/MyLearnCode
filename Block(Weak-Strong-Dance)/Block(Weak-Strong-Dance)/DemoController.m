//
//  DemoController.m
//  Block(Weak-Strong-Dance)
//
//  Created by Apple on 2017/11/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "DemoController.h"
#import "BlockDemo.h"
@interface DemoController ()
@property (nonatomic, copy) void(^myBlock)(void);

@property (nonatomic, strong) BlockDemo *myBlockDemo;


@end

@implementation DemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

     // block 正常情况下是没有问题的
        BlockDemo *demo1 = [[BlockDemo alloc] init];

        

        self.myBlock  = ^{
            [demo1 demoLog];
        };
        self.myBlock();


    BlockDemo *demo2 = [[BlockDemo alloc] init];

    __weak typeof(demo2) weakDemo = demo2;  // 添加了__weak 以后 所修饰的对象使用完成后，会置nil

    __weak typeof(self) weakSelf = self;
    self.myBlock  = ^{

        [weakDemo demoLog];

        NSLog(@"Self is %@", weakSelf);
    };



    // gcd 对内部的代码 进行了copy  所以如果 gcd 中的代码  没有完成的话 控制器是无法销毁的
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{


        self.myBlock();
    });





}


- (void)dealloc {
    NSLog(@"[\n   控制器销毁了    \n] ");
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
