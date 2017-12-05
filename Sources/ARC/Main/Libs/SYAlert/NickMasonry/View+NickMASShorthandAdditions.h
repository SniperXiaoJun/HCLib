//
//  UIView+MASShorthandAdditions.h
//  Masonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "View+NickMASAdditions.h"

#ifdef NickMAS_SHORTHAND

/**
 *	Shorthand view additions without the 'mas_' prefixes,
 *  only enabled if MAS_SHORTHAND is defined
 */
@interface NickMAS_VIEW (NickMASShorthandAdditions)

@property (nonatomic, strong, readonly) NickMASViewAttribute *left;
@property (nonatomic, strong, readonly) NickMASViewAttribute *top;
@property (nonatomic, strong, readonly) NickMASViewAttribute *right;
@property (nonatomic, strong, readonly) NickMASViewAttribute *bottom;
@property (nonatomic, strong, readonly) NickMASViewAttribute *leading;
@property (nonatomic, strong, readonly) NickMASViewAttribute *trailing;
@property (nonatomic, strong, readonly) NickMASViewAttribute *width;
@property (nonatomic, strong, readonly) NickMASViewAttribute *height;
@property (nonatomic, strong, readonly) NickMASViewAttribute *centerX;
@property (nonatomic, strong, readonly) NickMASViewAttribute *centerY;
@property (nonatomic, strong, readonly) NickMASViewAttribute *baseline;
@property (nonatomic, strong, readonly) NickMASViewAttribute *(^attribute)(NSLayoutAttribute attr);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) NickMASViewAttribute *firstBaseline;
@property (nonatomic, strong, readonly) NickMASViewAttribute *lastBaseline;

#endif

#if TARGET_OS_IPHONE || TARGET_OS_TV

@property (nonatomic, strong, readonly) NickMASViewAttribute *leftMargin;
@property (nonatomic, strong, readonly) NickMASViewAttribute *rightMargin;
@property (nonatomic, strong, readonly) NickMASViewAttribute *topMargin;
@property (nonatomic, strong, readonly) NickMASViewAttribute *bottomMargin;
@property (nonatomic, strong, readonly) NickMASViewAttribute *leadingMargin;
@property (nonatomic, strong, readonly) NickMASViewAttribute *trailingMargin;
@property (nonatomic, strong, readonly) NickMASViewAttribute *centerXWithinMargins;
@property (nonatomic, strong, readonly) NickMASViewAttribute *centerYWithinMargins;

#endif

- (NSArray *)makeConstraints:(void(^)(NickMASConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(NickMASConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(NickMASConstraintMaker *make))block;

@end

#define NickMAS_ATTR_FORWARD(attr)  \
- (NickMASViewAttribute *)attr {    \
    return [self mas_##attr];   \
}

@implementation NickMAS_VIEW (NickMASShorthandAdditions)

NickMAS_ATTR_FORWARD(top);
NickMAS_ATTR_FORWARD(left);
NickMAS_ATTR_FORWARD(bottom);
NickMAS_ATTR_FORWARD(right);
NickMAS_ATTR_FORWARD(leading);
NickMAS_ATTR_FORWARD(trailing);
NickMAS_ATTR_FORWARD(width);
NickMAS_ATTR_FORWARD(height);
NickMAS_ATTR_FORWARD(centerX);
NickMAS_ATTR_FORWARD(centerY);
NickMAS_ATTR_FORWARD(baseline);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

NickMAS_ATTR_FORWARD(firstBaseline);
NickMAS_ATTR_FORWARD(lastBaseline);

#endif

#if TARGET_OS_IPHONE || TARGET_OS_TV

NickMAS_ATTR_FORWARD(leftMargin);
NickMAS_ATTR_FORWARD(rightMargin);
NickMAS_ATTR_FORWARD(topMargin);
NickMAS_ATTR_FORWARD(bottomMargin);
NickMAS_ATTR_FORWARD(leadingMargin);
NickMAS_ATTR_FORWARD(trailingMargin);
NickMAS_ATTR_FORWARD(centerXWithinMargins);
NickMAS_ATTR_FORWARD(centerYWithinMargins);

#endif

- (NickMASViewAttribute *(^)(NSLayoutAttribute))attribute {
    return [self mas_attribute];
}

- (NSArray *)makeConstraints:(void(^)(NickMASConstraintMaker *))block {
    return [self mas_makeConstraints:block];
}

- (NSArray *)updateConstraints:(void(^)(NickMASConstraintMaker *))block {
    return [self mas_updateConstraints:block];
}

- (NSArray *)remakeConstraints:(void(^)(NickMASConstraintMaker *))block {
    return [self mas_remakeConstraints:block];
}

@end

#endif
