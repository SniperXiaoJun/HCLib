
#ifndef __CSIIMJConst__H__
#define __CSIIMJConst__H__

#ifdef DEBUG  // 调试状态
// 打开LOG功能
#define CSIIMJLog(...) NSLog(__VA_ARGS__)
#else // 发布状态
// 关闭LOG功能
#define CSIIMJLog(...)
#endif

// 颜色
#define CSIIMJColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define CSIIMJRandomColor CSIIMJColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

// 断言
#define CSIIMJAssert2(condition, desc, returnValue) \
if ((condition) == NO) { \
NSString *file = [NSString stringWithUTF8String:__FILE__]; \
CSIIMJLog(@"\n警告文件：%@\n警告行数：第%d行\n警告方法：%s\n警告描述：%@", file, __LINE__,  __FUNCTION__, desc); \
CSIIMJLog(@"\n如果不想看到警告信息，可以删掉CSIIMJConst.h中的第23、第24行"); \
return returnValue; \
}

#define CSIIMJAssert(condition, desc) CSIIMJAssert2(condition, desc, )

#define CSIIMJAssertParamNotNil2(param, returnValue) \
CSIIMJAssert2(param, [[NSString stringWithFormat:@#param] stringByAppendingString:@"参数不能为nil"], returnValue)

#define CSIIMJAssertParamNotNil(param) CSIIMJAssertParamNotNil2(param, )

#endif
