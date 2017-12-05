//
//  UIView+MASAdditions.m
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "View+NickMASAdditions.h"
#import <objc/runtime.h>

@implementation NickMAS_VIEW (NickMASAdditions)

- (NSArray *)mas_makeConstraints:(void(^)(NickMASConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NickMASConstraintMaker *constraintMaker = [[NickMASConstraintMaker alloc] initWithView:self];
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)mas_updateConstraints:(void(^)(NickMASConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NickMASConstraintMaker *constraintMaker = [[NickMASConstraintMaker alloc] initWithView:self];
    constraintMaker.updateExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)mas_remakeConstraints:(void(^)(NickMASConstraintMaker *make))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NickMASConstraintMaker *constraintMaker = [[NickMASConstraintMaker alloc] initWithView:self];
    constraintMaker.removeExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

#pragma mark - NSLayoutAttribute properties

- (NickMASViewAttribute *)mas_left {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeft];
}

- (NickMASViewAttribute *)mas_top {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTop];
}

- (NickMASViewAttribute *)mas_right {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRight];
}

- (NickMASViewAttribute *)mas_bottom {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottom];
}

- (NickMASViewAttribute *)mas_leading {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeading];
}

- (NickMASViewAttribute *)mas_trailing {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailing];
}

- (NickMASViewAttribute *)mas_width {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeWidth];
}

- (NickMASViewAttribute *)mas_height {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeHeight];
}

- (NickMASViewAttribute *)mas_centerX {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterX];
}

- (NickMASViewAttribute *)mas_centerY {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterY];
}

- (NickMASViewAttribute *)mas_baseline {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBaseline];
}

- (NickMASViewAttribute *(^)(NSLayoutAttribute))mas_attribute
{
    return ^(NSLayoutAttribute attr) {
        return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:attr];
    };
}

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (NickMASViewAttribute *)mas_firstBaseline {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeFirstBaseline];
}
- (NickMASViewAttribute *)mas_lastBaseline {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLastBaseline];
}

#endif

#if TARGET_OS_IPHONE || TARGET_OS_TV

- (NickMASViewAttribute *)mas_leftMargin {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeftMargin];
}

- (NickMASViewAttribute *)mas_rightMargin {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRightMargin];
}

- (NickMASViewAttribute *)mas_topMargin {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTopMargin];
}

- (NickMASViewAttribute *)mas_bottomMargin {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottomMargin];
}

- (NickMASViewAttribute *)mas_leadingMargin {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (NickMASViewAttribute *)mas_trailingMargin {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (NickMASViewAttribute *)mas_centerXWithinMargins {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (NickMASViewAttribute *)mas_centerYWithinMargins {
    return [[NickMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif

#pragma mark - associated properties

- (id)mas_key {
    return objc_getAssociatedObject(self, @selector(mas_key));
}

- (void)setMas_key:(id)key {
    objc_setAssociatedObject(self, @selector(mas_key), key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - heirachy

- (instancetype)mas_closestCommonSuperview:(NickMAS_VIEW *)view {
    NickMAS_VIEW *closestCommonSuperview = nil;

    NickMAS_VIEW *secondViewSuperview = view;
    while (!closestCommonSuperview && secondViewSuperview) {
        NickMAS_VIEW *firstViewSuperview = self;
        while (!closestCommonSuperview && firstViewSuperview) {
            if (secondViewSuperview == firstViewSuperview) {
                closestCommonSuperview = secondViewSuperview;
            }
            firstViewSuperview = firstViewSuperview.superview;
        }
        secondViewSuperview = secondViewSuperview.superview;
    }
    return closestCommonSuperview;
}

@end
