//
//  GCDSocketmanager.m
//  Double
//
//  Created by 何崇 on 2017/12/1.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import "GCDSocketmanager.h"

#define SocketHost @"需要长链接地址" //长链接地址
#define SocketPort 8888    //长链接端口

@interface GCDSocketmanager()<GCDAsyncSocketDelegate>

//握手次数
@property(nonatomic,assign) NSInteger pushCount;

//断开重连时间
@property(nonatomic,strong) NSTimer *timer;

//重连接次数
@property(nonatomic,assign) NSInteger reconnectCount;

@end

@implementation GCDSocketmanager

+ (instancetype)shareSocketManager{
    static GCDSocketmanager *_instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });

    return _instance;
}


- (instancetype)init{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)connectToServer {
    //初始化握手次数
    self.pushCount = 0;

    //初始化socket
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];

    //连接失败的错误
    NSError *error = nil;

    //开始连接
    [self.socket connectToHost:SocketHost onPort:SocketPort error:&error];

    //如果连接失败 打印错误 看看具体是什么原因造成的
    if (error) {
        NSLog(@"connectToServer socketConnectError:%@",error);
    }
}

#pragma mark 如果连接成功
//连接成功的回调
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(nonnull NSString *)host port:(uint16_t)port{
    //如果sockt连接成功，可以向服务器发送一些服务需要的数据
    [self sendDataToServer];

}

//连接成功后向服务器发送数据
- (void)sendDataToServer{


#warning 以下两句代码很有必要，必须写的，少写一句发送数据或读取数据都不会成功
    //发送数据
    [self.socket writeData:@"" withTimeout:-1 tag:1];

    //读取数据
    [self.socket readDataWithTimeout:-1 tag:200];
}


//连接成功向服务器发送数据后，服务器会有反应
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    //这句代码也必须写
    [self.socket readDataWithTimeout:-1 tag:200];

    //服务器推送次数
    self.pushCount++;

    //此处进行校验,校验格式看服务器那边给的什么格式

}

#pragma mark 连接失败
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"socket连接失败");

    //握手次数重置，因为连接失败是要进行重新连接的,下次使用握手次数进行校验时必须重新开始校验
    self.pushCount = 0;

    //会在程序进入前台／后台时，分别记录当前程序处于什么状态
    //如果处于前台，连接失败就进行重连
    //如果处于后台，连接失败就不再重连
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSString *currentStatu = [userDefaults valueForKey:@"Statu"];

    //程序在前台才进行重连
    if ([currentStatu isEqualToString:@"foreground"]) {
        //重连次数
        self.reconnectCount++;
        //如果连接失败 累加1秒后重新连接 减少服务器压力
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0*self.reconnectCount target:self selector:@selector(reconnectServer) userInfo:nil repeats:NO];
        self.timer = timer;
    }
}

//如果连接失败 5秒后重新连接
- (void)reconnectServer{
    self.pushCount = 0;
    self.reconnectCount = 0;
    NSError *error = nil;
    [self.socket connectToHost:SocketHost onPort:SocketPort error:&error];

    if (error) {
        NSLog(@"reconnectServer socketConnectError:%@",error);
    }
}

#pragma mark 断开连接
- (void)cutOffSocket{
    NSLog(@"cutOffSocket 断开连接");
    self.pushCount = 0;
    self.reconnectCount = 0;

    [self.timer invalidate];
    self.timer = nil;
    [self.socket disconnect];
}

















@end
