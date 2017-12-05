//
//  GCDSocketmanager.h
//  Double
//
//  Created by 何崇 on 2017/12/1.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>

@interface GCDSocketmanager : NSObject

@property(nonatomic,strong) GCDAsyncSocket *socket;

//单例
+ (instancetype)shareSocketManager;

//连接
- (void)connectToServer;

//断开
- (void)cutOffSocket;

@end
