//
//  dbhelper.m
//  Shanbei Homework
//
//  Created by 段昊宇 on 16/4/4.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import "dbhelper.h"
#import "dbload.h"
#import <sqlite3.h>

@implementation dbhelper
@synthesize db;
#pragma mark - sql定义查找目录
- (NSString *) findDocument {
    NSArray *document_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [document_paths objectAtIndex: 0];
    NSLog(@"Path URL: %@", path);
    return path;
}

#pragma mark - sql打开方法
- (void) open {
    NSString *path = [self findDocument];
    NSString *sqlite_path = [path stringByAppendingPathComponent: @"database.sqlite"];
    int result = sqlite3_open([sqlite_path UTF8String], &db);
    if (result != SQLITE_OK) {
        NSLog(@"sql open failed: result is %d", result);
    }
    [self loadDataTable];
}

#pragma mark - sql录入表信息
- (void) loadDataTable {
    // 创建单词表
    NSString *sql = @"CREATE TABLE IF NOT EXISTS WORD(ID INTEGER PRIMARY KEY AUTOINCREMENT,WORD TEXT,LESSON TEXT,WORDLEVEL TEXT)";
    int result = [self execSql: sql];
    if (result != SQLITE_OK) {
        NSLog(@"failed: %d", result);
    }
    
    // 创建文章表
    sql = @"CREATE TABLE IF NOT EXISTS PASSAGE(ID INTEGER PRIMARY KEY AUTOINCREMENT,CONTENT TEXT, TITLE TEXT)";
    result = [self execSql: sql];
    if (result != SQLITE_OK) {
        NSLog(@"failed: %d", result);
    }
}

#pragma mark - sql根据level进行查找
- (NSMutableArray *) queryByLevel: (NSString *)lev {
    NSString *sql = [NSString stringWithFormat: @"SELECT * FROM WORD WHERE WORDLEVEL=%@", lev];
    sqlite3_stmt *statement;
    NSMutableArray *res = [[NSMutableArray alloc] init];
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *word = (char*)sqlite3_column_text(statement, 1);
            NSString *wordStr = [[NSString alloc] initWithUTF8String: word];
            [res addObject: wordStr];
        }
    }
    return res;
}

#pragma mark - sql执行语句方法
- (int) execSql: (NSString *)sql {
    char *errorMsg;
    int result = sqlite3_exec(db,[sql UTF8String], NULL, NULL, &errorMsg);
    return result;
}

#pragma mark - 第一次静态数据导入
- (void) FirstLoad {
    NSMutableArray *open = [[NSMutableArray alloc] init];
    open = [dbload load];
    for (id sql in open) {
        int res = [self execSql: sql];
        if (res != SQLITE_OK) {
            NSLog(@"insert faild");
        }
    }
    open = [dbload load2];
    for (id sql in open) {
        int res = [self execSql: sql];
        if (res != SQLITE_OK) {
            NSLog(@"insert faild");
        }
    }
}

@end
