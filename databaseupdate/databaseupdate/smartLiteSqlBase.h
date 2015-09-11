//
//  smartLiteSqlBase.h
//  smartUCLite
//
//  Created by 王威 on 15/6/5.
//  Copyright (c) 2015年 Easiio. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DBPATH                @"smartLite.db"
@class smartLiteSqlBase;
@interface smartLiteSqlBase : NSObject

+(smartLiteSqlBase *)shareMyDdataBase;
@end
