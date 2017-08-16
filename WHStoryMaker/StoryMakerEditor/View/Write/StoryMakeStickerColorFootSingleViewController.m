//
//  StoryMakeStickerColorFootSingleViewController.m
//  GetZSCStoryMaker
//
//  Created by whbalzac on 10/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import "StoryMakeStickerColorFootSingleViewController.h"
#import "StoryMakeStickerColorFootCollectionViewCell.h"

@interface StoryMakeStickerColorFootSingleViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) StoryMakeStickerColorFootSingleType type;

@property (nonatomic, strong) UICollectionView   *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray <UIColor *> *dataArray;

@end

@implementation StoryMakeStickerColorFootSingleViewController

- (instancetype)initWithType:(StoryMakeStickerColorFootSingleType)type
{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureData];
    [self configureView];
}

- (void)configureView
{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
}

- (void)configureData
{
    if (self.type == StoryMakeStickerColorFootSingleTypeIndex0) {
        self.dataArray = [NSArray arrayWithObjects:UIColorFromRGB(255, 255, 255),
                      UIColorFromRGB(0, 0, 0),
                      UIColorFromRGB(51, 151, 240),
                      UIColorFromRGB(112, 193, 80),
                      UIColorFromRGB(253, 203, 91),
                      UIColorFromRGB(254, 141, 53),
                      UIColorFromRGB(236, 73, 86),
                      UIColorFromRGB(208, 11, 106),
                      UIColorFromRGB(164, 7, 186),nil];
        
    }else if(self.type == StoryMakeStickerColorFootSingleTypeIndex1) {
        self.dataArray = [NSArray arrayWithObjects:UIColorFromRGB(237, 1, 16),
                      UIColorFromRGB(237, 133, 142),
                      UIColorFromRGB(255, 210, 211),
                      UIColorFromRGB(255, 219, 181),
                      UIColorFromRGB(255, 195, 129),
                      UIColorFromRGB(210, 143, 68),
                      UIColorFromRGB(154, 100, 58),
                      UIColorFromRGB(67, 36, 37),
                      UIColorFromRGB(27, 74, 41),nil];
        
    }else if(self.type == StoryMakeStickerColorFootSingleTypeIndex2) {
        self.dataArray = [NSArray arrayWithObjects:UIColorFromRGB(38, 38, 38),
                      UIColorFromRGB(54, 54, 54),
                      UIColorFromRGB(85, 85, 85),
                      UIColorFromRGB(115, 115, 115),
                      UIColorFromRGB(153, 153, 153),
                      UIColorFromRGB(178, 178, 178),
                      UIColorFromRGB(199, 199, 199),
                      UIColorFromRGB(219, 219, 219),
                      UIColorFromRGB(239, 239, 239),nil];
        
    }else{
        self.dataArray = [NSArray arrayWithObjects:UIColorFromRGB(255, 255, 255),
                      UIColorFromRGB(0, 0, 0),
                      UIColorFromRGB(51, 151, 240),
                      UIColorFromRGB(112, 193, 80),
                      UIColorFromRGB(253, 203, 91),
                      UIColorFromRGB(254, 141, 53),
                      UIColorFromRGB(236, 73, 86),
                      UIColorFromRGB(208, 11, 106),
                      UIColorFromRGB(164, 7, 186),nil];
    }
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
    StoryMakeStickerColorFootCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[StoryMakeStickerColorFootCollectionViewCell identifierForReuseCell] forIndexPath:indexPath];
    
    if (indexPath.section >= self.dataArray.count) {
        return cell;
    }
    
    cell.contentColor = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    StoryMakeStickerColorFootCollectionViewCell *cell = (StoryMakeStickerColorFootCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.contentColor && self.delegate && [self.delegate respondsToSelector:@selector(colorFootSingleViewControllerDidSelectedColor:)])
    {
        [self.delegate colorFootSingleViewControllerDidSelectedColor:cell.contentColor];
    }
}

#pragma mark -
#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[StoryMakeStickerColorFootCollectionViewCell class]
            forCellWithReuseIdentifier:[StoryMakeStickerColorFootCollectionViewCell identifierForReuseCell]];
    }
    
    return _collectionView;
}

-(UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(SCREENAPPLYSPACE(24), SCREENAPPLYSPACE(24));
        _flowLayout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return _flowLayout;
}

@end
