//
//  CPDevice.m
//  CSIIPlatformLib
//
//  Created by 任兴 on 15/6/18.
//  Copyright (c) 2015年 刘任朋. All rights reserved.
//

#import "CPDevice.h"
#include <sys/sysctl.h>
#import "CSIIMADPReachability.h"


@interface CPDevice()
{
    
    BOOL isDeviceInfo;
    
}

@end

@implementation CPDevice


/**
 * @method
 * @abstract 获取设备信息
 * @discussion：信息包含：
 * @discussion：VersionName：应用版本名
 * @discussion：Platform：设备平台（Android/Ios/Windows Phone）
 * @discussion：Uuid：设备唯一标示
 * @discussion：Model：设备型号
 * @discussion：OSVersion：设备系统版本
 * @result 返回值通过pluginResponseCallback  类型 string
 */
-(void)DeviceInfo{
    
    isDeviceInfo=YES;
    
    NSMutableDictionary* devProps = [NSMutableDictionary dictionaryWithCapacity:4];
    [devProps setObject:[self Model] forKey:@"Model"];
    [devProps setObject:@"iOS" forKey:@"Platform"];
    [devProps setObject:[self OSVersion] forKey:@"OSVersion"];
    [devProps setObject:[self Uuid] forKey:@"Uuid"];
    [devProps setObject:[self VersionName] forKey:@"VersionName"];

    NSDictionary* devReturn = [NSDictionary dictionaryWithDictionary:devProps];
    
    pluginResponseCallback(devReturn);
    
    isDeviceInfo=NO;

}

/**
 * @method
 * @abstract 应用程序版本名
 * @result 返回值通过pluginResponseCallback  类型 string
 */
- (NSString*)VersionName{
    
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    if (!isDeviceInfo) {
        pluginResponseCallback(appVersion);

    }
        return appVersion;
}
/**
 * @method
 * @abstract 设备平台
 * @result 返回值通过pluginResponseCallback  类型 string
 */
- (NSString*)Platform{
    
    return @"IOS";
}

/**
 * @method
 * @abstract 设备唯一标识符(UUID)
 * @result 返回值通过pluginResponseCallback  类型 string
 */

- (NSString*)Uuid{

    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    static NSString* UUID_KEY = @"CDVUUID";
    
    NSString* app_uuid = [userDefaults stringForKey:UUID_KEY];
    
    if (app_uuid == nil) {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
        
        app_uuid = [NSString stringWithString:(__bridge NSString*)uuidString];
        [userDefaults setObject:app_uuid forKey:UUID_KEY];
        [userDefaults synchronize];
        
        CFRelease(uuidString);
        CFRelease(uuidRef);
    }
    if (!isDeviceInfo) {
        pluginResponseCallback(app_uuid);
        
    }


    return app_uuid;
}
/**
 * @method
 * @abstract 设备型号
 * @result 返回值通过pluginResponseCallback  类型 string
 */
- (NSString*)Model{
    
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) platform= @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) platform= @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) platform= @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) platform= @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) platform= @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) platform= @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) platform= @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) platform= @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) platform= @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) platform= @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) platform= @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) platform= @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) platform= @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) platform= @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) platform= @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,2"]) platform= @"iPhone 6s Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone8,1"]) platform= @"iPhone 6s (A1549/A1586)";

    
    if ([platform isEqualToString:@"iPod1,1"])   platform= @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   platform= @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   platform= @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   platform= @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   platform= @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   platform= @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   platform= @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   platform= @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   platform= @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   platform= @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   platform= @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   platform= @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   platform= @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   platform= @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   platform= @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   platform= @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   platform= @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   platform= @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   platform= @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   platform= @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   platform= @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   platform= @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   platform= @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   platform= @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   platform= @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      platform= @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    platform= @"iPhone Simulator";
    
    if (!isDeviceInfo) {

    pluginResponseCallback(platform);
    }

    return platform;

}
/**
 * @method
 * @abstract 设备系统版本
 * @result 返回值通过pluginResponseCallback  类型 string
 */
- (NSString *)OSVersion{
    
    UIDevice* device = [UIDevice currentDevice];
    
    if (!isDeviceInfo) {
       
        pluginResponseCallback([device systemVersion]);
    }
  
    return [device systemVersion];
}
/**
 * @method
 * @abstract 获取网络连接信息(2g/3g/4g/wifi/none)
 * @result 返回值通过pluginResponseCallback  类型 string
 */
-(NSString *)NetworkMsg{

    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"WIFI";
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    if (!isDeviceInfo) {

    pluginResponseCallback(state);
    }

    return state;
}

/**
 * @method
 * @abstract 获取网络连接状态(true/false)
 * @result 返回值通过pluginResponseCallback  类型 string
 */
-(NSString *)NetworkStatus{
    
    CSIIMADPReachability* internetReach = [CSIIMADPReachability reachabilityForInternetConnection];
    
    CSIIMADPNetworkStatus netStatus = [internetReach currentCSIIMADPReachabilityStatus];
    NSString *state ;

    switch (netStatus)
    {
        case CSIIMADPNotReachable:
        {
            state= @"false";
            break;
        }
        case CSIIMADPReachableViaWWAN:
        {
            state= @"true";
            
            break;
        }
        case CSIIMADPReachableViaWiFi:
        {
            state= @"true";
            break;
        }
    }
    if (!isDeviceInfo) {

    pluginResponseCallback(state);
    }

    return state;
    
}


@end
