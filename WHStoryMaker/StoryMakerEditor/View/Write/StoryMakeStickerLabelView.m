//
//  StoryMakeStickerLabelView.m
//  GetZSCStoryMaker
//
//  Created by whbalzac on 11/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import "StoryMakeStickerLabelView.h"

@interface StoryMakeStickerLabelView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *seperatoeView;

@property (nonatomic, assign) CGSize labelSize;

@property (nonatomic, assign) BOOL hasShrinked;
@end

@implementation StoryMakeStickerLabelView

- (instancetype)initWithLabelHeight:(CGSize)labelSize
{
    self = [super init];
    if (self) {
        self.hasShrinked = NO;
        self.labelSize = labelSize;
    }
    return self;
}

- (void)layoutSubviews
{
    self.contentLabel.frame = CGRectMake(0, 0, self.labelSize.width, self.labelSize.height);
    self.contentLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    
    [self updateFrameForBorder];
    [self addSubview:self.seperatoeView];
    [self addSubview:self.contentLabel];
    [super layoutSubviews];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImage:)];
    pinchGesture.delegate = self;
    [self addGestureRecognizer:pinchGesture];
    
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateImage:)];
    rotationGesture.delegate = self;
    [self addGestureRecognizer:rotationGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)];
    [self addGestureRecognizer:panGesture];
    
    if (!self.hasShrinked) {
        self.contentLabel.transform = CGAffineTransformScale(self.transform, 1.0/[StoryMakeStickerLabelView shrinkRatio], 1.0/[StoryMakeStickerLabelView shrinkRatio]);
        self.hasShrinked = YES;
    }
}

- (void)updateFrameForBorder
{
    self.seperatoeView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentLabel.frame) + SCREENAPPLYHEIGHT(20), CGRectGetHeight(self.contentLabel.frame) + SCREENAPPLYHEIGHT(10));
    self.seperatoeView.center = CGPointMake(CGRectGetMidX(self.contentLabel.frame), CGRectGetMidY(self.contentLabel.frame));
    
    [super updateFrameForBorder];
}

#pragma mark -
#pragma mark - Private method

-(void)pinchImage:(UIPinchGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        self.contentLabel.transform = CGAffineTransformScale(self.transform, gesture.scale, gesture.scale);
        gesture.scale = 1;
        [self updateFrameForBorder];
    }
}

-(void)rotateImage:(UIRotationGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        self.transform = CGAffineTransformRotate(self.transform, gesture.rotation);
        [gesture setRotation:0];
    }
}

- (void)panImage:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self.superview];
        [self setCenter:(CGPoint){self.center.x + translation.x, self.center.y + translation.y}];
        [gesture setTranslation:CGPointZero inView:self.superview];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark -
#pragma mark - Private method

- (void)setIsSelected:(BOOL)isSelected
{
    [super setIsSelected:isSelected];
    if (isSelected) {
        self.seperatoeView.layer.borderColor = UIColorFromRGBA(255, 255, 255, 0.5).CGColor;
        self.seperatoeView.layer.borderWidth = 2;
    }else{
        self.seperatoeView.layer.borderWidth = 0;
    }
}

//
- (void)adjustSizeOfSelect:(CGFloat)scale
{
    [super adjustSizeOfSelect:scale];
    
    self.seperatoeView.layer.borderColor = UIColorFromRGBA(255, 255, 255, 0.5).CGColor;
    self.seperatoeView.layer.borderWidth = 2;
}

#pragma mark -
#pragma mark - Getter

- (UIView *)seperatoeView
{
    if (!_seperatoeView) {
        _seperatoeView = [[UIView alloc] init];
        _seperatoeView.layer.borderColor = UIColorFromRGBA(255, 255, 255, 0.5).CGColor;
        _seperatoeView.layer.borderWidth = 2;
    }
    return _seperatoeView;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _contentLabel;
}

@end

