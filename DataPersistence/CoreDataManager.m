//
//  CoreDataManager.m
//  DataPersistence
//
//  Created by ma c on 2016/11/5.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

static CoreDataManager *manager = nil;
+ (CoreDataManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CoreDataManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        //添加观察者,当managedObjectContext发生变化时调用saveContext方法
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveContext) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
    }
    return self;
}
// 如果是想做更新操作：只要在更改了实体对象的属性后调用[context save:&error]，就能将更改的数据同步到数据库
- (void)saveContext {
    NSLog(@"save");
    [self.managedObjectContext save:nil];
}


#pragma mark -- Core Data stack
//document路径
- (NSURL *)applicationDocumentDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//1.初始化NSManagedObjectModel对象，加载模型文件，读取app中的所有实体信息
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel == nil) {
        //获取app中CoreData.xcdatamodeld的路径
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreData" withExtension:@"momd"];
        //传入路径,初始化managerObjectModel
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

//2.初始化NSPersistentStoreCoordinator对象，添加持久化库(这里采取SQLite数据库)
- (NSPersistentStoreCoordinator *)persistentStoreCoordiantor {
    if (_persistentStoreCoordiantor == nil) {
        //传入managerObjectModel对象,初始化persistentstoreCoredinator
        _persistentStoreCoordiantor = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        //构建SQLite数据库文件的路径
        NSURL *storeURL = [[self applicationDocumentDirectory] URLByAppendingPathComponent:@"CoreData.sqlite"];
        //添加持久存储库,这里使用SQLite作为存储库
        NSError *error = nil;
        NSPersistentStore *store = [_persistentStoreCoordiantor addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSInferMappingModelAutomaticallyOption: @YES, NSMigratePersistentStoresAutomaticallyOption : @YES} error:&error];
        if (store == nil) {
            [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
        }
        
    }
    return _persistentStoreCoordiantor;
}

//3.初始化上下文,设置persistentStorecoordinator属性
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext == nil) {
        //初始化上下文managerObjectContext,设置并发类型
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        //为上下文设置persistentStorecoordinator属性
        [_managedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordiantor]];
    }
    return _managedObjectContext;
}







@end
