//
//  Person.m
//  DataPersistence
//
//  Created by ma c on 2016/11/2.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "Person.h"

@implementation Person


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_ID forKey:@"ID"];
    [aCoder encodeObject:_name forKey:@"name"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.ID = [aDecoder decodeObjectForKey:@"ID"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    return self;
}



@end
