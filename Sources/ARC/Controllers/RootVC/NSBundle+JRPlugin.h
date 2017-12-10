
#import <UIKit/UIKit.h>

@interface NSBundle (JRPlugin)

+ (NSBundle *)jr_imagePickerBundle;

+ (NSString *)jr_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)jr_localizedStringForKey:(NSString *)key;

@end

