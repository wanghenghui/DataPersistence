//
//  PersonDAO.m
//  DataPersistence
//
//  Created by ma c on 2016/11/2.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "PersonDAO.h"

@implementation PersonDAO
static PersonDAO *sharedManager;
+ (PersonDAO *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        [sharedManager createEditableCopyOfDatabaseIfNeeded];
    });
    return sharedManager;
}


- (void)createEditableCopyOfDatabaseIfNeeded {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
    BOOL isExists = [fileManager fileExistsAtPath:writableDBPath];
    if (!isExists) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSMutableData *data = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:array forKey:@"archive_key"];
        [archiver finishEncoding];
        [data writeToFile:writableDBPath atomically:YES];
    }
}

- (NSString *)applicationDocumentsDirectoryFile {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"personList.archive"];
    return path;
}


- (void)create:(Person *)model {
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [self findAll];
    [array addObject:model];
    
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archive = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archive encodeObject:array forKey:@"archive_key"];
    [archive finishEncoding];
    BOOL sucess = [data writeToFile:path atomically:YES];
    if (sucess) {
        NSLog(@"写入成功");
    }else {
        NSLog(@"写入失败");
    }
}

- (NSMutableArray *)findAll {
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if ([data length] > 0) {
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        array = [unArchiver decodeObjectForKey:@"archive_key"];
        [unArchiver finishDecoding];
    }
    return array;
}

- (void)remove:(NSString *)ID {
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [self findAll];
    for (Person *person in array) {
        //比较ID是否相等
        if ([person.ID isEqualToString:ID]) {
            [array removeObject:person];
            
            NSMutableData *data = [NSMutableData data];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
            [archiver encodeObject:array forKey:@"archive_key"];
            [archiver finishEncoding];
            BOOL sucess = [data writeToFile:path atomically:YES];
            if (sucess) {
                NSLog(@"删除成功");
            }else {
                NSLog(@"删除失败");
            }
            break;
        }
    }
}

- (void)modify:(Person *)model {
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [self findAll];
    
    for (Person *person in array) {
        if ([person.ID isEqualToString:model.ID]) {
            person.name = model.name;
            
            NSMutableData *data = [NSMutableData data];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
            [archiver encodeObject:array forKey:@"archive_key"];
            [archiver finishEncoding];
            BOOL sucess = [data writeToFile:path atomically:YES];
            if (sucess) {
                NSLog(@"修改成功");
            }else {
                NSLog(@"修改失败");
            }
            break;
        }
    }
}













@end
