//
//  ViewController.m
//  testSoket
//
//  Created by Admin on 2018/5/14.
//  Copyright © 2018年 xiaowei. All rights reserved.
//

#import "ViewController.h"
#import "GCDSocketManager.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTestUI];
    [[GCDSocketManager shareSocketManager] connectToServer];
    [GCDSocketManager shareSocketManager].userConnected=YES;
    [[GCDSocketManager shareSocketManager] setServiceBackBlock:^(id obj) {
        NSLog(@"收到服务器返回的数据=%@",[obj dataUsingEncoding:NSUTF8StringEncoding]);
    }];
}

- (void)initTestUI{
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100,100, 50)];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"发送数据" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(110, 100, 100, 50)];
    btn2.backgroundColor = [UIColor orangeColor];
    [btn2 setTitle:@"断开连接" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(disconnectSocket) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

//发送数据
- (void)sendMessage{
    [[GCDSocketManager shareSocketManager] sentMessage:@"客户端发送了一条数据"];
}

//断开连接
- (void)disconnectSocket{
    [[GCDSocketManager shareSocketManager] cutOffSocket];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
