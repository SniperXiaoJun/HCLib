//
//  CSIIUIVXWebCachingURLProtocol.h
//  CSIILib
//
//  Created by 刘旺 on 13-5-14.
//  Copyright (c) 2013年 北京科蓝软件系统股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CSIIMADPZipFile.h"
#import "CSIIMADPZipException.h"
#import "CSIIMADPFileInZipInfo.h"
#import "CSIIMADPZipWriteStream.h"
#import "CSIIMADPZipReadStream.h"

@interface CPUIVXWebCachingURLProtocol
    : NSURLProtocol <NSURLConnectionDelegate, UIAlertViewDelegate> {
  NSDictionary *changeDic;
  CSIIMADPZipReadStream *readStream;
}

@end
