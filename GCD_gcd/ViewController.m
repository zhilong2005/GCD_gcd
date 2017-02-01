//
//  ViewController.m
//  GCD_gcd
//
//  Created by zhuzhilong on 17/2/1.
//  Copyright © 2017年 zhuzhilong. All rights reserved.
//

#import "ViewController.h"
#import "GCDSingle.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *gcdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gcdButton.frame = CGRectMake(100, 100, 100, 44);
    gcdButton.backgroundColor = [UIColor redColor];
    [gcdButton setTitle:@"GCD" forState:UIControlStateNormal];
    [gcdButton addTarget:self action:@selector(clcikGCD) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gcdButton];
    
    UIButton *gcdButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    gcdButton1.frame = CGRectMake(210, 100, 100, 44);
    gcdButton1.backgroundColor = [UIColor redColor];
    [gcdButton1 setTitle:@"GCD优先级" forState:UIControlStateNormal];
    [gcdButton1 addTarget:self action:@selector(clcikGCD1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gcdButton1];
    
    
    UIButton *gcdButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    gcdButton2.frame = CGRectMake(100, 210, 100, 44);
    gcdButton2.backgroundColor = [UIColor redColor];
    [gcdButton2 setTitle:@"串行队列" forState:UIControlStateNormal];
    [gcdButton2 addTarget:self action:@selector(clcikGCD2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gcdButton2];
    
    UIButton *gcdButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    gcdButton3.frame = CGRectMake(210, 210, 100, 44);
    gcdButton3.backgroundColor = [UIColor redColor];
    [gcdButton3 setTitle:@"notify" forState:UIControlStateNormal];
    [gcdButton3 addTarget:self action:@selector(clcikGCD3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gcdButton3];

    
    UIButton *gcdButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    gcdButton4.frame = CGRectMake(100, 310, 100, 44);
    gcdButton4.backgroundColor = [UIColor redColor];
    [gcdButton4 setTitle:@"异步notify" forState:UIControlStateNormal];
    [gcdButton4 addTarget:self action:@selector(clcikGCD4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gcdButton4];
    
    
    UIButton *gcdButton5 = [UIButton buttonWithType:UIButtonTypeCustom];
    gcdButton5.frame = CGRectMake(100, 310, 100, 44);
    gcdButton5.backgroundColor = [UIColor redColor];
    [gcdButton5 setTitle:@"用GCD创建单例" forState:UIControlStateNormal];
    [gcdButton5 setFont:[UIFont systemFontOfSize:12]];
    [gcdButton5 addTarget:self action:@selector(clcikGCD5) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gcdButton5];
    
    
    UIButton *gcdButton6 = [UIButton buttonWithType:UIButtonTypeCustom];
    gcdButton6.frame = CGRectMake(210, 310, 100, 44);
    gcdButton6.backgroundColor = [UIColor redColor];
    [gcdButton6 setTitle:@"GCD延迟调用" forState:UIControlStateNormal];
    [gcdButton6 setFont:[UIFont systemFontOfSize:12]];
    [gcdButton6 addTarget:self action:@selector(clcikGCD6) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gcdButton6];
    

    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)clcikGCD{
    NSLog(@"执行GCD");
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
     //执行耗时任务
     NSLog(@"start task 1");
     [NSThread sleepForTimeInterval:3];
     dispatch_async(dispatch_get_main_queue(), ^{
         //回到主线程刷新  ui
         NSLog(@"刷新UI");
     });
     
 });
}
//设置线程的优先级别,你会发现虽然先执行，但是返回不一定先返回，那么如何保证按顺序执行呢，我们可以采用串行队列执行
-(void)clcikGCD1{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSLog(@"start task 1");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 1");
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"start task 2");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 2");
    });

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"start task 3");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 3");
    });

}
//串行队列 保证线程按顺序执行完,那么他是如何保证按顺序执行呢，其实 他只开辟了一个线程，在一个线程里执行，并非开辟了三个线程
-(void)clcikGCD2{
    dispatch_queue_t queue = dispatch_queue_create("wwww.zhuzhilong.com", NULL);
    dispatch_async(queue, ^{
        NSLog(@"start task 1");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 1");

    });
    
    dispatch_async(queue, ^{
        NSLog(@"start task 2");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 2");
        
    });
    
    
    dispatch_async(queue, ^{
        NSLog(@"start task 3");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 3");
        
    });
    
    }
//等所有任务结束后，通知操作其他工作，比如通知主线程刷新UI,回调回来的数据是在异步线程，并非主线程，所有要回到主线程，我们要主动获取主线程
-(void)clcikGCD3{
     NSLog(@"执行GCD");
    dispatch_queue_t queue = dispatch_queue_create("www.zhizhilong.com", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        NSLog(@"start task 1");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 1");
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"start task 2");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 2");
    });

    
    dispatch_group_async(group, queue, ^{
        NSLog(@"start task 3");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 3");
    });

    dispatch_group_notify(group, queue, ^{
        NSLog(@"All tasks over");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程刷新UI");
        });
    });
}
//保证异步请求全部完成之后，通知主线程刷新UI
-(void)clcikGCD4{

    NSLog(@"执行GCD");
    dispatch_queue_t queue = dispatch_queue_create("www.zhizhilong.com", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
   
    
    dispatch_group_enter(group);
    [self sendRequest1:^{
        NSLog(@"request1 done");
        dispatch_group_leave(group);
        
    }];
    
    dispatch_group_enter(group);
    [self sendRequest2:^{
        NSLog(@"request2 done");
        dispatch_group_leave(group);
    }];

    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"All tasks over");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程刷新UI");
        });
    });

}
//GCD单例只创建一次对象
-(void)clcikGCD5{


    GCDSingle *single = [GCDSingle instance];
    NSLog(@"%@",single);
    
    //同样我们也可以用这个实现方法只掉一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self onlyClickOnece];
    });
}
//延迟执行
-(void)clcikGCD6{
    NSLog(@"---begin---");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"delay excute");
    });
    
}


-(void)onlyClickOnece{
    NSLog(@"方法只掉一次");
}
-(void)sendRequest1:(void(^)())block{

   dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSLog(@"start task 1");
    [NSThread sleepForTimeInterval:2];
    NSLog(@"end task 1");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
});
}

-(void)sendRequest2:(void(^)())block{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"start task 2");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 2");
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block();
            }
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
