//
//  CPBrowser.h
//  CPBrowser
//
//  Created by YuXiang on 15/11/4.
//  Copyright © 2015年 CSII. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*!
 * @class
 * @abstract wap页面用于展示网页。
 */

@interface WebBrowserViewController : UIViewController
{
    
    
}
/*!
 * @method
 * @abstract 初始化
 */
- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithURLString:(NSString *)urlString;


/*!
 * @method
 * @abstract 获取或者设置加载页面的url
 */
@property (nonatomic,strong)    NSURL *url;
/*!
 * @method
 * @abstract 配置网页加载进度条颜色，默认蓝色  
 */
@property (nonatomic,copy)      UIColor *loadingBarTintColor;
/*!
 * @method
 * @abstract 是否展示工具条，默认展示
 */

@property (nonatomic,assign)    BOOL navigationButtonsHidden;
/*!
 * @method
 * @abstract  是否展示网页加载进度条，默认展示
 */

@property (nonatomic,assign)    BOOL showLoadingBar;

/*!
 * @method
 * @abstract  当页面加载的时候，是否在导航栏上展示加载的url值
 */

@property (nonatomic,assign)    BOOL showUrlWhileLoading;
/*!
 * @method
 * @abstract 返回数据
 *
 */
- (void)reciveWithData:(NSDictionary*)aDictionary withComplete:(void (^)(id responseData))completeBlock;

@end
