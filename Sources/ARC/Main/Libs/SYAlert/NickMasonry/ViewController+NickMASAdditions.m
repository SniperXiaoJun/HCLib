//
//  UIViewController+MASAdditions.m
//  Masonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "ViewController+NickMASAdditions.h"

#ifdef NickMAS_VIEW_CONTROLLER

@implementation NickMAS_VIEW_CONTROLLER (NickMASAdditions)

- (NickMASViewAttribute *)mas_topLayoutGuide {
    return [[NickMASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (NickMASViewAttribute *)mas_topLayoutGuideTop {
    return [[NickMASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (NickMASViewAttribute *)mas_topLayoutGuideBottom {
    return [[NickMASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}

- (NickMASViewAttribute *)mas_bottomLayoutGuide {
    return [[NickMASViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (NickMASViewAttribute *)mas_bottomLayoutGuideTop {
    return [[NickMASViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (NickMASViewAttribute *)mas_bottomLayoutGuideBottom {
    return [[NickMASViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}



@end

#endif
