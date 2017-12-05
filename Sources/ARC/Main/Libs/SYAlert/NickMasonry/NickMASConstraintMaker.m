//
//  MASConstraintBuilder.m
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "NickMASConstraintMaker.h"
#import "NickMASViewConstraint.h"
#import "NickMASCompositeConstraint.h"
#import "NickMASConstraint+Private.h"
#import "NickMASViewAttribute.h"
#import "View+NickMASAdditions.h"

@interface NickMASConstraintMaker () <NickMASConstraintDelegate>

@property (nonatomic, weak) NickMAS_VIEW *view;
@property (nonatomic, strong) NSMutableArray *constraints;

@end

@implementation NickMASConstraintMaker

- (id)initWithView:(NickMAS_VIEW *)view {
    self = [super init];
    if (!self) return nil;
    
    self.view = view;
    self.constraints = NSMutableArray.new;
    
    return self;
}

- (NSArray *)install {
    if (self.removeExisting) {
        NSArray *installedConstraints = [NickMASViewConstraint installedConstraintsForView:self.view];
        for (NickMASConstraint *constraint in installedConstraints) {
            [constraint uninstall];
        }
    }
    NSArray *constraints = self.constraints.copy;
    for (NickMASConstraint *constraint in constraints) {
        constraint.updateExisting = self.updateExisting;
        [constraint install];
    }
    [self.constraints removeAllObjects];
    return constraints;
}

#pragma mark - MASConstraintDelegate

- (void)constraint:(NickMASConstraint *)constraint shouldBeReplacedWithConstraint:(NickMASConstraint *)replacementConstraint {
    NSUInteger index = [self.constraints indexOfObject:constraint];
    NSAssert(index != NSNotFound, @"Could not find constraint %@", constraint);
    [self.constraints replaceObjectAtIndex:index withObject:replacementConstraint];
}

- (NickMASConstraint *)constraint:(NickMASConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    NickMASViewAttribute *viewAttribute = [[NickMASViewAttribute alloc] initWithView:self.view layoutAttribute:layoutAttribute];
    NickMASViewConstraint *newConstraint = [[NickMASViewConstraint alloc] initWithFirstViewAttribute:viewAttribute];
    if ([constraint isKindOfClass:NickMASViewConstraint.class]) {
        //replace with composite constraint
        NSArray *children = @[constraint, newConstraint];
        NickMASCompositeConstraint *compositeConstraint = [[NickMASCompositeConstraint alloc] initWithChildren:children];
        compositeConstraint.delegate = self;
        [self constraint:constraint shouldBeReplacedWithConstraint:compositeConstraint];
        return compositeConstraint;
    }
    if (!constraint) {
        newConstraint.delegate = self;
        [self.constraints addObject:newConstraint];
    }
    return newConstraint;
}

- (NickMASConstraint *)addConstraintWithAttributes:(NickMASAttribute)attrs {
    __unused NickMASAttribute anyAttribute = (NickMASAttributeLeft | NickMASAttributeRight | NickMASAttributeTop | NickMASAttributeBottom | NickMASAttributeLeading
                                          | NickMASAttributeTrailing | NickMASAttributeWidth | NickMASAttributeHeight | NickMASAttributeCenterX
                                          | NickMASAttributeCenterY | NickMASAttributeBaseline
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
                                          | NickMASAttributeFirstBaseline | NickMASAttributeLastBaseline
#endif
#if TARGET_OS_IPHONE || TARGET_OS_TV
                                          | NickMASAttributeLeftMargin | NickMASAttributeRightMargin | NickMASAttributeTopMargin | NickMASAttributeBottomMargin
                                          | NickMASAttributeLeadingMargin | NickMASAttributeTrailingMargin | NickMASAttributeCenterXWithinMargins
                                          | NickMASAttributeCenterYWithinMargins
#endif
                                          );
    
    NSAssert((attrs & anyAttribute) != 0, @"You didn't pass any attribute to make.attributes(...)");
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    if (attrs & NickMASAttributeLeft) [attributes addObject:self.view.mas_left];
    if (attrs & NickMASAttributeRight) [attributes addObject:self.view.mas_right];
    if (attrs & NickMASAttributeTop) [attributes addObject:self.view.mas_top];
    if (attrs & NickMASAttributeBottom) [attributes addObject:self.view.mas_bottom];
    if (attrs & NickMASAttributeLeading) [attributes addObject:self.view.mas_leading];
    if (attrs & NickMASAttributeTrailing) [attributes addObject:self.view.mas_trailing];
    if (attrs & NickMASAttributeWidth) [attributes addObject:self.view.mas_width];
    if (attrs & NickMASAttributeHeight) [attributes addObject:self.view.mas_height];
    if (attrs & NickMASAttributeCenterX) [attributes addObject:self.view.mas_centerX];
    if (attrs & NickMASAttributeCenterY) [attributes addObject:self.view.mas_centerY];
    if (attrs & NickMASAttributeBaseline) [attributes addObject:self.view.mas_baseline];
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    
    if (attrs & NickMASAttributeFirstBaseline) [attributes addObject:self.view.mas_firstBaseline];
    if (attrs & NickMASAttributeLastBaseline) [attributes addObject:self.view.mas_lastBaseline];
    
#endif
    
#if TARGET_OS_IPHONE || TARGET_OS_TV
    
    if (attrs & NickMASAttributeLeftMargin) [attributes addObject:self.view.mas_leftMargin];
    if (attrs & NickMASAttributeRightMargin) [attributes addObject:self.view.mas_rightMargin];
    if (attrs & NickMASAttributeTopMargin) [attributes addObject:self.view.mas_topMargin];
    if (attrs & NickMASAttributeBottomMargin) [attributes addObject:self.view.mas_bottomMargin];
    if (attrs & NickMASAttributeLeadingMargin) [attributes addObject:self.view.mas_leadingMargin];
    if (attrs & NickMASAttributeTrailingMargin) [attributes addObject:self.view.mas_trailingMargin];
    if (attrs & NickMASAttributeCenterXWithinMargins) [attributes addObject:self.view.mas_centerXWithinMargins];
    if (attrs & NickMASAttributeCenterYWithinMargins) [attributes addObject:self.view.mas_centerYWithinMargins];
    
#endif
    
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:attributes.count];
    
    for (NickMASViewAttribute *a in attributes) {
        [children addObject:[[NickMASViewConstraint alloc] initWithFirstViewAttribute:a]];
    }
    
    NickMASCompositeConstraint *constraint = [[NickMASCompositeConstraint alloc] initWithChildren:children];
    constraint.delegate = self;
    [self.constraints addObject:constraint];
    return constraint;
}

#pragma mark - standard Attributes

- (NickMASConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    return [self constraint:nil addConstraintWithLayoutAttribute:layoutAttribute];
}

- (NickMASConstraint *)left {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeft];
}

- (NickMASConstraint *)top {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTop];
}

- (NickMASConstraint *)right {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRight];
}

- (NickMASConstraint *)bottom {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottom];
}

- (NickMASConstraint *)leading {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeading];
}

- (NickMASConstraint *)trailing {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailing];
}

- (NickMASConstraint *)width {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeWidth];
}

- (NickMASConstraint *)height {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeHeight];
}

- (NickMASConstraint *)centerX {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterX];
}

- (NickMASConstraint *)centerY {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterY];
}

- (NickMASConstraint *)baseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBaseline];
}

- (NickMASConstraint *(^)(NickMASAttribute))attributes {
    return ^(NickMASAttribute attrs){
        return [self addConstraintWithAttributes:attrs];
    };
}

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (NickMASConstraint *)firstBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeFirstBaseline];
}

- (NickMASConstraint *)lastBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLastBaseline];
}

#endif


#if TARGET_OS_IPHONE || TARGET_OS_TV

- (NickMASConstraint *)leftMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeftMargin];
}

- (NickMASConstraint *)rightMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRightMargin];
}

- (NickMASConstraint *)topMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTopMargin];
}

- (NickMASConstraint *)bottomMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottomMargin];
}

- (NickMASConstraint *)leadingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (NickMASConstraint *)trailingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (NickMASConstraint *)centerXWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (NickMASConstraint *)centerYWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif


#pragma mark - composite Attributes

- (NickMASConstraint *)edges {
    return [self addConstraintWithAttributes:NickMASAttributeTop | NickMASAttributeLeft | NickMASAttributeRight | NickMASAttributeBottom];
}

- (NickMASConstraint *)size {
    return [self addConstraintWithAttributes:NickMASAttributeWidth | NickMASAttributeHeight];
}

- (NickMASConstraint *)center {
    return [self addConstraintWithAttributes:NickMASAttributeCenterX | NickMASAttributeCenterY];
}

#pragma mark - grouping

- (NickMASConstraint *(^)(dispatch_block_t group))group {
    return ^id(dispatch_block_t group) {
        NSInteger previousCount = self.constraints.count;
        group();

        NSArray *children = [self.constraints subarrayWithRange:NSMakeRange(previousCount, self.constraints.count - previousCount)];
        NickMASCompositeConstraint *constraint = [[NickMASCompositeConstraint alloc] initWithChildren:children];
        constraint.delegate = self;
        return constraint;
    };
}

@end
