//
//  JRCNScrollView.m
//  JRCNScrollView-Demo
//
//  Created by mac on 15-3-19.
//  Copyright (c) 2015年 Baby_V5. All rights reserved.
//

#import "JRCNScrollView.h"
#import "UIView+JRUIViewController.h"
#import "JRH5AppViewController.h"


#define kBaseTAG 500
#define kFlipViewTag 600

/**
 1.分析框架
 
    UIView->UIScrollView->ItemView
 
 2.布局
 
    各种View的frame
 
 3.动画分析
 
    item的动画实现（难点）
 
 */
@implementation JRCNScrollView

-(id)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        _itemsCount = 3;//默认有6个item

        [self setScrollWithFrame:frame];
        
    }
    
    return self;
}


//创建视图
-(void)setScrollWithFrame:(CGRect)frame{

    _scrollView = [[UIScrollView alloc]initWithFrame:frame];
    
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    _scrollView.userInteractionEnabled = YES;

    _scrollView.contentSize = CGSizeMake(self.frame.size.width*_itemsCount, self.frame.size.height);
    
    _scrollView.delegate = self;//设置代理
    
    _scrollView.pagingEnabled = YES;//分页效果
    
    _scrollView.bounces = YES;//反弹效果
    
    _scrollView.showsHorizontalScrollIndicator = NO;//水平滚动条
    
    [self addSubview:_scrollView];

}

//图片数组
-(void)setDataList:(NSArray *)dataList{

    _dataList = dataList;
    
    _itemsCount = dataList.count;
    
    [self creatItemView];//创建itemView
}

//创建itemView
-(void)creatItemView{
    
    if (_itemsCount == 0) {
        
        return;
    }
    for ( int i = 0; i < _itemsCount; i++ ) {
        
        NickItemsView*item = [[NickItemsView alloc]initWithFrame:CGRectMake(0+i*kScreenW, 0, kScreenW, kScreenH)];
        
        item.userInteractionEnabled = YES;
        
        item.index = i;
        
        item.tag = kBaseTAG+item.index;
        
        item.bgImageView.image = JRBundeImage([_dataList objectAtIndex:i]);
        
        
        [_scrollView addSubview:item];
        
        
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(100, kScreenH - 150, kScreenW-200, 100)];
        tapView.tag = i;
        [item addSubview:tapView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [tapView addGestureRecognizer:tap];
        
    }
    
    //初始化pageControl
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, 0)];
    
    pageControl.numberOfPages = _itemsCount;
    
    pageControl.currentPage = 0;
    
    [pageControl addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    
}
- (void)tapClick:(UITapGestureRecognizer *)tapGesture{
    
    DebugLog(@"-----%ld",tapGesture.view.tag);
    if (tapGesture.view.tag != (_itemsCount-1)) {
        [UIView animateWithDuration:.35 animations:^{
            _scrollView.contentOffset = CGPointMake((tapGesture.view.tag+1)*kScreenW, 0);
        }];
    }else{
        [self.viewController dismissViewControllerAnimated:YES completion:nil];

    }
   

}
-(void)valueChange:(UIPageControl*)page{

    [UIView animateWithDuration:.35 animations:^{
    
        _scrollView.contentOffset = CGPointMake(page.currentPage*kScreenW, 0);
        
    }];
}

#pragma mark - UIScrollViewDelegate
/**
 *  滑动时对itemView做动画
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x/kScreenW;
    
    pageControl.currentPage = index;
    
    
    pageControl.frame = CGRectMake(scrollView.contentOffset.x, kScreenH, kScreenW, 0);
   
}
#pragma mark - transform

//根据View获得横向偏移
- (CGFloat)baseOffsetForView:(NickItemsView *)view
{
    CGFloat offsetX =  view.index*kScreenW;
    
    return offsetX;
}

//根据偏移算角度
- (CGFloat)angleForView:(NickItemsView *)view
{

    CGFloat baseOffsetX = [self baseOffsetForView:view];//固定的偏移

    
    CGFloat currentOffsetX = _scrollView.contentOffset.x;//根据滑动改变的偏移
    
    
    CGFloat angle = (currentOffsetX - baseOffsetX)/(kScreenW);//根据比例计算角度
    
    
    return angle;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    NSLog(@"=====TouchScroll====");

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"move");

}
@end

/**
 *  itemsView
 */
@implementation NickItemsView


-(id)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        [self setSubViews];
    }
    return self;
}

-(void)setSubViews{
    
    self.userInteractionEnabled = YES;
    
    self.layer.cornerRadius = 0;//圆角
    
    self.layer.masksToBounds = YES;//覆盖边界

    self.layer.shadowOpacity = .5;//阴影效果不透明度
    
    self.layer.shadowOffset = CGSizeMake(0, 3);
 
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    
    _bgImageView.backgroundColor = [UIColor orangeColor];
    
    _bgImageView.userInteractionEnabled = YES;
    
    [self setMyKit];
    
    [self addSubview:_bgImageView];
    
}


-(void)setMyKit{

    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _btn.frame = CGRectMake(625*scaleW, 35*scaleH, 80*scaleW, 80*scaleW);
    
    _btn.layer.cornerRadius = 30;
    
    _btn.backgroundColor = [UIColor clearColor];
    
    [_btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_bgImageView addSubview:_btn];
    
}

#pragma mark - Action区
-(void)btnAction{

    NSLog(@"=====Click====");
    
    [UIView animateWithDuration:.35 animations:^{
        
        self.transform = CGAffineTransformScale(self.transform, 2, 2);
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {

        [self.viewController dismissViewControllerAnimated:YES completion:nil];
    }];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    NSLog(@"=====TouchItem====");
    if (_index == 3) {
        [self btnAction];
    }
}
@end






