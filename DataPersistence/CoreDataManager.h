//
//  CoreDataManager.h
//  DataPersistence
//
//  Created by ma c on 2016/11/5.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface CoreDataManager : NSObject

//管理对象上下文
@property (nonatomic, strong)NSManagedObjectContext *managedObjectContext;
//管理对象模型
@property (nonatomic, strong)NSManagedObjectModel *managedObjectModel;
//持久化存储调度器
@property (nonatomic, strong)NSPersistentStoreCoordinator *persistentStoreCoordiantor;

+ (CoreDataManager *)sharedManager;
- (void)saveContext;

- (NSURL *)applicationDocumentDirectory;
@end
