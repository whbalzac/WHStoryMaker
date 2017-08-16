//
//  LJBaseModel.m
//  Pinaster
//
//  Created by LJ_Keith on 16/12/8.
//  Copyright © 2016年 linyoulu. All rights reserved.
//

#import "LJBaseModel.h"
#import "YYModel.h"


@implementation LJBaseModel

-(void)encodeWithCoder:(NSCoder *)aCoder{

    [self yy_modelEncodeWithCoder:aCoder];

}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
    
}

-(id)copyWithZone:(NSZone *)zone{
    
    return [self yy_modelCopy];
    
}
-(NSUInteger)hash{
    
    return [self yy_modelHash];
    
}

-(BOOL)isEqual:(id)object{

    return [self yy_modelIsEqual:object];
    
}
//避开关键字
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id" : @"id",
             @"Description" : @"description",
             };
}

@end

@implementation LSDrawModel


@end

@implementation LSPointModel


@end

@implementation LSBrushModel


@end

@implementation LSActionModel


@end

@implementation LSDrawPackage


@end

@implementation LSDrawFile


@end


