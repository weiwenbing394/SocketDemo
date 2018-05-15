//
//  GCDSocketManager.h
//  testSoket
//
//  Created by Admin on 2018/5/15.
//  Copyright © 2018年 xiaowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#define kAppCurrentStatus    @"appCurrentStatus"
#define kAppInForeGround     @"appInForeGround"
#define kAppNotInForeGround  @"appNotInForeGround"

@interface GCDSocketManager : NSObject

//单例
+ (GCDSocketManager *)shareSocketManager;
//链接
- (void)connectToServer;
//断开
- (void)cutOffSocket;
//发送消息
- (void)sentMessage:(id)msg;
//接收服务器返回数据
@property (nonatomic,strong) void (^serviceBackBlock) (id obj);
//重连次数
@property (nonatomic,assign) NSInteger  reconnectCount;
//是否已经手动连接过
@property (nonatomic,assign) BOOL userConnected;
//是否是手动断开的链接
@property (nonatomic,assign) BOOL usercutOffSocket;

@end
