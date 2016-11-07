//
//  SqliteManager.m
//  DataPersistence
//
//  Created by ma c on 2016/11/3.
//  Copyright © 2016年 ma c. All rights reserved.
//

//1.创建数据库
//sqlite3_open([路径 UTF8String], &_db) != SQLITE_OK
//2.创建表
/*
    2.1 编辑建表sql语句
    @"CREATE TABLE IF NOT EXISTS 表明 ('字段' 类型, '字段' 类型, ...);
    2.2 执行建表语句
    sqlite3_exec(_db, [建表sql语句 UTF8String], NULL, NULL, &error)
    参数说明:  sqlite3指针变量db的地址,
              要执行的SQL语句,
              回调的函数,
              要回调函数的参数,
              执行出错的字符串
 */
 //3.
#import "SqliteManager.h"
#import <sqlite3.h>

@implementation SqliteManager {
    sqlite3 *_db;
}


+ (SqliteManager *)sharedManager {
    static SqliteManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        [sharedManager createDataBaseIfNeeded];
    });
    return sharedManager;
}

- (NSString *)applicationDocumentsDirectoryFile {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"data.sqlite"];
    return path;
}

//创建数据库
/*要创建数据库，需要经过如下3个步骤。
(1) 使用sqlite3_open函数打开数据库。
(2) 使用sqlite3_exec函数执行Create Table语句，创建数据库表。
(3) 使用sqlite3_close函数释放资源。
 */
- (void)createDataBaseIfNeeded {
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([writableDBPath UTF8String], &_db) != SQLITE_OK) {
        sqlite3_close(_db);
        NSAssert(NO, @"数据库打开失败");
    }else {
        char *error;
        
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS person ('ID' TEXT, 'name' TEXT);"];
        /*参数说明:  
            1.sqlite3指针变量db的地址,
            2.要执行的SQL语句,
            3.回调的函数,
            4.要回调函数的参数,
            5.执行出错的字符串
         */
        if (sqlite3_exec(_db, [createSQL UTF8String], NULL, NULL, &error) != SQLITE_OK) {
            sqlite3_close(_db);
            NSAssert(NO, @"建表失败, %s", error);
        }else {
            NSLog(@"建表成功");
        }
        sqlite3_close(_db);
    }
}


//插入数据
/*
 修改数据时，涉及的SQL语句有insert、update和delete语句，这3个SQL语句都可以带参数。修改数据 的具体步骤如下所示。
 (1) 使用sqlite3_open函数打开数据库。
 (2) 使用sqlite3_prepare_v2函数预处理SQL语句。
 (3) 使用sqlite3_bind_text函数绑定参数。
 (4) 使用sqlite3_step函数执行SQL语句。
 (5) 使用sqlite3_finalize和sqlite3_close函数释放资源。
 */
- (void)create:(Person *)model {
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &_db) != SQLITE_OK) {
        sqlite3_close(_db);
    }else {
        NSString *sqlStr = @"INSERT INTO person (ID,name) VALUES (?, ?)";
        sqlite3_stmt *statement;
        //预处理
        if (sqlite3_prepare_v2(_db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            //绑定参数
            sqlite3_bind_text(statement, 1, [model.ID UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [model.name UTF8String], -1, NULL);
            
            //执行插入
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"插入失败");
            }else {
                NSLog(@"插入成功");
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_db);
    }
}

//删除
- (void)remove:(Person *)model {
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &_db) != SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"数据库打开失败");
    }else {
        NSString *sqlStr = @"DELETE FROM person WHERE ID = ?";
        sqlite3_stmt *statement;
        //预处理
        if (sqlite3_prepare_v2(_db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            //绑定参数
            
            sqlite3_bind_text(statement, 1, [model.ID UTF8String], -1, NULL);
            //执行删除
            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"删除成功");
            }else {
                NSLog(@"删除失败");
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_db);
    }
    
}

//更新
- (void)modify:(Person *)model {
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &_db) != SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"数据库打开失败");
    }else {
        NSString *sqlStr = @"UPDATE person SET name = ? WHERE ID = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(_db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            //绑定参数
            sqlite3_bind_text(statement, 1, [model.name UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [model.ID UTF8String], -1, NULL);
            
            //执行
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSLog(@"修改失败");
            }else {
                NSLog(@"修改成功");
            }
            
        }else {
            NSLog(@"预处理失败");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_db);
    }
}


//查找所有数据
/*数据查询一般会带有查询条件，这可以使用SQL语句的where子句实现，但是在程序中需要动态绑定参数给 where子句。查询数据的具体操作步骤如下所示。
(1) 使用sqlite3_open函数打开数据库。
(2) 使用sqlite3_prepare_v2函数预处理SQL语句。
(3) 使用sqlite3_bind_text函数绑定参数。
(4) 使用sqlite3_step函数执行SQL语句，遍历结果集。
(5) 使用sqlite3_column_text等函数提取字段数据。
(6) 使用sqlite3_finalize和sqlite3_close函数释放资源。
 */

- (NSMutableArray *)findAll {
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [NSMutableArray new];
    if (sqlite3_open([path UTF8String], &_db) != SQLITE_OK) {
        sqlite3_close(_db);
        NSAssert(NO, @"数据库打开失败");
    }else {
        NSString *sqlStr = @"SELECT ID,name FROM person";
        sqlite3_stmt *statement;
        /* 参数说明:
         1.sqlite3指针变量db的地址,
         2.要执行的SQL语句,
         3.代表全部SQL字符串的最大长度,通常填"-1"
         4.sqlite3_stmt指针的地 址，它是语句对象，通过语句对象可以执行SQL语句
         5.是SQL语句没有执行的部分语句
         */
        if (sqlite3_prepare_v2(_db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *char_ID = (char *)sqlite3_column_text(statement, 0);
                NSString *ns_ID = [[NSString alloc] initWithUTF8String:char_ID];
                char *char_Name = (char *)sqlite3_column_text(statement, 1);
                NSString *ns_Name = [[NSString alloc] initWithUTF8String:char_Name];
                Person *person = [[Person alloc] init];
                person.ID = ns_ID;
                person.name = ns_Name;
                [array addObject:person];
            
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_db);
    }
    return array;
}


//根据ID查询数据
- (Person *)findByID:(NSString *)ID {
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &_db) != SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"数据打开失败");
    }else {
        
        NSString *sqlStr = @"SELECT ID,name FROM person where ID =?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(_db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            //绑定参数
            if (ID.length == 0) {
                return nil;
            }
            sqlite3_bind_text(statement, 1, [ID UTF8String], -1, NULL);
            
            //执行
            if (sqlite3_step(statement) == SQLITE_ROW) {
                char *char_ID = (char *)sqlite3_column_text(statement, 0);
                NSString *ns_ID = [[NSString alloc] initWithUTF8String:char_ID];
                char *char_Name = (char *)sqlite3_column_text(statement, 1);
                NSString *ns_Name = [[NSString alloc] initWithUTF8String:char_Name];
                
                Person *person = [[Person alloc] init];
                person.ID = ns_ID;
                person.name = ns_Name;
                sqlite3_finalize(statement);
                sqlite3_close(_db);
                
                return person;
            }else {
                NSLog(@"查找失败");
            }
        }else {
            NSLog(@"预处理失败");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_db);
    }
    return nil;
}








@end
