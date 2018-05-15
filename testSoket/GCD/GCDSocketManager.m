//
//  GCDSocketManager.m
//  testSoket
//
//  Created by Admin on 2018/5/15.
//  Copyright © 2018年 xiaowei. All rights reserved.
//

#import "GCDSocketManager.h"
#define kSocketHost @"127.0.0.1"
#define kSocketPort 8888

@interface GCDSocketManager()<GCDAsyncSocketDelegate>

//socket
@property (nonatomic,strong) GCDAsyncSocket *socket;
//心跳定时器
@property (nonatomic,strong) NSTimer        *heartTimer;

@end

@implementation GCDSocketManager

//单例
+ (GCDSocketManager *)shareSocketManager{
    static GCDSocketManager *manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[GCDSocketManager alloc]init];
    });
    return manager;
};

//链接
- (void)connectToServer{
    if (!self.usercutOffSocket&&[self.socket isDisconnected]) {
        NSError *error=nil;
        [self.socket connectToHost:kSocketHost onPort:kSocketPort error:&error];
        if (error) {
            NSLog(@"SocketConnectError:%@",error);
        }
    }
};

//断开
- (void)cutOffSocket{
    self.usercutOffSocket=YES;
    self.reconnectCount=0;
    [self.heartTimer invalidate];
    self.heartTimer=nil;
    [self.socket disconnect];
    self.socket.delegate = nil;
    self.socket = nil;
};

#pragma mark GCDAsyncSocketDelegate
#pragma mark connectSucess
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"链接成功");
    self.reconnectCount=0;
    //发送自己需要的初始化数据
    [self sentMessage:@"我是第一次链接\n"];
    //读取数据
    [self.socket readDataWithTimeout:-1 tag:200];
    //发送心跳包
    [self.heartTimer fire];
}

//读取服务器返回数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    [self.socket readDataWithTimeout:-1 tag:200];
    //在这里进行校验操作,情况分为成功和失败两种,成功的操作一般都是解析数据并使用block返回
    self.serviceBackBlock?self.serviceBackBlock(data):nil;
}

#pragma mark connectFailed
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"链接失败");
    //关闭心跳包
    [self.heartTimer invalidate];
    self.heartTimer=nil;
    //根据情况进行重连
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *currentStatus=[userDefaults valueForKey:kAppCurrentStatus];
    //程序在前台时重新链接
    if ([currentStatus isEqualToString:kAppInForeGround]) {
        //重连次数
        self.reconnectCount++;
        __weak typeof(self) WeakSelf=self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.reconnectCount * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [WeakSelf connectToServer];
        });
    }
}

#pragma mark发送消息
- (void)sentMessage:(id)sendObj{
    if ([self.socket isConnected]) {
        NSData *data = [sendObj dataUsingEncoding:NSUTF8StringEncoding];
        [self.socket writeData:data withTimeout:-1 tag:1];
    }else{
        [self connectToServer];
    }
};

//发送心跳消息
- (void)sendHeartMessage{
    [self sentMessage:@"heart message\n"];
}

#pragma mark lazyLoad
- (GCDAsyncSocket *)socket{
    if (!_socket) {
        _socket=[[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _socket;
}

- (NSTimer *)heartTimer{
    if (!_heartTimer) {
        _heartTimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(sendHeartMessage) userInfo:nil repeats:YES];
    }
    return _heartTimer;
}

@end
