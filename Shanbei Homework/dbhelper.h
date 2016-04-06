//
//  dbhelper.h
//  Shanbei Homework
//
//  Created by 段昊宇 on 16/4/4.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface dbhelper : NSObject
@property sqlite3 *db;

- (void) open;
- (void) FirstLoad;
- (void) loadDataTable;

- (NSMutableArray *) queryByLevel: (NSString *)lev;
- (NSString *) queryByWords: (NSString *) word;
- (NSMutableArray *) queryByLevelDown: (NSString *)lev;
- (NSMutableArray *) queryTitle;
- (NSString *) queryPassageById: (NSString *)Id;
- (NSMutableArray *) queryByLesson: (NSString *)Id;
@end
