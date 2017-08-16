//
//  LSDrawView.m
//  LSDrawTest
//
//  Created by linyoulu on 2017/2/7.
//  Copyright © 2017年 linyoulu. All rights reserved.
//

#import "LSDrawView.h"

#import "LJBaseModel.h"

/////////////////////////////////////////////////////////////////////////////////////
@implementation LSBrush


@end

/////////////////////////////////////////////////////////////////////////////////////
@implementation LSCanvas

+ (Class)layerClass
{
    return ([CAShapeLayer class]);
}

- (void)setBrush:(LSBrush *)brush
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    
    shapeLayer.strokeColor = brush.brushColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineWidth = brush.brushWidth;
    
    if (!brush.isEraser)
    {
        ((CAShapeLayer *)self.layer).path = brush.bezierPath.CGPath;
    }
    
}

@end

/////////////////////////////////////////////////////////////////////////////////////

@interface LSDrawView()
{
    CGPoint pts[5];
    uint ctr;
}

//背景View
//@property (nonatomic, strong) UIImageView *bgImgView;
//画板View
@property (nonatomic, strong) LSCanvas *canvasView;
//合成View
@property (nonatomic, strong) UIImageView *composeView;
//画笔容器
@property (nonatomic, strong) NSMutableArray *brushArray;
//撤销容器
//@property (nonatomic, strong) NSMutableArray *undoArray;
//重做容器
//@property (nonatomic, strong) NSMutableArray *redoArray;


//linyl
//记录脚本用
@property (nonatomic, strong) LSDrawFile *dwawFile;

//每次touchsbegin的时间，后续为计算偏移量用
@property (nonatomic, strong) NSDate *beginDate;

//绘制脚本用
@property (nonatomic, strong) NSMutableArray *recPackageArray;

@end

@implementation LSDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _brushArray = [NSMutableArray new];
        //        _undoArray = [NSMutableArray new];
        //        _redoArray = [NSMutableArray new];
        
//        _bgImgView = [UIImageView new];
//        _bgImgView.frame = self.bounds;
//        [self addSubview:_bgImgView];
        
        _composeView = [UIImageView new];
        _composeView.frame = self.bounds;
        //        _composeView.image = [self getAlphaImg];
        [self addSubview:_composeView];
        
        _canvasView = [LSCanvas new];
        _canvasView.frame = _composeView.bounds;
        
        [_composeView addSubview:_canvasView];
        
        _brushColor = LSDEF_BRUSH_COLOR;
        _brushWidth = LSDEF_BRUSH_WIDTH;
        _isEraser = NO;
        _isIgnoreTouch = NO;
        _shapeType = LSDEF_BRUSH_SHAPE;
        
        //linyl
        _dwawFile = [LSDrawFile new];
        _dwawFile.packageArray = [NSMutableArray new];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isIgnoreTouch) {
        return;
    }
    
    CGPoint point = [[touches anyObject] locationInView:self];
    
    LSBrush *brush = [LSBrush new];
    brush.brushColor = _brushColor;
    brush.brushWidth = _brushWidth;
    brush.isEraser = _isEraser;
    brush.shapeType = _shapeType;
    brush.beginPoint = point;
    
    brush.bezierPath = [UIBezierPath new];
    [brush.bezierPath moveToPoint:point];
    
    
    [_brushArray addObject:brush];
    
    //每次画线前，都清除重做列表。
    [self cleanRedoArray];
    
    ctr = 0;
    pts[0] = point;
    
    
    //linyl
    _beginDate = [NSDate date];
    
    LSBrushModel *brushModel = [LSBrushModel new];
    brushModel.brushColor = _brushColor;
    brushModel.brushWidth = _brushWidth;
    brushModel.shapeType = _shapeType;
    brushModel.isEraser = _isEraser;
    brushModel.beginPoint = [LSPointModel new];
    brushModel.beginPoint.xPoint = point.x;
    brushModel.beginPoint.yPoint = point.y;
    brushModel.beginPoint.timeOffset = 0;
    
    
    [self addModelToPackage:brushModel];
    //linyl
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isIgnoreTouch) {
        return;
    }
    
    CGPoint point = [[touches anyObject] locationInView:self];
    
    LSBrush *brush = [_brushArray lastObject];
    
    //linyl
    LSDrawPackage *drawPackage = [_dwawFile.packageArray lastObject];
    
    LSPointModel *pointModel = [LSPointModel new];
    pointModel.xPoint = point.x;
    pointModel.yPoint = point.y;
    pointModel.timeOffset = fabs(_beginDate.timeIntervalSinceNow);
    
    [drawPackage.pointOrBrushArray addObject:pointModel];
    //linyl
    
    if (_isEraser)
    {
        [brush.bezierPath addLineToPoint:point];
        [self setEraserMode:brush];
    }
    else
    {
        switch (_shapeType)
        {
            case LSShapeCurve:
                //                [brush.bezierPath addLineToPoint:point];
                
                ctr++;
                pts[ctr] = point;
                if (ctr == 4)
                {
                    pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0);
                    
                    [brush.bezierPath moveToPoint:pts[0]];
                    [brush.bezierPath addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]];
                    pts[0] = pts[3];
                    pts[1] = pts[4];
                    ctr = 1;
                }
                
                break;
                
            case LSShapeLine:
                [brush.bezierPath removeAllPoints];
                [brush.bezierPath moveToPoint:brush.beginPoint];
                [brush.bezierPath addLineToPoint:point];
                break;
                
            case LSShapeEllipse:
                brush.bezierPath = [UIBezierPath bezierPathWithOvalInRect:[self getRectWithStartPoint:brush.beginPoint endPoint:point]];
                break;
                
            case LSShapeRect:
                
                brush.bezierPath = [UIBezierPath bezierPathWithRect:[self getRectWithStartPoint:brush.beginPoint endPoint:point]];
                break;
                
            default:
                break;
        }
    }
    
    //在画布上画线
    [_canvasView setBrush:brush];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isIgnoreTouch) {
        return;
    }
    
    uint count = ctr;
    if (count <= 4 && _shapeType == LSShapeCurve)
    {
        for (int i = 4; i > count; i--)
        {
            [self touchesMoved:touches withEvent:event];
        }
        ctr = 0;
    }
    else
    {
        [self touchesMoved:touches withEvent:event];
    }
    
    //    CGPoint point = [[touches anyObject] locationInView:self];
    //    LSBrush *brush = [_brushArray lastObject];
    //    brush.endPoint = point;
    
    //画布view与合成view 合成为一张图（使用融合卡）
    UIImage *img = [self composeBrushToImage];
    //清空画布
    [_canvasView setBrush:nil];
    //保存到存储，撤销用。
    //    [self saveTempPic:img];
    
    
    //linyl
    CGPoint point = [[touches anyObject] locationInView:self];
    
    LSBrushModel *brushModel = [LSBrushModel new];
    brushModel.brushColor = _brushColor;
    brushModel.brushWidth = _brushWidth;
    brushModel.shapeType = _shapeType;
    brushModel.isEraser = _isEraser;
    brushModel.endPoint = [LSPointModel new];
    brushModel.endPoint.xPoint = point.x;
    brushModel.endPoint.yPoint = point.y;
    brushModel.endPoint.timeOffset = fabs(_beginDate.timeIntervalSinceNow);;
    
    LSDrawPackage *drawPackage = [_dwawFile.packageArray lastObject];
    
    [drawPackage.pointOrBrushArray addObject:brushModel];
    
    //    NSLog(@"end-offset:%f",brushModel.endPoint.timeOffset);
    //linyl
    
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isIgnoreTouch) {
        return;
    }
    
    [self touchesEnded:touches withEvent:event];
}

- (CGRect)getRectWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    CGFloat x = startPoint.x <= endPoint.x ? startPoint.x: endPoint.x;
    CGFloat y = startPoint.y <= endPoint.y ? startPoint.y : endPoint.y;
    CGFloat width = fabs(startPoint.x - endPoint.x);
    CGFloat height = fabs(startPoint.y - endPoint.y);
    
    return CGRectMake(x , y , width, height);
}

- (UIImage *)composeBrushToImage
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_composeView.layer renderInContext:context];
    
    UIImage *getImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _composeView.image = getImage;
    
    return getImage;
    
}

- (void)save
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:context];
    
    UIImage *getImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIImageWriteToSavedPhotosAlbum(getImage, nil, nil, nil);
    UIGraphicsEndImageContext();
    
    //linyl
    LSActionModel *actionModel = [LSActionModel new];
    actionModel.ActionType = LSDrawActionSave;
    
    [self addModelToPackage:actionModel];
    //linyl
}

- (void)setEraserMode:(LSBrush*)brush
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0);
    
    [_composeView.image drawInRect:self.bounds];
    
    [[UIColor clearColor] set];
    
    brush.bezierPath.lineWidth = _brushWidth;
    [brush.bezierPath strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
    
    [brush.bezierPath stroke];
    
    _composeView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}




- (void)clean
{
    _composeView.image = nil;
    
    [_brushArray removeAllObjects];
    
    //删除存储的文件
    [self cleanUndoArray];
    [self cleanRedoArray];
    
    
    //linyl
    LSActionModel *actionModel = [LSActionModel new];
    actionModel.ActionType = LSDrawActionClean;
    
    [self addModelToPackage:actionModel];
    //linyl
}

- (void)saveTempPic:(UIImage*)img
{
    //    if (img)
    //    {
    //        //这里切换线程处理
    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //
    //            NSDate *date = [NSDate date];
    //            NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    //            [dateformatter setDateFormat:@"HHmmssSSS"];
    //            NSString *now = [dateformatter stringFromDate:date];
    //
    //            NSString *picPath = [NSString stringWithFormat:@"%@%@",[NSHomeDirectory() stringByAppendingFormat:@"/tmp/"], now];
    //            NSLog(@"存贮于   = %@",picPath);
    //
    //            BOOL bSucc = NO;
    //            NSData *imgData = UIImagePNGRepresentation(img);
    //
    //
    //            if (imgData)
    //            {
    //                bSucc = [imgData writeToFile:picPath atomically:YES];
    //            }
    //
    //
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //
    //                if (bSucc)
    //                {
    //                    [_undoArray addObject:picPath];
    //                }
    //
    //            });
    //        });
    //    }
}

- (void)unDo
{
    //    if (_undoArray.count > 0)
    //    {
    //        NSString *lastPath = [_undoArray lastObject];
    //
    //        [_undoArray removeLastObject];
    //
    //        [_redoArray addObject:lastPath];
    //
    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //
    //            UIImage *unDoImage = nil;
    //            if (_undoArray.count > 0)
    //            {
    //                NSString *unDoPicStr = [_undoArray lastObject];
    //                NSData *imgData = [NSData dataWithContentsOfFile:unDoPicStr];
    //                if (imgData)
    //                {
    //                    unDoImage = [UIImage imageWithData:imgData];
    //                }
    //            }
    //
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //
    //                _composeView.image = unDoImage;
    //
    //            });
    //        });
    //
    //        //linyl
    //        LSActionModel *actionModel = [LSActionModel new];
    //        actionModel.ActionType = LSDrawActionUndo;
    //
    //        [self addModelToPackage:actionModel];
    //        //linyl
    //    }
}

- (void)reDo
{
    //    if (_redoArray.count > 0)
    //    {
    //        NSString *lastPath = [_redoArray lastObject];
    //        [_redoArray removeLastObject];
    //
    //        [_undoArray addObject:lastPath];
    //
    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //
    //            UIImage *unDoImage = nil;
    //            NSData *imgData = [NSData dataWithContentsOfFile:lastPath];
    //            if (imgData)
    //            {
    //                unDoImage = [UIImage imageWithData:imgData];
    //            }
    //
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //
    //                if (unDoImage)
    //                {
    //                    _composeView.image = unDoImage;
    //                }
    //            });
    //
    //        });
    //
    //        //linyl
    //        LSActionModel *actionModel = [LSActionModel new];
    //        actionModel.ActionType = LSDrawActionRedo;
    //
    //        [self addModelToPackage:actionModel];
    //        //linyl
    //    }
}

- (void)deleteTempPic:(NSString *)picPath
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    [fileManager removeItemAtPath:picPath error:nil];
}

- (void)cleanUndoArray
{
    //    for(NSString *picPath in _undoArray)
    //    {
    //        [self deleteTempPic:picPath];
    //    }
    //
    //    [_undoArray removeAllObjects];
}

- (void)cleanRedoArray
{
    //    for(NSString *picPath in _redoArray)
    //    {
    //        [self deleteTempPic:picPath];
    //    }
    //
    //    [_redoArray removeAllObjects];
}

- (void)dealloc
{
    [self clean];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (backgroundImage)
    {
//        _bgImgView.image = backgroundImage;
    }
}

- (void)layoutSubviews
{
//    _bgImgView.frame = self.bounds;
    _composeView.frame = self.bounds;
    _canvasView.frame = self.bounds;
}



//linyl
- (void)drawNextPackage
{
    if(!_recPackageArray)
    {
        NSString *filePath = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(), @"drawFile"];
        LSDrawFile *drawFile = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (drawFile)
        {
            _recPackageArray = drawFile.packageArray;
        }
    }
    
    if (_recPackageArray.count > 0)
    {
        LSDrawPackage *pack = [_recPackageArray firstObject];
        [_recPackageArray removeObjectAtIndex:0];
        
        for (LSDrawModel *drawModel in pack.pointOrBrushArray)
        {
            if (drawModel)
            {
                
                //                dispatch_async(dispatch_get_main_queue(), ^{
                
                double packageOffset = 0.0;
                if ([drawModel isKindOfClass:[LSPointModel class]])
                {
                    LSPointModel *pointModel = (LSPointModel *)drawModel;
                    [self performSelector:@selector(drawWithPointModel:) withObject:drawModel afterDelay:pointModel.timeOffset];
                }
                else if([drawModel isKindOfClass:[LSBrushModel class]])
                {
                    LSBrushModel *brushModel = (LSBrushModel*)drawModel;
                    
                    if (brushModel.beginPoint)
                    {
                        packageOffset = brushModel.beginPoint.timeOffset;
                    }
                    else
                    {
                        packageOffset = brushModel.endPoint.timeOffset;
                    }
                    [self performSelector:@selector(drawWithBrushModel:) withObject:drawModel afterDelay:packageOffset];
                }
                else if([drawModel isKindOfClass:[LSActionModel class]])
                {
                    LSActionModel *actionModel = (LSActionModel*)drawModel;
                    switch (actionModel.ActionType)
                    {
                        case LSDrawActionRedo:
                            [self performSelector:@selector(actionReDo) withObject:nil afterDelay:0.5];
                            break;
                            
                        case LSDrawActionUndo:
                            [self performSelector:@selector(actionUnDo) withObject:nil afterDelay:0.5];
                            break;
                        case LSDrawActionSave:
                            [self performSelector:@selector(actionSave) withObject:nil afterDelay:0.5];
                            break;
                        case LSDrawActionClean:
                            [self performSelector:@selector(actionClean) withObject:nil afterDelay:0.5];
                            break;
                            
                        default:
                            break;
                    }
                }
                
                
                //                });
                
                
            }
        }
    }
}

- (void)drawWithBrushModel:(LSDrawModel*)drawModel
{
    LSBrushModel *brushModel = (LSBrushModel*)drawModel;
    if (brushModel.beginPoint)
    {
        [self setDrawingBrush:brushModel];
        [self drawBeginPoint:CGPointMake(brushModel.beginPoint.xPoint, brushModel.beginPoint.yPoint)];
    }
    else
    {
        [self drawEndPoint:CGPointMake(brushModel.endPoint.xPoint, brushModel.endPoint.yPoint)];
    }
}


- (void)drawWithPointModel:(LSDrawModel*)drawModel
{
    LSPointModel *pointModel = (LSPointModel*)drawModel;
    [self drawMovePoint:CGPointMake(pointModel.xPoint, pointModel.yPoint)];
}

- (void)setDrawingBrush:(LSBrushModel*) brushModel
{
    
    if (brushModel)
    {
        _brushColor = brushModel.brushColor;
        _brushWidth = brushModel.brushWidth;
        _shapeType  = brushModel.shapeType;
        _isEraser   = brushModel.isEraser;
    }
    
}

- (void)drawBeginPoint:(CGPoint) point
{
    //    NSLog(@"drawBeginPoint");
    LSBrush *brush = [LSBrush new];
    brush.brushColor = _brushColor;
    brush.brushWidth = _brushWidth;
    brush.isEraser = _isEraser;
    brush.shapeType = _shapeType;
    brush.beginPoint = point;
    
    brush.bezierPath = [UIBezierPath new];
    [brush.bezierPath moveToPoint:point];
    
    
    [_brushArray addObject:brush];
    
    //每次画线前，都清除重做列表。
    //    [self cleanRedoArray];
    
    ctr = 0;
    pts[0] = point;
    
    
}

- (void)drawMovePoint:(CGPoint) point
{
    LSBrush *brush = [_brushArray lastObject];
    
    if (_isEraser)
    {
        [brush.bezierPath addLineToPoint:point];
        [self setEraserMode:brush];
    }
    else
    {
        switch (_shapeType)
        {
            case LSShapeCurve:
                
                ctr++;
                pts[ctr] = point;
                if (ctr == 4)
                {
                    pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0);
                    
                    [brush.bezierPath moveToPoint:pts[0]];
                    [brush.bezierPath addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]];
                    pts[0] = pts[3];
                    pts[1] = pts[4];
                    ctr = 1;
                }
                
                break;
                
            case LSShapeLine:
                [brush.bezierPath removeAllPoints];
                [brush.bezierPath moveToPoint:brush.beginPoint];
                [brush.bezierPath addLineToPoint:point];
                break;
                
            case LSShapeEllipse:
                brush.bezierPath = [UIBezierPath bezierPathWithOvalInRect:[self getRectWithStartPoint:brush.beginPoint endPoint:point]];
                break;
                
            case LSShapeRect:
                
                brush.bezierPath = [UIBezierPath bezierPathWithRect:[self getRectWithStartPoint:brush.beginPoint endPoint:point]];
                break;
                
            default:
                break;
        }
    }
    
    //在画布上画线
    [_canvasView setBrush:brush];
}

- (void)drawEndPoint:(CGPoint) point
{
    
    uint count = ctr;
    if (count <= 4 && _shapeType == LSShapeCurve)
    {
        for (int i = 4; i > count; i--)
        {
            [self drawMovePoint:point];
        }
        ctr = 0;
    }
    else
    {
        [self drawMovePoint:point];
    }
    
    //画布view与合成view 合成为一张图（使用融合卡）
    UIImage *img = [self composeBrushToImage];
    //清空画布
    [_canvasView setBrush:nil];
    //保存到存储，撤销用。
    //    [self saveTempPic:img];
    
    [self drawNextPackage];
}

//录制脚本
- (void)testRecToFile
{
//    NSString *filePath = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(), @"drawFile"];
//
//    NSLog(@"drawfile:%@",filePath);
//
//    BOOL bRet = [NSKeyedArchiver archiveRootObject:_dwawFile toFile:filePath];
//
//    if (bRet)
//    {
//        NSLog(@"archive Succ");
//    }
    
}
//绘制脚本
- (void)testPlayFromFile
{
//    [self drawNextPackage];
}

- (void)addModelToPackage:(LSDrawModel*)drawModel
{
    LSDrawPackage *drawPackage = [LSDrawPackage new];
    drawPackage.pointOrBrushArray = [NSMutableArray new];
    
    [drawPackage.pointOrBrushArray addObject:drawModel];
    [_dwawFile.packageArray addObject:drawPackage];
}

- (void)actionUnDo
{
    //    if (_undoArray.count > 0)
    //    {
    //        NSString *lastPath = [_undoArray lastObject];
    //
    //        [_undoArray removeLastObject];
    //
    //        [_redoArray addObject:lastPath];
    //
    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //
    //            UIImage *unDoImage = nil;
    //            if (_undoArray.count > 0)
    //            {
    //                NSString *unDoPicStr = [_undoArray lastObject];
    //                NSData *imgData = [NSData dataWithContentsOfFile:unDoPicStr];
    //                if (imgData)
    //                {
    //                    unDoImage = [UIImage imageWithData:imgData];
    //                }
    //            }
    //
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //
    //                _composeView.image = unDoImage;
    //
    //            });
    //        });
    //
    //        [self drawNextPackage];
    //    }
}

- (void)actionReDo
{
    //    if (_redoArray.count > 0)
    //    {
    //        NSString *lastPath = [_redoArray lastObject];
    //        [_redoArray removeLastObject];
    //
    //        [_undoArray addObject:lastPath];
    //
    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //
    //            UIImage *unDoImage = nil;
    //            NSData *imgData = [NSData dataWithContentsOfFile:lastPath];
    //            if (imgData)
    //            {
    //                unDoImage = [UIImage imageWithData:imgData];
    //            }
    //
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //
    //                if (unDoImage)
    //                {
    //                    _composeView.image = unDoImage;
    //                }
    //            });
    //
    //        });
    //
    //
    //        [self drawNextPackage];
    //    }
}
- (void)actionSave
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:context];
    
    UIImage *getImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIImageWriteToSavedPhotosAlbum(getImage, nil, nil, nil);
    UIGraphicsEndImageContext();
    
    [self drawNextPackage];
}

- (void)actionClean
{
    _composeView.image = nil;
    
    [_brushArray removeAllObjects];
    
    //删除存储的文件
    [self cleanUndoArray];
    [self cleanRedoArray];
    
    
    //linyl
    [self drawNextPackage];
    
}

- (BOOL)isDrawBoardEmpty
{
    if (IsEmpty(self.brushArray)) {
        return YES;
    }else{
        return NO;
    }
}

- (UIImage *)getDrawBoardImage
{
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, [UIScreen mainScreen].scale);
    [_composeView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

