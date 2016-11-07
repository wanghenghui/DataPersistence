//
//  Note.m
//  数据持久化
//
//  Created by ma c on 2016/11/1.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "NoteDAO.h"

@implementation NoteDAO
static NoteDAO *sharedManager = nil;
+ (NoteDAO *)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        [sharedManager createEditableCopyOfDatabaseIfNeeded];
    });
    return sharedManager;
    
}

- (NSString *)applicationDocumentsDirectoryFile {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"NoteList.plist"];
//    NSLog(@"%@", path);
    return path;

}


- (void)createEditableCopyOfDatabaseIfNeeded {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
    BOOL dbExists = [fileManager fileExistsAtPath:writableDBPath];
    if (!dbExists) {
        NSLog(@"不存在");
        NSLog(@"%@", writableDBPath);
        NSArray *array = [NSArray new];
        BOOL sucess = [array writeToFile:writableDBPath atomically:YES];
        BOOL dbExists = [fileManager fileExistsAtPath:writableDBPath];
        if (sucess && dbExists) {
            NSLog(@"plist文件创建成功");
        }
    }else {
        NSLog(@"存在");
    }
    
}

- (int)create:(Note *)model {
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[[dateFormatter stringFromDate:model.date], model.content] forKeys:@[@"date",@"content"]];
    [array addObject:dict];
    [array writeToFile:path atomically:YES];
    
    return 0;
}

- (int)remove:(Note *)model {
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    for (NSDictionary *dict in array) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        //比较日期主键是否相等
        if ([[dict objectForKey:@"date"] isEqualToString:[dateFormatter stringFromDate:model.date]]) {
            NSLog(@"删除");
            [array removeObject:dict];
            BOOL sucess = [array writeToFile:path atomically:YES];
            if (sucess) {
                NSLog(@"删除成功");
            }else {
                NSLog(@"删除失败");
            }
            break;
        }
        
    }
    return 0;
}

- (int)modify:(Note *)model {
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    for (NSDictionary *dic in array) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *date = [dateFormatter dateFromString:[dic objectForKey:@"date"]];
        NSString *content = [dic objectForKey:@"content"];
        if ([date isEqualToDate:model.date]) {
            [dic setValue:content forKey:@"content"];
            [array writeToFile:path atomically:YES];
            break;
        }
    }
    return 0;
}

- (NSMutableArray *)findAll {
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    for (NSDictionary *dic in array) {
        Note *note = [[Note alloc] initWithDict:dic];
        [listData addObject:note];
    }
    return listData;
}

- (Note *)findById:(NSDate *)date {
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    for (NSDictionary *dic in array) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //比较日期主键是否相等
        if ([dic[@"date"] isEqualToString:[dateFormatter stringFromDate:date]]) {
            Note *note = [[Note alloc] initWithDict:dic];
            return note;
        }
    }
    return nil;
}










@end
