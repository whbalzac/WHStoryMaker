//
//  StoryMakeFilterFooterView.m
//  GetZSCStoryMaker
//
//  Created by whbalzac on 11/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import "StoryMakeFilterFooterView.h"
#import "StoryMakeFooterFilterCell.h"
#import "StoryMakerFontManager.h"
#import "ImageUtil.h"
#import "ColorMatrix.h"

@interface StoryMakeFilterFooterView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIImageView *drawImgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UICollectionView   *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray <UIImage *> *dataArray;
@property (nonatomic, strong) NSArray <NSString *> *filterNameArray;

@end

@implementation StoryMakeFilterFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView
{
    [self addSubview:self.drawImgView];
    [self.drawImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(SCREENAPPLYHEIGHT(100));
    }];
    
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_top).offset(SCREENAPPLYHEIGHT(31));
        make.left.mas_equalTo(self.mas_left).offset(SCREENAPPLYHEIGHT(10));
        make.height.mas_equalTo(SCREENAPPLYHEIGHT(48));
        make.width.mas_equalTo(SCREENAPPLYHEIGHT(70));
    }];
    
    [self addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_top).offset(SCREENAPPLYHEIGHT(31));
        make.right.mas_equalTo(self.mas_right).offset(-SCREENAPPLYHEIGHT(6));
        make.height.mas_equalTo(SCREENAPPLYHEIGHT(48));
        make.width.mas_equalTo(SCREENAPPLYHEIGHT(60));
    }];
}

- (void)configureData:(UIImage *)image
{
    self.filterNameArray = [NSArray arrayWithObjects:@"Normal", @"LOMO", @"黑白", @"哥特", @"复古", @"锐化", @"淡雅", @"酒红", @"清宁", @"浪漫", @"光晕", @"蓝调", @"梦幻", @"夜色",nil];
    
    self.dataArray = @[image,
                       [ImageUtil imageWithImage:image withColorMatrix:colormatrix_lomo],
                       [ImageUtil imageWithImage:image withColorMatrix:colormatrix_heibai],
                       [ImageUtil imageWithImage:image withColorMatrix:colormatrix_huajiu],
                       [ImageUtil imageWithImage:image withColorMatrix:colormatrix_gete],
                       [ImageUtil imageWithImage:image withColorMatrix:colormatrix_ruise],
                       [ImageUtil imageWithImage:image withColorMatrix:colormatrix_danya],
                       [ImageUtil imageWithImage:image withColorMatrix:colormatrix_jiuhong],
                       [ImageUtil imageWithImage:image withColorMatrix:colormatrix_qingning],
                       [ImageUtil imageWithImage:image withColorMatrix:colormatrix_langman],
                       [ImageUtil imageWithImage:image withColorMatrix:colormatrix_guangyun],
                       [ImageUtil imageWithImage:image withColorMatrix:colormatrix_landiao],
                       [ImageUtil imageWithImage:image withColorMatrix:colormatrix_menghuan],
                       [ImageUtil imageWithImage:image withColorMatrix:colormatrix_yese]];
    
}

- (void)updateFilterViewWithImage:(UIImage *)image
{
    self.drawImgView.image = image;
    [self configureData:image];
    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StoryMakeFooterFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[StoryMakeFooterFilterCell identifierForReuseCell] forIndexPath:indexPath];
    
    if (indexPath.section >= self.dataArray.count) {
        return cell;
    }
    
    cell.imageView.image = self.dataArray[indexPath.row];
    cell.filterNameLabel.text = self.filterNameArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    StoryMakeFooterFilterCell *cell = (StoryMakeFooterFilterCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.imageView.image) {
        self.drawImgView.image = cell.imageView.image;
    }
}


#pragma mark -
#pragma mark - Btn action

- (void)cancelBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(storyMakeFilterFooterViewCloseBtnClicked)]) {
        [self.delegate storyMakeFilterFooterViewCloseBtnClicked];
    }
}

- (void)confirmBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(storyMakeFilterFooterViewConfirmBtnClicked:)]) {
        [self.delegate storyMakeFilterFooterViewConfirmBtnClicked:self.drawImgView.image];
    }
}

#pragma mark -
#pragma mark - Getter

- (UIImageView *)drawImgView
{
    if (!_drawImgView) {
        _drawImgView = [[UIImageView alloc] init];
        _drawImgView.contentMode = UIViewContentModeScaleAspectFit;
        _drawImgView.backgroundColor = [UIColor blackColor];
        _drawImgView.userInteractionEnabled = YES;
    }
    return _drawImgView;
}

- (UIButton *)cancelBtn {
    if(!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColorFromRGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [StoryMakerFontManager getFontFutura:SCREENAPPLYHEIGHT(16)];
        _cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if(!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitle:@"Done" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:UIColorFromRGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [StoryMakerFontManager getFontFutura:SCREENAPPLYHEIGHT(16)];
        _confirmBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[StoryMakeFooterFilterCell class]
            forCellWithReuseIdentifier:[StoryMakeFooterFilterCell identifierForReuseCell]];
    }
    
    return _collectionView;
}

-(UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(SCREENAPPLYSPACE(50), SCREENAPPLYSPACE(75));
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, SCREENAPPLYSPACE(16), SCREENAPPLYSPACE(24), SCREENAPPLYSPACE(16));
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return _flowLayout;
}


@end
