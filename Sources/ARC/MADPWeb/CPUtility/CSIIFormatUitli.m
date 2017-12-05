//
//  CSIIFormatUitli.m
//  CPBaseManager
//
//  Created by 任兴 on 15/11/9.
//  Copyright © 2015年 刘认朋. All rights reserved.
//

#import "CSIIFormatUitli.h"

@implementation CSIIFormatUitli

//字符串变成date

- (NSDate *)formateStrToDate:(NSString *)str{
    NSString* string = [[NSString alloc] initWithString:str];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init] ;
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    [inputFormatter setDateFormat:@"yyyyMMdd"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    DebugLog(@"date = %@", inputDate);
    return inputDate;
}

+ (NSDate *)formateStrToDate:(NSString *)str{
    NSString* string = [[NSString alloc] initWithString:str];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init] ;
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    [inputFormatter setDateFormat:@"yyyyMMdd"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    DebugLog(@"date = %@", inputDate);
    return inputDate;
}

//textfield显示小数点  但是没有元
-(NSString *)splitByRmb:(NSString *)moneyStr{
    NSString *money =  [self splitMoneyStr:moneyStr];
    NSArray *arr = [money componentsSeparatedByString:@"元"];
    return [arr objectAtIndex:0];
    
}


+(NSString *)splitByRmb:(NSString *)moneyStr{
    NSString *money =  [self splitMoneyStr:moneyStr];
    NSArray *arr = [money componentsSeparatedByString:@"元"];
    return [arr objectAtIndex:0];
    
}


#pragma mark - 逗号拆分金额
-(NSString *)splitMoneyStr:(NSString *)moneyStr{//
    if (moneyStr == nil ||[moneyStr isEqualToString:@""]) {
        return @"";
    }
    
    if ([moneyStr isEqualToString:@".00"]||[moneyStr isEqualToString:@"0"]||[moneyStr isEqualToString:@"0.0"]||[moneyStr isEqualToString:@"0.00"]||[moneyStr isEqualToString:@".0"]) {
        return @"0.00元";
    }
    
    if ([moneyStr hasPrefix:@"."]) {
        if (moneyStr.length<=2) {
            return [NSString stringWithFormat:@"0%@0元",moneyStr];
        }else
            return [NSString stringWithFormat:@"0.%@元",[moneyStr substringWithRange:NSMakeRange(1, 2)]];
    }
    
    if ([moneyStr hasSuffix:@"元"]) {
        moneyStr = [[moneyStr componentsSeparatedByString:@"元"] objectAtIndex:0];
    }
    
    
    BOOL isBigThanZero = YES;
    if ([moneyStr hasPrefix:@"-"]) {
        isBigThanZero = NO;
        moneyStr = [moneyStr substringFromIndex:1];
    }
    
    NSArray *splitByDot = [[NSArray alloc] init];
    splitByDot = [moneyStr componentsSeparatedByString:@"."];
    
    //小数点 lastStr
    NSString *lastStr = [[NSString alloc] init];
    if (splitByDot.count>1) {
        lastStr = [splitByDot objectAtIndex:1];
    }
    if (lastStr.length>=2) {
        lastStr = [lastStr substringWithRange:NSMakeRange(0, 2)];
    }else if(lastStr.length == 1){
        lastStr = [lastStr stringByAppendingString:@"0"];
    }else{
        lastStr = @".00";
    }
    
    NSString *preDotStr = [splitByDot objectAtIndex:0];//.之前的数字
    if (preDotStr.length<=3) {    //点之前的数字位数小于等于三时不需要加逗号，直接返回
        
        if ([[splitByDot objectAtIndex:0] isEqualToString:@"0"]) {
            return [[preDotStr stringByAppendingString:[NSString stringWithFormat:@".%@",lastStr]] stringByAppendingString:@"元"];
        }
        
        if (isBigThanZero == YES) {
            if (splitByDot.count>1) {
                return [[preDotStr stringByAppendingString:[NSString stringWithFormat:@".%@",lastStr]] stringByAppendingString:@"元"];
            }else{
                return [preDotStr stringByAppendingString:@".00元"];
            }
        }else {
            if (splitByDot.count>1) {
                return [[NSString stringWithFormat:@"-%@",[splitByDot objectAtIndex:0]] stringByAppendingString:[NSString stringWithFormat:@".%@元",lastStr]];
                
            }
            return [[NSString stringWithFormat:@"-%@",[splitByDot objectAtIndex:0]] stringByAppendingString:@".00元"];
        }
    }
    
    //拆分加“,”
    NSMutableArray *subMoneyArr = [[NSMutableArray alloc] init];
    if (preDotStr.length%3==0) {
        for (int i = 0; i<preDotStr.length/3; i++) {
            NSString *s = [preDotStr substringWithRange:NSMakeRange(preDotStr.length-(i+1)*3,3)];
            [subMoneyArr addObject:s];
        }
    }else{
        for (int i = 0; i<preDotStr.length/3+1; i++) {
            NSString *s = @"";
            if (i == preDotStr.length/3) {
                s = [preDotStr substringWithRange:NSMakeRange(0,preDotStr.length%3)];
            }else{
                s = [preDotStr substringWithRange:NSMakeRange(preDotStr.length-(i+1)*3,3)];
            }
            [subMoneyArr addObject:s];
        }
    }
    NSString *str = @"";
    for (int i = 0; i<subMoneyArr.count; i++) {
        str = [NSString stringWithFormat:@"%@%@,",str,[subMoneyArr objectAtIndex:subMoneyArr.count-i-1]];
    }
    
    //最后拼接在一起
    NSMutableString *moneyAppendDot = [[NSMutableString alloc] init];
    if (isBigThanZero == YES) {
        if (splitByDot.count>1) {
            moneyAppendDot = [NSMutableString stringWithFormat:@"%@.%@元",[str substringToIndex:str.length-1],lastStr];
        }else{
            moneyAppendDot = [NSMutableString stringWithFormat:@"%@.00元",[str substringToIndex:str.length-1]];
        }
        
    }else {
        if (splitByDot.count>1) {
            moneyAppendDot = [NSMutableString stringWithFormat:@"-%@.%@元",[str substringToIndex:str.length-1],lastStr];
            
        }else{
            moneyAppendDot = [NSMutableString stringWithFormat:@"-%@.00元",[str substringToIndex:str.length-1]];
            
        }
    }
    
    return moneyAppendDot;
}

+(NSString *)splitMoneyStr:(NSString *)moneyStr{//
    if (moneyStr == nil ||[moneyStr isEqualToString:@""]) {
        return @"";
    }
    
    if ([moneyStr isEqualToString:@".00"]||[moneyStr isEqualToString:@"0"]||[moneyStr isEqualToString:@"0.0"]||[moneyStr isEqualToString:@"0.00"]||[moneyStr isEqualToString:@".0"]) {
        return @"0.00元";
    }
    
    if ([moneyStr hasPrefix:@"."]) {
        if (moneyStr.length<=2) {
            return [NSString stringWithFormat:@"0%@0元",moneyStr];
        }else
            return [NSString stringWithFormat:@"0.%@元",[moneyStr substringWithRange:NSMakeRange(1, 2)]];
    }
    
    if ([moneyStr hasSuffix:@"元"]) {
        moneyStr = [[moneyStr componentsSeparatedByString:@"元"] objectAtIndex:0];
    }
    
    
    BOOL isBigThanZero = YES;
    if ([moneyStr hasPrefix:@"-"]) {
        isBigThanZero = NO;
        moneyStr = [moneyStr substringFromIndex:1];
    }
    
    NSArray *splitByDot = [[NSArray alloc] init];
    splitByDot = [moneyStr componentsSeparatedByString:@"."];
    
    //小数点 lastStr
    NSString *lastStr = [[NSString alloc] init];
    if (splitByDot.count>1) {
        lastStr = [splitByDot objectAtIndex:1];
    }
    if (lastStr.length>=2) {
        lastStr = [lastStr substringWithRange:NSMakeRange(0, 2)];
    }else if(lastStr.length == 1){
        lastStr = [lastStr stringByAppendingString:@"0"];
    }else{
        lastStr = @".00";
    }
    
    NSString *preDotStr = [splitByDot objectAtIndex:0];//.之前的数字
    if (preDotStr.length<=3) {    //点之前的数字位数小于等于三时不需要加逗号，直接返回
        
        if ([[splitByDot objectAtIndex:0] isEqualToString:@"0"]) {
            return [[preDotStr stringByAppendingString:[NSString stringWithFormat:@".%@",lastStr]] stringByAppendingString:@"元"];
        }
        
        if (isBigThanZero == YES) {
            if (splitByDot.count>1) {
                return [[preDotStr stringByAppendingString:[NSString stringWithFormat:@".%@",lastStr]] stringByAppendingString:@"元"];
            }else{
                return [preDotStr stringByAppendingString:@".00元"];
            }
        }else {
            if (splitByDot.count>1) {
                return [[NSString stringWithFormat:@"-%@",[splitByDot objectAtIndex:0]] stringByAppendingString:[NSString stringWithFormat:@".%@元",lastStr]];
                
            }
            return [[NSString stringWithFormat:@"-%@",[splitByDot objectAtIndex:0]] stringByAppendingString:@".00元"];
        }
    }
    
    //拆分加“,”
    NSMutableArray *subMoneyArr = [[NSMutableArray alloc] init];
    if (preDotStr.length%3==0) {
        for (int i = 0; i<preDotStr.length/3; i++) {
            NSString *s = [preDotStr substringWithRange:NSMakeRange(preDotStr.length-(i+1)*3,3)];
            [subMoneyArr addObject:s];
        }
    }else{
        for (int i = 0; i<preDotStr.length/3+1; i++) {
            NSString *s = @"";
            if (i == preDotStr.length/3) {
                s = [preDotStr substringWithRange:NSMakeRange(0,preDotStr.length%3)];
            }else{
                s = [preDotStr substringWithRange:NSMakeRange(preDotStr.length-(i+1)*3,3)];
            }
            [subMoneyArr addObject:s];
        }
    }
    NSString *str = @"";
    for (int i = 0; i<subMoneyArr.count; i++) {
        str = [NSString stringWithFormat:@"%@%@,",str,[subMoneyArr objectAtIndex:subMoneyArr.count-i-1]];
    }
    
    //最后拼接在一起
    NSMutableString *moneyAppendDot = [[NSMutableString alloc] init];
    if (isBigThanZero == YES) {
        if (splitByDot.count>1) {
            moneyAppendDot = [NSMutableString stringWithFormat:@"%@.%@元",[str substringToIndex:str.length-1],lastStr];
        }else{
            moneyAppendDot = [NSMutableString stringWithFormat:@"%@.00元",[str substringToIndex:str.length-1]];
        }
        
    }else {
        if (splitByDot.count>1) {
            moneyAppendDot = [NSMutableString stringWithFormat:@"-%@.%@元",[str substringToIndex:str.length-1],lastStr];
            
        }else{
            moneyAppendDot = [NSMutableString stringWithFormat:@"-%@.00元",[str substringToIndex:str.length-1]];
            
        }
    }
    
    return moneyAppendDot;
}

//判断是否为整型
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

//银行卡号格式化
- (NSString *)splitCardNumberStr:(NSString *)cnStr{
    NSMutableString *cardNumber = [[NSMutableString alloc]init];
    NSUInteger lenth = cnStr.length;
    NSString *start = [cnStr substringWithRange:NSMakeRange(0, 4)];
    NSString *end = [cnStr substringWithRange:NSMakeRange(lenth-4,4)];
    
    [cardNumber appendString:start];
    [cardNumber appendString:@"****"];
    [cardNumber appendString:end];
    return cardNumber;
}

//转换成NSDate
-(NSString *) formateDate:(NSDate *) date{
    if (date) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];//用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:date];
        return currentDateStr;
    }
    return @"";
}

//转换成NSDate
+(NSString *) formateDate:(NSDate *) date{
    if (date) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];//用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:date];
        return currentDateStr;
    }
    return @"";
}


//获取字符串文字的长度
+(CGFloat)getWidthOfString:(NSString *)string font:(UIFont *)font height:(CGFloat)height{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width;
    
}

@end
