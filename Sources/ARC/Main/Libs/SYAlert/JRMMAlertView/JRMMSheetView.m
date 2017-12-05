//
//  JRMMSheetView.m
//  JRMMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "JRMMSheetView.h"
#import "JRMMPopupItem.h"
#import "JRMMPopupCategory.h"
#import "JRMMPopupDefine.h"
#import "NickMasonry.h"

@interface JRMMSheetView()

@property (nonatomic, strong) UIView      *titleView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIView      *buttonView;
@property (nonatomic, strong) UIButton    *cancelButton;

@property (nonatomic, strong) NSArray     *actionItems;

@end

@implementation JRMMSheetView

- (instancetype)initWithTitle:(NSString *)title items:(NSArray *)items
{
    self = [super init];
    
    if ( self )
    {
        NSAssert(items.count>0, @"Could not find any items.");
        
        JRMMSheetViewConfig *config = [JRMMSheetViewConfig globalConfig];
        
        self.type = JRMMPopupTypeSheet;
        self.actionItems = items;
        
        self.backgroundColor = config.splitColor;
        
        [self mas_makeConstraints:^(NickMASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        NickMASViewAttribute *lastAttribute = self.mas_top;
        if ( title.length > 0 )
        {
            self.titleView = [UIView new];
            [self addSubview:self.titleView];
            [self.titleView mas_makeConstraints:^(NickMASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
            }];
            self.titleView.backgroundColor = config.backgroundColor;
            
            self.titleLabel = [UILabel new];
            [self.titleView addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(NickMASConstraintMaker *make) {
                make.edges.equalTo(self.titleView).insets(UIEdgeInsetsMake(config.innerMargin, config.innerMargin, config.innerMargin, config.innerMargin));
            }];
            self.titleLabel.textColor = config.titleColor;
            self.titleLabel.font = [UIFont systemFontOfSize:config.titleFontSize];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.text = title;
            
            lastAttribute = self.titleView.mas_bottom;
        }
        
        self.buttonView = [UIView new];
        [self addSubview:self.buttonView];
        [self.buttonView mas_makeConstraints:^(NickMASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(lastAttribute);
        }];
        
        __block UIButton *firstButton = nil;
        __block UIButton *lastButton = nil;
        for ( NSInteger i = 0 ; i < items.count; ++i )
        {
            JRMMPopupItem *item = items[i];
            
            UIButton *btn = [UIButton mm_buttonWithTarget:self action:@selector(actionButton:)];
            [self.buttonView addSubview:btn];
            btn.tag = i;
            
            [btn mas_makeConstraints:^(NickMASConstraintMaker *make) {
                
                make.left.right.equalTo(self.buttonView).insets(UIEdgeInsetsMake(0, -JRMM_SPLIT_WIDTH, 0, -JRMM_SPLIT_WIDTH));
                make.height.mas_equalTo(config.buttonHeight);
                
                if ( !firstButton )
                {
                    firstButton = btn;
                    make.top.equalTo(self.buttonView.mas_top).offset(-JRMM_SPLIT_WIDTH);
                }
                else
                {
                    make.top.equalTo(lastButton.mas_bottom).offset(-JRMM_SPLIT_WIDTH);
                    make.height.equalTo(firstButton);
                }
                
                lastButton = btn;
            }];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.backgroundColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.backgroundColor] forState:UIControlStateDisabled];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
            [btn setTitle:item.title forState:UIControlStateNormal];
            [btn setTitleColor:item.highlight?config.itemHighlightColor:item.disabled?config.itemDisableColor:config.itemNormalColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:config.buttonFontSize];
            btn.layer.borderWidth = JRMM_SPLIT_WIDTH;
            btn.layer.borderColor = config.splitColor.CGColor;
            btn.enabled = !item.disabled;
        }
        [lastButton mas_updateConstraints:^(NickMASConstraintMaker *make) {
            make.bottom.equalTo(self.buttonView.mas_bottom).offset(JRMM_SPLIT_WIDTH);
        }];
        
        self.cancelButton = [UIButton mm_buttonWithTarget:self action:@selector(actionCancel)];
        [self addSubview:self.cancelButton];
        [self.cancelButton mas_makeConstraints:^(NickMASConstraintMaker *make) {
            make.left.right.equalTo(self.buttonView);
            make.height.mas_equalTo(config.buttonHeight);
            make.top.equalTo(self.buttonView.mas_bottom).offset(8);
        }];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:config.buttonFontSize];
        [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:config.backgroundColor] forState:UIControlStateNormal];
        [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
        [self.cancelButton setTitle:config.defaultTextCancel forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:config.itemNormalColor forState:UIControlStateNormal];
        
        [self mas_updateConstraints:^(NickMASConstraintMaker *make) {
            make.bottom.equalTo(self.cancelButton.mas_bottom);
        }];
        
    }
    
    return self;
}

- (void)actionButton:(UIButton*)btn
{
    JRMMPopupItem *item = self.actionItems[btn.tag];
    
    [self hide];
    
    if ( item.handler )
    {
        item.handler(btn.tag);
    }
}

- (void)actionCancel
{
    [self hide];
}

@end


@interface JRMMSheetViewConfig()

@end

@implementation JRMMSheetViewConfig

+ (JRMMSheetViewConfig *)globalConfig
{
    static JRMMSheetViewConfig *config;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        config = [JRMMSheetViewConfig new];
        
    });
    
    return config;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.buttonHeight   = 50.0f;
        self.innerMargin    = 19.0f;
        
        self.titleFontSize  = 14.0f;
        self.buttonFontSize = 17.0f;
        
        self.backgroundColor    = JRMMHexColor(0xFFFFFFFF);
        self.titleColor         = JRMMHexColor(0x666666FF);
        self.splitColor         = JRMMHexColor(0xCCCCCCFF);
        
        self.itemNormalColor    = JRMMHexColor(0x333333FF);
        self.itemDisableColor   = JRMMHexColor(0xCCCCCCFF);
        self.itemHighlightColor = JRMMHexColor(0xE76153FF);
        self.itemPressedColor   = JRMMHexColor(0xEFEDE7FF);
        
        self.defaultTextCancel  = @"取消";
    }
    
    return self;
}

@end
