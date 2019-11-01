//
//  InvestRecordModel.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/7/25.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "InvestRecordModel.h"

@implementation RecListModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dic{
    return [[self alloc] initWithDictionary:dic];
}

@end

@implementation InvestRecordModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dic{
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSArray *content = muDic[@"recList"];
    NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *contentdic in content) {
        RecListModel *model = [RecListModel modelWithDictionary:contentdic];
        [muArr addObject:model];
    }
    [muDic setObject:muArr forKey:@"recList"];
    
    return [[self alloc] initWithDictionary:muDic];
}



@end
