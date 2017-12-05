//
//  NSArray+MASAdditions.m
//  
//
//  Created by Daniel Hammond on 11/26/13.
//
//

#import "NSArray+NickMASAdditions.h"
#import "View+NickMASAdditions.h"

@implementation NSArray (NickMASAdditions)

- (NSArray *)mas_makeConstraints:(void(^)(NickMASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (NickMAS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[NickMAS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view mas_makeConstraints:block]];
    }
    return constraints;
}

- (NSArray *)mas_updateConstraints:(void(^)(NickMASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (NickMAS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[NickMAS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view mas_updateConstraints:block]];
    }
    return constraints;
}

- (NSArray *)mas_remakeConstraints:(void(^)(NickMASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (NickMAS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[NickMAS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view mas_remakeConstraints:block]];
    }
    return constraints;
}

- (void)mas_distributeViewsAlongAxis:(NickMASAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    NickMAS_VIEW *tempSuperView = [self mas_commonSuperviewOfViews];
    if (axisType == NickMASAxisTypeHorizontal) {
        NickMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            NickMAS_VIEW *v = self[i];
            [v mas_makeConstraints:^(NickMASConstraintMaker *make) {
                if (prev) {
                    make.width.equalTo(prev);
                    make.left.equalTo(prev.mas_right).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
    else {
        NickMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            NickMAS_VIEW *v = self[i];
            [v mas_makeConstraints:^(NickMASConstraintMaker *make) {
                if (prev) {
                    make.height.equalTo(prev);
                    make.top.equalTo(prev.mas_bottom).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }                    
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
}

- (void)mas_distributeViewsAlongAxis:(NickMASAxisType)axisType withFixedItemLength:(CGFloat)fixedItemLength leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    NickMAS_VIEW *tempSuperView = [self mas_commonSuperviewOfViews];
    if (axisType == NickMASAxisTypeHorizontal) {
        NickMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            NickMAS_VIEW *v = self[i];
            [v mas_makeConstraints:^(NickMASConstraintMaker *make) {
                make.width.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                        make.right.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
    else {
        NickMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            NickMAS_VIEW *v = self[i];
            [v mas_makeConstraints:^(NickMASConstraintMaker *make) {
                make.height.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                        make.bottom.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
}

- (NickMAS_VIEW *)mas_commonSuperviewOfViews
{
    NickMAS_VIEW *commonSuperview = nil;
    NickMAS_VIEW *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[NickMAS_VIEW class]]) {
            NickMAS_VIEW *view = (NickMAS_VIEW *)object;
            if (previousView) {
                commonSuperview = [view mas_closestCommonSuperview:commonSuperview];
            } else {
                commonSuperview = view;
            }
            previousView = view;
        }
    }
    NSAssert(commonSuperview, @"Can't constrain views that do not share a common superview. Make sure that all the views in this array have been added into the same view hierarchy.");
    return commonSuperview;
}

@end
