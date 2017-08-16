//
//  StoryMakeStickerFootSingleViewController.m
//  GetZSCStoryMaker
//
//  Created by whbalzac on 09/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import "StoryMakeStickerFootSingleViewController.h"
#import "StoryMakeStickerFooterCell.h"

@interface StoryMakeStickerFootSingleViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) StoryMakeStickerFootSingleType type;
@property (nonatomic, strong) UICollectionView   *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray <UIImage *> *dataArray;

@end

@implementation StoryMakeStickerFootSingleViewController

- (instancetype)initWithType:(StoryMakeStickerFootSingleType)type
{
    if (self = [super init]) {
        
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}

- (void)configureView
{
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
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
    StoryMakeStickerFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[StoryMakeStickerFooterCell identifierForReuseCell] forIndexPath:indexPath];
    
    if (indexPath.section >= self.dataArray.count) {
        return cell;
    }
    
    cell.imageView.image = self.dataArray[indexPath.row];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    StoryMakeStickerFooterCell *cell = (StoryMakeStickerFooterCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.imageView.image && self.delegate && [self.delegate respondsToSelector:@selector(singleViewControllerDidSelectedImage:)])
    {
        [self.delegate singleViewControllerDidSelectedImage:cell.imageView.image];
    }
    
}

#pragma mark -
#pragma mark - Getter

- (NSArray<UIImage *> *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"story_maker_tiezhi0"],[UIImage imageNamed:@"story_maker_tiezhi1"],[UIImage imageNamed:@"story_maker_tiezhi2"],[UIImage imageNamed:@"story_maker_tiezhi3"],[UIImage imageNamed:@"story_maker_tiezhi4"], nil];
    }
    return _dataArray;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[StoryMakeStickerFooterCell class]
            forCellWithReuseIdentifier:[StoryMakeStickerFooterCell identifierForReuseCell]];
    }
    
    return _collectionView;
}

-(UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(SCREENAPPLYSPACE(100), SCREENAPPLYSPACE(100));
        _flowLayout.sectionInset = UIEdgeInsetsMake(SCREENAPPLYSPACE(4), SCREENAPPLYSPACE(18), SCREENAPPLYSPACE(4), SCREENAPPLYSPACE(18));
        _flowLayout.minimumLineSpacing = SCREENAPPLYSPACE(18);
    }
    
    return _flowLayout;
}

@end
