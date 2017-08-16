//
//  LJBaseModel.h
//  Pinaster
//
//  Created by LJ_Keith on 16/12/8.
//  Copyright © 2016年 linyoulu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LJBaseModel : NSObject<NSCopying,NSCoding>

-(void)encodeWithCoder:(NSCoder *)aCoder;

-(id)initWithCoder:(NSCoder *)aDecoder;

-(id)copyWithZone:(NSZone *)zone;

-(NSUInteger)hash;

-(BOOL)isEqual:(id)object;


@end

@interface LSDrawModel : LJBaseModel

@property (nonatomic, assign) NSInteger modelType;

@end



@interface LSPointModel : LSDrawModel

@property (nonatomic, assign) CGFloat xPoint;

@property (nonatomic, assign) CGFloat yPoint;

@property (nonatomic, assign) double timeOffset;

@end


@interface LSBrushModel : LSDrawModel

@property (nonatomic, copy) UIColor *brushColor;

@property (nonatomic, assign) CGFloat brushWidth;

@property (nonatomic, assign) NSInteger shapeType;

@property (nonatomic, assign) BOOL isEraser;

@property (nonatomic, copy) LSPointModel *beginPoint;

@property (nonatomic, copy) LSPointModel *endPoint;

@end

typedef NS_ENUM(NSInteger, LSDrawAction)
{
    LSDrawActionUnKnown = 1,
    LSDrawActionUndo,
    LSDrawActionRedo,
    LSDrawActionSave,
    LSDrawActionClean,
    LSDrawActionOther,
};

@interface LSActionModel : LSDrawModel

@property (nonatomic, assign) LSDrawAction ActionType;

@end




@interface LSDrawPackage : LJBaseModel

@property (nonatomic, strong) NSMutableArray<LSDrawModel*> *pointOrBrushArray;

@end


@interface LSDrawFile : LJBaseModel

@property (nonatomic, strong) NSMutableArray<LSDrawPackage*> *packageArray;

@end
