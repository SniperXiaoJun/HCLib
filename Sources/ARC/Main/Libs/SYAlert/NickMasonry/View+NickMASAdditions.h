//
//  UIView+MASAdditions.h
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "NickMASUtilities.h"
#import "NickMASConstraintMaker.h"
#import "NickMASViewAttribute.h"

/**
 *	Provides constraint maker block
 *  and convience methods for creating MASViewAttribute which are view + NSLayoutAttribute pairs
 */
@interface NickMAS_VIEW (NickMASAdditions)

/**
 *	following properties return a new MASViewAttribute with current view and appropriate NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_left;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_top;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_right;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_bottom;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_leading;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_trailing;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_width;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_height;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_centerX;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_centerY;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_baseline;
@property (nonatomic, strong, readonly) NickMASViewAttribute *(^mas_attribute)(NSLayoutAttribute attr);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_firstBaseline;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_lastBaseline;

#endif

#if TARGET_OS_IPHONE || TARGET_OS_TV

@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_leftMargin;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_rightMargin;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_topMargin;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_bottomMargin;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_leadingMargin;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_trailingMargin;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_centerXWithinMargins;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_centerYWithinMargins;

#endif

/**
 *	a key to associate with this view
 */
@property (nonatomic, strong) id mas_key;

/**
 *	Finds the closest common superview between this view and another view
 *
 *	@param	view	other view
 *
 *	@return	returns nil if common superview could not be found
 */
- (instancetype)mas_closestCommonSuperview:(NickMAS_VIEW *)view;

/**
 *  Creates a MASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created MASConstraints
 */
- (NSArray *)mas_makeConstraints:(void(^)(NickMASConstraintMaker *make))block;

/**
 *  Creates a MASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  If an existing constraint exists then it will be updated instead.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated MASConstraints
 */
- (NSArray *)mas_updateConstraints:(void(^)(NickMASConstraintMaker *make))block;

/**
 *  Creates a MASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  All constraints previously installed for the view will be removed.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated MASConstraints
 */
- (NSArray *)mas_remakeConstraints:(void(^)(NickMASConstraintMaker *make))block;

@end
