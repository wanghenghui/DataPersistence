//
//  Car+CoreDataProperties.m
//  DataPersistence
//
//  Created by ma c on 2016/11/5.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "Car+CoreDataProperties.h"

@implementation Car (CoreDataProperties)

+ (NSFetchRequest<Car *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Car"];
}

@dynamic name;
@dynamic price;

@end
