//
//  Note.m
//  数据持久化
//
//  Created by ma c on 2016/11/2.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "Note.h"

@implementation Note

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        self.date = [dateFormatter dateFromString:dict[@"date"]];
        self.content = [NSString stringWithFormat:@"时间:%@", dict[@"content"]];
    }
    return self;
}

@end
