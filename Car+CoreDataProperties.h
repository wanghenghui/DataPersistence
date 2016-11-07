//
//  Car+CoreDataProperties.h
//  DataPersistence
//
//  Created by ma c on 2016/11/5.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "Car+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Car (CoreDataProperties)

+ (NSFetchRequest<Car *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) float price;

@end

NS_ASSUME_NONNULL_END
