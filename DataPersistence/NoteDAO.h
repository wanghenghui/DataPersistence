//
//  Note.h
//  数据持久化
//
//  Created by ma c on 2016/11/1.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"
@interface NoteDAO : NSObject


+ (NoteDAO *)sharedManager;
- (NSString *)applicationDocumentsDirectoryFile;
- (void)createEditableCopyOfDatabaseIfNeeded;

//插入备忘录的方法
- (int)create:(Note *)model;

//删除备忘录的方法
- (int)remove:(Note *)model;

//修改备忘录的方法
- (int)modify:(Note *)model;

//查询所有数据的方法
- (NSMutableArray *)findAll;

//按照主键查询数据方法
- (Note *)findById:(NSDate *)date;

@end
