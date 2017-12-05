//
//  MASConstraintBuilder.h
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "NickMASConstraint.h"
#import "NickMASUtilities.h"

typedef NS_OPTIONS(NSInteger, NickMASAttribute) {
    NickMASAttributeLeft = 1 << NSLayoutAttributeLeft,
    NickMASAttributeRight = 1 << NSLayoutAttributeRight,
    NickMASAttributeTop = 1 << NSLayoutAttributeTop,
    NickMASAttributeBottom = 1 << NSLayoutAttributeBottom,
    NickMASAttributeLeading = 1 << NSLayoutAttributeLeading,
    NickMASAttributeTrailing = 1 << NSLayoutAttributeTrailing,
    NickMASAttributeWidth = 1 << NSLayoutAttributeWidth,
    NickMASAttributeHeight = 1 << NSLayoutAttributeHeight,
    NickMASAttributeCenterX = 1 << NSLayoutAttributeCenterX,
    NickMASAttributeCenterY = 1 << NSLayoutAttributeCenterY,
    NickMASAttributeBaseline = 1 << NSLayoutAttributeBaseline,
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    
    NickMASAttributeFirstBaseline = 1 << NSLayoutAttributeFirstBaseline,
    NickMASAttributeLastBaseline = 1 << NSLayoutAttributeLastBaseline,
    
#endif
    
#if TARGET_OS_IPHONE || TARGET_OS_TV
    
    NickMASAttributeLeftMargin = 1 << NSLayoutAttributeLeftMargin,
    NickMASAttributeRightMargin = 1 << NSLayoutAttributeRightMargin,
    NickMASAttributeTopMargin = 1 << NSLayoutAttributeTopMargin,
    NickMASAttributeBottomMargin = 1 << NSLayoutAttributeBottomMargin,
    NickMASAttributeLeadingMargin = 1 << NSLayoutAttributeLeadingMargin,
    NickMASAttributeTrailingMargin = 1 << NSLayoutAttributeTrailingMargin,
    NickMASAttributeCenterXWithinMargins = 1 << NSLayoutAttributeCenterXWithinMargins,
    NickMASAttributeCenterYWithinMargins = 1 << NSLayoutAttributeCenterYWithinMargins,

#endif
    
};

/**
 *  Provides factory methods for creating MASConstraints.
 *  Constraints are collected until they are ready to be installed
 *
 */
@interface NickMASConstraintMaker : NSObject

/**
 *	The following properties return a new MASViewConstraint
 *  with the first item set to the makers associated view and the appropriate MASViewAttribute
 */
@property (nonatomic, strong, readonly) NickMASConstraint *left;
@property (nonatomic, strong, readonly) NickMASConstraint *top;
@property (nonatomic, strong, readonly) NickMASConstraint *right;
@property (nonatomic, strong, readonly) NickMASConstraint *bottom;
@property (nonatomic, strong, readonly) NickMASConstraint *leading;
@property (nonatomic, strong, readonly) NickMASConstraint *trailing;
@property (nonatomic, strong, readonly) NickMASConstraint *width;
@property (nonatomic, strong, readonly) NickMASConstraint *height;
@property (nonatomic, strong, readonly) NickMASConstraint *centerX;
@property (nonatomic, strong, readonly) NickMASConstraint *centerY;
@property (nonatomic, strong, readonly) NickMASConstraint *baseline;

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) NickMASConstraint *firstBaseline;
@property (nonatomic, strong, readonly) NickMASConstraint *lastBaseline;

#endif

#if TARGET_OS_IPHONE || TARGET_OS_TV

@property (nonatomic, strong, readonly) NickMASConstraint *leftMargin;
@property (nonatomic, strong, readonly) NickMASConstraint *rightMargin;
@property (nonatomic, strong, readonly) NickMASConstraint *topMargin;
@property (nonatomic, strong, readonly) NickMASConstraint *bottomMargin;
@property (nonatomic, strong, readonly) NickMASConstraint *leadingMargin;
@property (nonatomic, strong, readonly) NickMASConstraint *trailingMargin;
@property (nonatomic, strong, readonly) NickMASConstraint *centerXWithinMargins;
@property (nonatomic, strong, readonly) NickMASConstraint *centerYWithinMargins;

#endif

/**
 *  Returns a block which creates a new MASCompositeConstraint with the first item set
 *  to the makers associated view and children corresponding to the set bits in the
 *  MASAttribute parameter. Combine multiple attributes via binary-or.
 */
@property (nonatomic, strong, readonly) NickMASConstraint *(^attributes)(NickMASAttribute attrs);

/**
 *	Creates a MASCompositeConstraint with type MASCompositeConstraintTypeEdges
 *  which generates the appropriate MASViewConstraint children (top, left, bottom, right)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) NickMASConstraint *edges;

/**
 *	Creates a MASCompositeConstraint with type MASCompositeConstraintTypeSize
 *  which generates the appropriate MASViewConstraint children (width, height)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) NickMASConstraint *size;

/**
 *	Creates a MASCompositeConstraint with type MASCompositeConstraintTypeCenter
 *  which generates the appropriate MASViewConstraint children (centerX, centerY)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) NickMASConstraint *center;

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL updateExisting;

/**
 *  Whether or not to remove existing constraints prior to installing
 */
@property (nonatomic, assign) BOOL removeExisting;

/**
 *	initialises the maker with a default view
 *
 *	@param	view	any MASConstrait are created with this view as the first item
 *
 *	@return	a new MASConstraintMaker
 */
- (id)initWithView:(NickMAS_VIEW *)view;

/**
 *	Calls install method on any MASConstraints which have been created by this maker
 *
 *	@return	an array of all the installed MASConstraints
 */
- (NSArray *)install;

- (NickMASConstraint * (^)(dispatch_block_t))group;

@end
