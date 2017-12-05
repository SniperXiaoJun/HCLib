//
//  NickMJRefreshHeaderView.h
//  MJRefresh
//
//  Created by mj on 13-2-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  下拉刷新

#import "NickMJRefreshBaseView.h"

@interface NickMJRefreshHeaderView : NickMJRefreshBaseView

@property (nonatomic, copy) NSString *dateKey;
+ (instancetype)header;

@end
