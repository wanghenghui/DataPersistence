//
//  PersonDAO.h
//  DataPersistence
//
//  Created by ma c on 2016/11/2.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
@interface PersonDAO : NSObject

+ (PersonDAO *)sharedManager;
- (void)createEditableCopyOfDatabaseIfNeeded;
- (NSString *)applicationDocumentsDirectoryFile;
- (void)create:(Person *)model;
- (NSMutableArray *)findAll;
- (void)remove:(NSString *)ID;
- (void)modify:(Person *)model;
@end
