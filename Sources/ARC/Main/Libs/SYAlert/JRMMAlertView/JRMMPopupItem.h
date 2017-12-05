//
//  MMActionItem.h
//  JRMMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^JRMMPopupItemHandler)(NSInteger index);

@interface JRMMPopupItem : NSObject

@property (nonatomic, assign) BOOL     highlight;
@property (nonatomic, assign) BOOL     disabled;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor  *color;

@property (nonatomic, copy)   JRMMPopupItemHandler handler;

@end

typedef NS_ENUM(NSUInteger, JRMMItemType) {
    JRMMItemTypeNormal,
    JRMMItemTypeHighlight,
    JRMMItemTypeDisabled
};

NS_INLINE JRMMPopupItem* JRMMItemMake(NSString* title, JRMMItemType type, JRMMPopupItemHandler handler)
{
    JRMMPopupItem *item = [JRMMPopupItem new];
    
    item.title = title;
    item.handler = handler;
    
    switch (type)
    {
        case JRMMItemTypeNormal:
        {
            break;
        }
        case JRMMItemTypeHighlight:
        {
            item.highlight = YES;
            break;
        }
        case JRMMItemTypeDisabled:
        {
            item.disabled = YES;
            break;
        }
        default:
            break;
    }
    
    return item;
}
