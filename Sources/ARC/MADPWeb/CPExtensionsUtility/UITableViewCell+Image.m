//
//  UITableViewCell+Image.m
//  MobileClient
//
//  Created by 杨楠 on 14-8-12.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "UITableViewCell+Image.h"

#define cell_Height 44
@implementation UITableViewCell (Image)

- (void)setText:(NSString *)text withImage:(NSString *)imageName {
    [self setText:text withImage:imageName needArrow:NO];
}

- (void)setText:(NSString *)text withImage:(NSString *)imageName needArrow:(BOOL)need {
    [self setText:text textSize:16 withImage:imageName needArrow:need];
}

- (void)setText:(NSString *)text textSize:(CGFloat)size withImage:(NSString *)imageName needArrow:(BOOL)need {
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(62, cell_Height/2-40/2, 260, 40)];
    label.font=[UIFont boldSystemFontOfSize:size];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textColor = [UIColor colorWithRed:0.35f green:0.35f blue:0.35f alpha:1.00f];
    [self.contentView addSubview:label];
    NSInteger height = self.frame.size.height;
    if (imageName) {
        UIImage* iconImage = [UIImage imageNamed:imageName];
        if (iconImage == nil) {
            iconImage = JRBundeImage(@"转账汇款");
        }
        UIImageView* icon = [[UIImageView alloc]initWithFrame:CGRectMake(16, (cell_Height-iconImage.size.height/1.5)/2, iconImage.size.width/1.5, iconImage.size.height/1.5)];
        icon.image = iconImage;
        [self.contentView addSubview:icon];
    }
    
    if (need) {
        UIImage* arrowImage = JRBundeImage(@"disclosure_right");
        UIImageView* arrow = [[UIImageView alloc]initWithFrame:CGRectMake(296, (height - arrowImage.size.height)/2, arrowImage.size.width, arrowImage.size.height)];
        arrow.image = arrowImage;
        [self.contentView addSubview:arrow];
    }
}

@end
