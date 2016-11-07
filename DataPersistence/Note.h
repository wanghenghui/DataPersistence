//
//  Note.h
//  数据持久化
//
//  Created by ma c on 2016/11/2.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, strong)NSString *content;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
