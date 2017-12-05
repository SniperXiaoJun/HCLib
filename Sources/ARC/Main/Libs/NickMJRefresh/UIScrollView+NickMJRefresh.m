//
//  UIScrollView+NickMJRefresh.m
//  MJRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIScrollView+NickMJRefresh.h"
#import "NickMJRefreshHeaderView.h"
#import "NickMJRefreshFooterView.h"
#import <objc/runtime.h>

@interface UIScrollView()
@property (weak, nonatomic) NickMJRefreshHeaderView *header;
@property (weak, nonatomic) NickMJRefreshFooterView *footer;
@end


@implementation UIScrollView (NickMJRefresh)

#pragma mark - 运行时相关
static char NickMJRefreshHeaderViewKey;
static char NickMJRefreshFooterViewKey;

- (void)setHeader:(NickMJRefreshHeaderView *)header {
    [self willChangeValueForKey:@"NickMJRefreshHeaderViewKey"];
    objc_setAssociatedObject(self, &NickMJRefreshHeaderViewKey,
                             header,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"NickMJRefreshHeaderViewKey"];
}

- (NickMJRefreshHeaderView *)header {
    return objc_getAssociatedObject(self, &NickMJRefreshHeaderViewKey);
}

- (void)setFooter:(NickMJRefreshFooterView *)footer {
    [self willChangeValueForKey:@"NickMJRefreshFooterViewKey"];
    objc_setAssociatedObject(self, &NickMJRefreshFooterViewKey,
                             footer,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"NickMJRefreshFooterViewKey"];
}

- (NickMJRefreshFooterView *)footer {
    return objc_getAssociatedObject(self, &NickMJRefreshFooterViewKey);
}

#pragma mark - 下拉刷新
/**
 *  添加一个下拉刷新头部控件
 *
 *  @param callback 回调
 */
- (void)addHeaderWithCallback:(void (^)())callback
{
    [self addHeaderWithCallback:callback dateKey:nil];
}

- (void)addHeaderWithCallback:(void (^)())callback dateKey:(NSString*)dateKey
{
    // 1.创建新的header
    if (!self.header) {
        NickMJRefreshHeaderView *header = [NickMJRefreshHeaderView header];
        [self addSubview:header];
        self.header = header;
    }
    
    // 2.设置block回调
    self.header.beginRefreshingCallback = callback;
    
    // 3.设置存储刷新时间的key
    self.header.dateKey = dateKey;
}

/**
 *  添加一个下拉刷新头部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addHeaderWithTarget:(id)target action:(SEL)action
{
    [self addHeaderWithTarget:target action:action dateKey:nil];
}

- (void)addHeaderWithTarget:(id)target action:(SEL)action dateKey:(NSString*)dateKey
{
    // 1.创建新的header
    if (!self.header) {
        NickMJRefreshHeaderView *header = [NickMJRefreshHeaderView header];
        [self addSubview:header];
        self.header = header;
    }
    
    // 2.设置目标和回调方法
    self.header.beginRefreshingTaget = target;
    self.header.beginRefreshingAction = action;
    
    // 3.设置存储刷新时间的key
    self.header.dateKey = dateKey;
}

/**
 *  移除下拉刷新头部控件
 */
- (void)removeHeader
{
    [self.header removeFromSuperview];
    self.header = nil;
}

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headerBeginRefreshing
{
    [self.header beginRefreshing];
}

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headerEndRefreshing
{
    [self.header endRefreshing];
}

/**
 *  下拉刷新头部控件的可见性
 */
- (void)setHeaderHidden:(BOOL)hidden
{
    self.header.hidden = hidden;
}

- (BOOL)isHeaderHidden
{
    return self.header.isHidden;
}

- (BOOL)isHeaderRefreshing
{
    return self.header.isRefreshing;
}

#pragma mark - 上拉刷新
/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param callback 回调
 */
- (void)addFooterWithCallback:(void (^)())callback
{
    // 1.创建新的footer
    if (!self.footer) {
        NickMJRefreshFooterView *footer = [NickMJRefreshFooterView footer];
        [self addSubview:footer];
        self.footer = footer;
    }
    
    // 2.设置block回调
    self.footer.beginRefreshingCallback = callback;
}

/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addFooterWithTarget:(id)target action:(SEL)action
{
    // 1.创建新的footer
    if (!self.footer) {
        NickMJRefreshFooterView *footer = [NickMJRefreshFooterView footer];
        [self addSubview:footer];
        self.footer = footer;
    }
    
    // 2.设置目标和回调方法
    self.footer.beginRefreshingTaget = target;
    self.footer.beginRefreshingAction = action;
}

/**
 *  移除上拉刷新尾部控件
 */
- (void)removeFooter
{
    [self.footer removeFromSuperview];
    self.footer = nil;
}

/**
 *  主动让上拉刷新尾部控件进入刷新状态
 */
- (void)footerBeginRefreshing
{
    [self.footer beginRefreshing];
}

/**
 *  让上拉刷新尾部控件停止刷新状态
 */
- (void)footerEndRefreshing
{
    [self.footer endRefreshing];
}

/**
 *  下拉刷新头部控件的可见性
 */
- (void)setFooterHidden:(BOOL)hidden
{
    self.footer.hidden = hidden;
}

- (BOOL)isFooterHidden
{
    return self.footer.isHidden;
}

- (BOOL)isFooterRefreshing
{
    return self.footer.isRefreshing;
}

/**
 *  文字
 */
- (void)setFooterPullToRefreshText:(NSString *)footerPullToRefreshText
{
    self.footer.pullToRefreshText = footerPullToRefreshText;
}

- (NSString *)footerPullToRefreshText
{
    return self.footer.pullToRefreshText;
}

- (void)setFooterReleaseToRefreshText:(NSString *)footerReleaseToRefreshText
{
    self.footer.releaseToRefreshText = footerReleaseToRefreshText;
}

- (NSString *)footerReleaseToRefreshText
{
    return self.footer.releaseToRefreshText;
}

- (void)setFooterRefreshingText:(NSString *)footerRefreshingText
{
    self.footer.refreshingText = footerRefreshingText;
}

- (NSString *)footerRefreshingText
{
    return self.footer.refreshingText;
}

- (void)setHeaderPullToRefreshText:(NSString *)headerPullToRefreshText
{
    self.header.pullToRefreshText = headerPullToRefreshText;
}

- (NSString *)headerPullToRefreshText
{
    return self.header.pullToRefreshText;
}

- (void)setHeaderReleaseToRefreshText:(NSString *)headerReleaseToRefreshText
{
    self.header.releaseToRefreshText = headerReleaseToRefreshText;
}

- (NSString *)headerReleaseToRefreshText
{
    return self.header.releaseToRefreshText;
}

- (void)setHeaderRefreshingText:(NSString *)headerRefreshingText
{
    self.header.refreshingText = headerRefreshingText;
}

- (NSString *)headerRefreshingText
{
    return self.header.refreshingText;
}
@end
