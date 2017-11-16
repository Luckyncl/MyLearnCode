//
//  ViewController.m
//  Block(Weak-Strong-Dance)
//
//  Created by Apple on 2017/11/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "BlockDemo.h"
#import "DemoController.h"
@interface ViewController ()

@property (nonatomic, copy) void(^myBlock)(void);

@property (nonatomic, strong) BlockDemo *myBlockDemo;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

//    根据Block在内存中的位置分为三种类型NSGlobalBlock，NSStackBlock, NSMallocBlock。
//
//    NSGlobalBlock：类似函数，位于text段；
//    NSStackBlock：位于栈内存，函数返回后Block将无效；
//    NSMallocBlock：位于堆内存。


    


    //  block 正常情况下是没有问题的 block对内部的变量默认是强引用的
//    BlockDemo *demo1 = [[BlockDemo alloc] init];
//    self.myBlock  = ^{
//        [demo1 demoLog];
//    };
//    self.myBlock();


//    BlockDemo *demo2 = [[BlockDemo alloc] init];
//
////    __weak BlockDemo *weakDemo = demo2;  // 添加了__weak 以后 所修饰的对象使用完成后，引用计数会减一
//
//    __weak typeof(demo2) weakDemo = demo2;
//
//        __weak typeof(self) weakSelf = self;
//    self.myBlock  = ^{
////        __strong typeof(weakDemo) strongDemo = weakDemo;
//
////        __strong BlockDemo *strongDemo = weakDemo;
////        [strongDemo demoLog];
//
//
//        typeof(weakSelf) strongSelf = weakSelf;
//        NSLog(@"Self is %@", strongSelf);
//    };
//
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.myBlock();
//    });






}






- (IBAction)goToDemoVC:(UIButton *)sender {

    DemoController *demoVc = [[DemoController alloc] init];
    [self.navigationController pushViewController:demoVc animated:YES];
}

- (void)demoLog
{
    NSLog(@"[\n   ======   demoLog  \n]");
}



/*
  1、删掉项目中多余的类文件（完成）
  2、加载网页控制器统一设置网络状态指示（完成）
  3、导航栏右侧按钮（完成）
  4、会员搜索添加手机搜索提示文字（完成）
  5、作品评论详情列表Bug（完成）
  6、购买VIP添加日购买（完成）

 */


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
