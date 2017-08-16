//
//  StoryMakeStickerImageView.m
//  GetZSCStoryMaker
//
//  Created by whbalzac on 09/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import "StoryMakeStickerImageView.h"

@interface StoryMakeStickerImageView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *seperatoeView;

@end

@implementation StoryMakeStickerImageView

- (void)layoutSubviews
{
    self.seperatoeView.frame = CGRectMake(0, 0, SCREENAPPLYHEIGHT(104), SCREENAPPLYHEIGHT(104));
    self.seperatoeView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    [self addSubview:self.seperatoeView];
    
    self.contentImageView.frame = CGRectMake(0, 0, SCREENAPPLYHEIGHT(100), SCREENAPPLYHEIGHT(100));
    self.contentImageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    [self addSubview:self.contentImageView];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImage:)];
    pinchGesture.delegate = self;
    [self addGestureRecognizer:pinchGesture];
    
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateImage:)];
    rotationGesture.delegate = self;
    [self addGestureRecognizer:rotationGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)];
    [self addGestureRecognizer:panGesture];
    
    [super layoutSubviews];
}

#pragma mark -
#pragma mark - Private method

-(void)pinchImage:(UIPinchGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        self.transform = CGAffineTransformScale(self.transform, gesture.scale, gesture.scale);
        gesture.scale = 1;
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

- (UIImageView *)contentImageView
{
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _contentImageView;
}

@end
