//
//  CPDebug.h
//  CPPlugins
//
//  Created by liurenpeng on 10/23/15.
//  Copyright © 2015 刘任朋. All rights reserved.
//

#ifdef DEBUG
#define CPDLog(cplog, ...)                                                     \
  DebugLog((@"\n<-CPDlog->%s [Line %d]\n" cplog), __PRETTY_FUNCTION__,          \
           __LINE__, ##__VA_ARGS__)
#else
#define CPDLog(...)
#endif
#define CPALog(cplog, ...)                                                     \
  DebugLog((@"%s [Line %d] " cplog), __PRETTY_FUNCTION__, __LINE__,            \
           ##__VA_ARGS__)
