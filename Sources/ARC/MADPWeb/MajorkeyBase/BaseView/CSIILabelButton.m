//
//  LabelButton.m
//  MobileClient
//
//  Created by 杨楠 on 14/8/19.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "CSIILabelButton.h"

@interface CSIILabelButton ()
{
    UIImageView* _buttomImage;
    UIImage* _selectImage;
    UIImage* _unselectImage;
    BOOL _selected;
}
@end

@implementation CSIILabelButton

@synthesize imageView = _buttomImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selected = NO;
        _label =  nil;
        _buttomImage = nil;
        _selectImage = nil;
        _unselectImage = nil;
    }
    return self;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    switch (state) {
        case UIControlStateNormal:
            _unselectImage = image;
            break;
        case UIControlStateHighlighted:
        case UIControlStateSelected:
            _selectImage = image;
            break;
        default:
            break;
    }
    if (_selected) {
        _buttomImage.image = _selectImage;
    } else {
        _buttomImage.image = _unselectImage;
    }
}

- (void)setImage:(UIImage *)image frame:(CGRect)frame forState:(UIControlState)state {
    if (_buttomImage) {
        _buttomImage.frame = frame;
    } else {
        _buttomImage = [[UIImageView alloc]initWithFrame:frame];
        [self addSubview:_buttomImage];
    }
    switch (state) {
        case UIControlStateNormal:
            _unselectImage = image;
            break;
        case UIControlStateHighlighted:
        case UIControlStateSelected:
            _selectImage = image;
            break;
        default:
            break;
    }
    if (_selected) {
        _buttomImage.image = _selectImage;
    } else {
        _buttomImage.image = _unselectImage;
    }
}

- (void)setLabel:(NSString *)label frame:(CGRect)frame {
    _label = [[UILabel alloc]initWithFrame:frame];
    _label.text = label;
    _label.textColor = RGB_COLOR(34, 34, 34);
    _label.backgroundColor = [UIColor clearColor];
    [self addSubview:_label];
}

- (BOOL)isSelected {
    return _selected;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        _buttomImage.image = _selectImage;
    } else {
        _buttomImage.image = _unselectImage;
    }
    _selected = selected;
}

@end
