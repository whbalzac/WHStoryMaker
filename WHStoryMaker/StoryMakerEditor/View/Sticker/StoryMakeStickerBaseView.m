//
//  StoryMakeStickerBaseView.m
//  GetZSCStoryMaker
//
//  Created by whbalzac on 10/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import "StoryMakeStickerBaseView.h"

@interface StoryMakeStickerBaseView ()

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation StoryMakeStickerBaseView

- (instancetype)init
{
    if (self = [super init]) {
        self.isSelected = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    self.userInteractionEnabled = YES;
    
    self.closeBtn.frame = CGRectMake(0, 0, SCREENAPPLYHEIGHT(24), SCREENAPPLYHEIGHT(24));
    self.closeBtn.center = CGPointMake(CGRectGetWidth(self.frame) - SCREENAPPLYHEIGHT(12), SCREENAPPLYHEIGHT(12));
    [self addSubview:self.closeBtn];
}

#pragma mark -
#pragma mark - Btn Action

- (void)closeBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(storyMakeStickerBaseViewCloseBtnClicked:)]) {
        [self.delegate storyMakeStickerBaseViewCloseBtnClicked:self];
    }else{
        [self removeFromSuperview];
    }
}

#pragma mark -
#pragma mark - Private method

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected) {
        self.closeBtn.hidden = NO;
    }else{
        self.closeBtn.hidden = YES;
    }
}

- (void)adjustSizeOfSelect:(CGFloat)scale
{
    self.closeBtn.transform = CGAffineTransformIdentity;
}

#pragma mark -
#pragma mark - Getter

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"story_maker_close"] forState:UIControlStateNormal];
        [_closeBtn setBackgroundColor:UIColorFromRGBA(0, 0, 0, 1.0)];
        _closeBtn.layer.masksToBounds = YES;
        _closeBtn.layer.cornerRadius = SCREENAPPLYHEIGHT(12);
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
