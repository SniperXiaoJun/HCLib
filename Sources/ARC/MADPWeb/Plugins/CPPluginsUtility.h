//
//  CPPluginsUtility.h
//  CPPlugins
//
//  Created by liurenpeng on 7/29/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPPluginsUtility : NSObject
/*!
 * @method
 * @abstract 根据路径返回url
 * @result  url
 */

+ (NSURLRequest *)managerUrlPath:(NSString *)urlpath;
@end
