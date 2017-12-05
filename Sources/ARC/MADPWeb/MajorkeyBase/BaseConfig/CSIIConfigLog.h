//
//  CSIIConfigLog.h
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-4-22.
//  Copyright (c) 2013年 北京科蓝软件系统股份有限公司. All rights reserved.
//

/**
 *	@brief	在Debug模式显示日志，Release模式关闭日志
 */
#ifdef DEBUG
//# define DebugLog(...) DebugLog(__VA_ARGS__)
#else
# define DebugLog(...) {}
#endif

/**
 *	@brief	在Debug模式显示日志，Release模式关闭日志，普通输出
 */
#ifdef DEBUG
#define DebugLog( s, ... ) printf( "<%s:(%d)> %s %s\n\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] cStringUsingEncoding:NSUTF8StringEncoding], __LINE__,__func__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] cStringUsingEncoding:NSUTF8StringEncoding])
#else
#define DebugLog(...) {}
#define DebugLog( s, ... )
#endif

#ifdef DEBUG
#define NSLog( s, ... ) printf( "<%s:(%d)> %s %s\n\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] cStringUsingEncoding:NSUTF8StringEncoding], __LINE__,__func__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] cStringUsingEncoding:NSUTF8StringEncoding])
#else
#define NSLog( s, ... )
#endif


//#ifdef DEBUG
//#define DebugLog( s, ... ) DebugLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
//#else
//#define DebugLog(...) {}
//#define DebugLog( s, ... )
//#endif

/**
 *	@brief	在Debug模式显示日志，Release模式关闭日志，交易信息输出
 */
#ifdef DEBUG
#ifdef LOG_TRANSACTION
#define Log_TransactionInfo( s, ... ) printf( "<%s:(%d)> %s %s\n\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] cStringUsingEncoding:NSUTF8StringEncoding], __LINE__,__func__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] cStringUsingEncoding:NSUTF8StringEncoding])
#else
#define Log_TransactionInfo( s, ... )
#endif
#else
#define Log_TransactionInfo( s, ... )
#endif

/**
 *	@brief	在Debug模式显示日志，Release模式关闭日志，页面信息输出
 */
#ifdef DEBUG
#ifdef LOG_PAGE
#define Log_PageInfo( s, ... ) printf( "<%s:(%d)> %s %s\n\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] cStringUsingEncoding:NSUTF8StringEncoding], __LINE__,__func__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] cStringUsingEncoding:NSUTF8StringEncoding])
#else
#define Log_PageInfo( s, ... )
#endif
#else
#define Log_PageInfo( s, ... )
#endif

/**
 *	@brief	在Debug模式显示日志，Release模式关闭日志，基础报文输出
 */
#ifdef DEBUG
#ifdef LOG_BASICMESSAGE
#define Log_BasicMessage( s, ... ) printf( "<%s:(%d)> %s %s\n\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] cStringUsingEncoding:NSUTF8StringEncoding], __LINE__,__func__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] cStringUsingEncoding:NSUTF8StringEncoding])
#else
#define Log_BasicMessage( s, ... )
#endif
#else
#define Log_BasicMessage( s, ... )
#endif
