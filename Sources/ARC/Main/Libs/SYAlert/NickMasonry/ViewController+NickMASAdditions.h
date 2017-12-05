//
//  UIViewController+MASAdditions.h
//  Masonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "NickMASUtilities.h"
#import "NickMASConstraintMaker.h"
#import "NickMASViewAttribute.h"

#ifdef NickMAS_VIEW_CONTROLLER

@interface NickMAS_VIEW_CONTROLLER (NickMASAdditions)

/**
 *	following properties return a new MASViewAttribute with appropriate UILayoutGuide and NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_topLayoutGuide;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_bottomLayoutGuide;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_topLayoutGuideTop;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_topLayoutGuideBottom;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_bottomLayoutGuideTop;
@property (nonatomic, strong, readonly) NickMASViewAttribute *mas_bottomLayoutGuideBottom;


@end

#endif
