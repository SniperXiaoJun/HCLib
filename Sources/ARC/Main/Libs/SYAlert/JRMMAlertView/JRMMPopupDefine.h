//
//  JRMMPopupDefine.h
//  JRMMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#ifndef JRMMPopupDefine_h
#define JRMMPopupDefine_h

#define JRMMWeakify(o)        __weak   typeof(self) mmwo = o;
#define JRMMStrongify(o)      __strong typeof(self) o = mmwo;
#define JRMMHexColor(color)   [UIColor mm_colorWithHex:color]
#define JRMM_SPLIT_WIDTH      (1/[UIScreen mainScreen].scale)

#endif /* JRMMPopupDefine_h */
