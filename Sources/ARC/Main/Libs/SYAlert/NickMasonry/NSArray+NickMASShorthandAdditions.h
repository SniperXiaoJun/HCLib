//
//  NSArray+MASShorthandAdditions.h
//  Masonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "NSArray+NickMASAdditions.h"

#ifdef NickMAS_SHORTHAND

/**
 *	Shorthand array additions without the 'mas_' prefixes,
 *  only enabled if MAS_SHORTHAND is defined
 */
@interface NSArray (NickMASShorthandAdditions)

- (NSArray *)makeConstraints:(void(^)(NickMASConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(NickMASConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(NickMASConstraintMaker *make))block;

@end

@implementation NSArray (NickMASShorthandAdditions)

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
