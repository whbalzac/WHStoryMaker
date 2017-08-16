//
//  LSDrawView.h
//  LSDrawTest
//
//  Created by linyoulu on 2017/2/7.
//  Copyright © 2017年 linyoulu. All rights reserved.
//



/*
 这个demo主要是参考了下面两个项目
 
 https://github.com/WillieWu/HBDrawingBoardDemo
 
 https://github.com/Nicejinux/NXDrawKit
 
 也针对这两个demo做了相应的优化
 
 
 结构：由上至下
 
 1、最上层的UIView(LSCanvas)
 使用CAShapeLayer，提高绘制时的效率
 
 2、第二层的UIImageview是用来合成LSCanvas用的
 
 这样画很多次的时候，也不会占用很高的cpu
 
 3、第三层是UIImageview，是用来放背景图的
 
 ps:
 没使用drawrect
 
 关于录制脚本：
 1、//linyl 标记的代码都是跟录制脚本和绘制脚本相关
 2、录制后需要重新跑程序，因为这只是个demo
 
 还需要优化的地方：
 1、当前的记录方式是用归档的方式，每次有动作（撤销，重做，保存，清空）和每次的touchsend
 后，都会记录成一个LSDrawPackage对象，如果想使用socket时，这里可以改为每0.5秒一个LSDrawPackage对象
 ，也就是说，每个LSDrawPackage对象都是一段时间内的绘制和操作。
 
 2、线程处理
    demo中使用的是performselector的方式，这里还需要优化。
 
 3、当前的绘制端和显示端公用了很多的内部结构
 
 */

#import <UIKit/UIKit.h>

#define MAX_UNDO_COUNT   10

#define LSDEF_BRUSH_COLOR [UIColor colorWithRed:255 green:0 blue:0 alpha:1.0]

#define LSDEF_BRUSH_WIDTH 3

#define LSDEF_BRUSH_SHAPE LSShapeCurve

//画笔形状
typedef NS_ENUM(NSInteger, LSShapeType)
{
    LSShapeCurve = 0,//曲线(默认)
    LSShapeLine,//直线
    LSShapeEllipse,//椭圆
    LSShapeRect,//矩形
    
};
/////////////////////////////////////////////////////////////////////

//封装的画笔类
@interface LSBrush: NSObject

//画笔颜色
@property (nonatomic, strong) UIColor *brushColor;

//画笔宽度
@property (nonatomic, assign) NSInteger brushWidth;

//是否是橡皮擦
@property (nonatomic, assign) BOOL isEraser;

//形状
@property (nonatomic, assign) LSShapeType shapeType;

//路径
@property (nonatomic, strong) UIBezierPath *bezierPath;

//起点
@property (nonatomic, assign) CGPoint beginPoint;
//终点
@property (nonatomic, assign) CGPoint endPoint;

@end

////////////////////////////////////////////////////////////////////



@interface LSCanvas : UIView

- (void)setBrush:(LSBrush *)brush;

@end
/////////////////////////////////////////////////////////////////////

@interface LSDrawView : UIView

//颜色
@property (strong, nonatomic) UIColor *brushColor;
//是否是橡皮擦
@property (assign, nonatomic) BOOL isEraser;
//宽度
@property (assign, nonatomic) NSInteger brushWidth;
//形状
@property (assign, nonatomic) LSShapeType shapeType;
//背景图
@property (assign, nonatomic) UIImage *backgroundImage;

@property (assign, nonatomic) BOOL isIgnoreTouch;

//撤销
- (void)unDo;
//重做
- (void)reDo;
//保存到相册
- (void)save;
//清除绘制
- (void)clean;


//录制脚本
- (void)testRecToFile;
//绘制脚本
- (void)testPlayFromFile;

// StoryMake
- (BOOL)isDrawBoardEmpty;
- (UIImage *)getDrawBoardImage;

@end
