//
//  StoryMakeToolsView.m
//  GetZSCStoryMaker
//
//  Created by whbalzac on 09/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import "StoryMakeToolsView.h"

@interface StoryMakeToolsView ()

@property (nonatomic, strong) UIButton *stickerBtn;
@property (nonatomic, strong) UIButton *drawBtn;
@property (nonatomic, strong) UIButton *writeBtn;
@property (nonatomic, strong) UIButton *fiterBtn;

@end

@implementation StoryMakeToolsView

- (instancetype)init
{
    if (self = [super init]) {
        [self configureView];
    }
    return self;
}

#pragma mark -
#pragma mark - configure

- (void)configureView
{
    [self addSubview:self.stickerBtn];
    [self.stickerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.centerX.mas_equalTo(self).offset(-SCREENAPPLYHEIGHT(108));
        make.height.width.mas_equalTo(SCREENAPPLYHEIGHT(40));
    }];
    
    [self addSubview:self.drawBtn];
    [self.drawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.centerX.mas_equalTo(self).offset(-SCREENAPPLYHEIGHT(36));
        make.height.width.mas_equalTo(SCREENAPPLYHEIGHT(40));
    }];
    
    [self addSubview:self.writeBtn];
    [self.writeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.centerX.mas_equalTo(self).offset(SCREENAPPLYHEIGHT(36));
        make.height.width.mas_equalTo(SCREENAPPLYHEIGHT(40));
    }];
    
    [self addSubview:self.fiterBtn];
    [self.fiterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.centerX.mas_equalTo(self).offset(SCREENAPPLYHEIGHT(108));
        make.height.width.mas_equalTo(SCREENAPPLYHEIGHT(40));
    }];
    
}

#pragma mark -
#pragma mark - Btn Action

- (void)stickerBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(stickerBtnDidSelected)]) {
        [self.delegate stickerBtnDidSelected];
    }
}

- (void)drawBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawBtnDidSelected)]) {
        [self.delegate drawBtnDidSelected];
    }
}

- (void)writeBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(writeBtnDidSelected)]) {
        [self.delegate writeBtnDidSelected];
    }
}

- (void)filterBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterBtnDidSelected)]) {
        [self.delegate filterBtnDidSelected];
    }
}




#pragma mark -
#pragma mark - Getter

- (UIButton *)stickerBtn
{
    if (!_stickerBtn) {
        _stickerBtn = [[UIButton alloc] init];
        [_stickerBtn setImage:[UIImage imageNamed:@"story_maker_tab_sticker"] forState:UIControlStateNormal];
        _stickerBtn.layer.shadowColor = UIColorFromRGB(0, 0, 0).CGColor;
        _stickerBtn.layer.shadowOffset = CGSizeMake(0, 2);
        _stickerBtn.layer.shadowRadius = 2;
        _stickerBtn.layer.shadowOpacity = 0.3;
        [_stickerBtn addTarget:self action:@selector(stickerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stickerBtn;
}

- (UIButton *)drawBtn
{
    if (!_drawBtn) {
        _drawBtn = [[UIButton alloc] init];
        [_drawBtn setImage:[UIImage imageNamed:@"story_maker_tab_scrawl"] forState:UIControlStateNormal];
        _drawBtn.layer.shadowColor = UIColorFromRGB(0, 0, 0).CGColor;
        _drawBtn.layer.shadowOffset = CGSizeMake(0, 2);
        _drawBtn.layer.shadowRadius = 2;
        _drawBtn.layer.shadowOpacity = 0.3;
        [_drawBtn addTarget:self action:@selector(drawBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _drawBtn;
}

- (UIButton *)writeBtn
{
    if (!_writeBtn) {
        _writeBtn = [[UIButton alloc] init];
        [_writeBtn setImage:[UIImage imageNamed:@"story_maker_tab_type"] forState:UIControlStateNormal];
        _writeBtn.layer.shadowColor = UIColorFromRGB(0, 0, 0).CGColor;
        _writeBtn.layer.shadowOffset = CGSizeMake(0, 2);
        _writeBtn.layer.shadowRadius = 2;
        _writeBtn.layer.shadowOpacity = 0.3;
        [_writeBtn addTarget:self action:@selector(writeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _writeBtn;
}

- (UIButton *)fiterBtn
{
    if (!_fiterBtn) {
        _fiterBtn = [[UIButton alloc] init];
        [_fiterBtn setImage:[UIImage imageNamed:@"story_maker_tab_filter"] forState:UIControlStateNormal];
        _fiterBtn.layer.shadowColor = UIColorFromRGB(0, 0, 0).CGColor;
        _fiterBtn.layer.shadowOffset = CGSizeMake(0, 2);
        _fiterBtn.layer.shadowRadius = 2;
        _fiterBtn.layer.shadowOpacity = 0.3;
        [_fiterBtn addTarget:self action:@selector(filterBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fiterBtn;
}


@end
