//
//  NickMJRefreshConst.h
//  MJRefresh
//
//  Created by mj on 14-1-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//
#import <UIKit/UIKit.h>

#ifdef DEBUG
#define NickMJLog(...) NSLog(__VA_ARGS__)
#else
#define NickMJLog(...)
#endif

// objc_msgSend
#define msgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define msgTarget(target) (__bridge void *)(target)

#define NickMJColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 文字颜色
#define NickMJRefreshLabelTextColor NickMJColor(150, 150, 150)

extern const CGFloat NickMJRefreshViewHeight;
extern const CGFloat NickMJRefreshFastAnimationDuration;
extern const CGFloat NickMJRefreshSlowAnimationDuration;

extern NSString *const NickMJRefreshBundleName;
#define NickMJRefreshSrcName(file) [NickMJRefreshBundleName stringByAppendingPathComponent:file]

extern NSString *const NickMJRefreshFooterPullToRefresh;
extern NSString *const NickMJRefreshFooterReleaseToRefresh;
extern NSString *const NickMJRefreshFooterRefreshing;

extern NSString *const NickMJRefreshHeaderPullToRefresh;
extern NSString *const NickMJRefreshHeaderReleaseToRefresh;
extern NSString *const NickMJRefreshHeaderRefreshing;
extern NSString *const NickMJRefreshHeaderTimeKey;

extern NSString *const NickMJRefreshContentOffset;
extern NSString *const NickMJRefreshContentSize;
