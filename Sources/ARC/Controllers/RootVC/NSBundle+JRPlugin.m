

#import "NSBundle+JRPlugin.h"
#import "JRRootViewController.h"

@implementation NSBundle (JRPlugin)

+ (NSBundle *)jr_imagePickerBundle {
    NSBundle *bundle = [NSBundle bundleForClass:[JRRootViewController class]];
    NSURL *url = [bundle URLForResource:@"JRBundle" withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:url];
    return bundle;
}

+ (NSString *)jr_localizedStringForKey:(NSString *)key {
    return [self jr_localizedStringForKey:key value:@""];
}

+ (NSString *)jr_localizedStringForKey:(NSString *)key value:(NSString *)value {
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language rangeOfString:@"zh-Hans"].location != NSNotFound) {
            language = @"zh-Hans";
        } else {
            language = @"en";
        }
        bundle = [NSBundle bundleWithPath:[[NSBundle jr_imagePickerBundle] pathForResource:language ofType:@"lproj"]];
    }
    NSString *value1 = [bundle localizedStringForKey:key value:value table:nil];
    return value1;
}
@end

