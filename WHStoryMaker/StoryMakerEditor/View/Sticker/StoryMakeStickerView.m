//
//  StoryMakeStickerView.m
//  GetZSCStoryMaker
//
//  Created by whbalzac on 09/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import "StoryMakeStickerView.h"
#import "StoryMakeStickerFootSingleViewController.h"
#import "StoryMakerFontManager.h"

@interface StoryMakeStickerView () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, StoryMakeStickerFootSingleViewControllerDelegate>

@property (nonatomic, strong) UIView *topGestureView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIVisualEffectView *blurEffectView;

@property (nonatomic, strong) UILabel *vcTitleLabel;
@property (nonatomic, assign) StoryMakeStickerFootSingleType currentIndex;
@property (nonatomic, strong) StoryMakeStickerFootSingleViewController  *nextViewController;
@property (nonatomic, strong) NSArray <UIViewController *> *viewControllerArray;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation StoryMakeStickerView

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
    UITapGestureRecognizer *getsture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideStickerFooterView)];
    self.userInteractionEnabled = YES;
    [self.topGestureView addGestureRecognizer:getsture];
    
    [self addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).offset(SCREENAPPLYHEIGHT(15));
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(SCREENAPPLYHEIGHT(415));
    }];
    
    [self addSubview:self.topGestureView];
    [self.topGestureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.maskView.mas_top);
        make.left.right.top.mas_equalTo(self);
    }];
    
    [self.maskView addSubview:self.blurEffectView];
    [self.blurEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.maskView);
        make.height.mas_equalTo(SCREENAPPLYHEIGHT(400));
    }];
    
    [self addSubview:self.vcTitleLabel];
    [self.vcTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.maskView).offset(SCREENAPPLYHEIGHT(14));
        make.left.mas_equalTo(self.maskView).offset(SCREENAPPLYHEIGHT(20));
        make.height.mas_equalTo(SCREENAPPLYHEIGHT(22));
    }];
    
    [self addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.maskView).offset(SCREENAPPLYHEIGHT(50));
        make.left.right.mas_equalTo(self.maskView);
        make.height.mas_equalTo(SCREENAPPLYHEIGHT(350));
    }];
    
    [self addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.blurEffectView.mas_top).offset(SCREENAPPLYHEIGHT(8));
        make.width.mas_equalTo(SCREENAPPLYHEIGHT(40));
        make.height.mas_equalTo(SCREENAPPLYHEIGHT(4));
    }];
    
    [self addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.blurEffectView.mas_top).offset(SCREENAPPLYHEIGHT(22));
        make.width.mas_equalTo(SCREENAPPLYHEIGHT(36));
        make.height.mas_equalTo(SCREENAPPLYHEIGHT(8));
    }];
    
}


#pragma mark -
#pragma mark - Private method

- (void)hideStickerFooterView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = CGPointMake(self.center.x, self.center.y + SCREENAPPLYHEIGHT(667));
                     } completion:^(BOOL finished) {
                         self.hidden = YES;
                     }];
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSInteger index = [self.viewControllerArray indexOfObject:(StoryMakeStickerFootSingleViewController *)viewController];
    if (NSNotFound == index || StoryMakeStickerFootSingleTypeIndex0 == index) {
        return nil;
    }
    else{
        return self.viewControllerArray[index - 1];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSInteger index = [self.viewControllerArray indexOfObject:(StoryMakeStickerFootSingleViewController *)viewController];
    if (NSNotFound == index || StoryMakeStickerFootSingleTypeIndex2 == index) {
        return nil;
    }
    else{
        return self.viewControllerArray[index + 1];
    }
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    
    self.nextViewController = (StoryMakeStickerFootSingleViewController *)pendingViewControllers.firstObject;
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed{
    
    if (finished) {
        NSInteger index = [self.viewControllerArray indexOfObject:self.nextViewController];
        self.pageControl.currentPage = index;
    } else {
        self.nextViewController = (StoryMakeStickerFootSingleViewController *)previousViewControllers.firstObject;
    }
}


#pragma mark -
#pragma mark - StoryMakeStickerFootSingleViewControllerDelegate
- (void)singleViewControllerDidSelectedImage:(UIImage *)image
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(stickerViewDidSelectedImage:)]) {
        [self.delegate stickerViewDidSelectedImage:image];
    }
}

#pragma mark -
#pragma mark - Getter

- (UIVisualEffectView *)blurEffectView
{
    if (!_blurEffectView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    }
    return _blurEffectView;
}

- (UIView *)topGestureView
{
    if (!_topGestureView) {
        _topGestureView = [[UIView alloc] init];
        _topGestureView.backgroundColor = [UIColor clearColor];
    }
    return _topGestureView;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.layer.masksToBounds = YES;
        _maskView.layer.cornerRadius = SCREENAPPLYHEIGHT(12);
    }
    return _maskView;
}

- (NSArray<UIViewController *> *)viewControllerArray
{
    if (!_viewControllerArray) {
        
        NSMutableArray *array = [NSMutableArray array];
        NSInteger i;
        for (i = 0; i < StoryMakeStickerFootSingleTypeCount; ++i) {
            StoryMakeStickerFootSingleViewController *singleVC = [[StoryMakeStickerFootSingleViewController alloc] initWithType:(StoryMakeStickerFootSingleType)i];
            singleVC.delegate = self;
            [array addObject:singleVC];
            _viewControllerArray = [NSArray arrayWithArray:array];
        }
    }
    
    return _viewControllerArray;
}

- (UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc]
                               initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        [_pageViewController setViewControllers:@[self.viewControllerArray[StoryMakeStickerFootSingleTypeIndex0]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
        
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
    }
    
    return _pageViewController;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = StoryMakeStickerFootSingleTypeCount;
        _pageControl.currentPage = StoryMakeStickerFootSingleTypeIndex0;
        _pageControl.currentPageIndicatorTintColor = UIColorFromRGBA(255, 255, 255, 1.0);
        _pageControl.pageIndicatorTintColor = UIColorFromRGBA(255, 255, 255, 0.5);
    }
    return _pageControl;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = UIColorFromRGBA(255, 255, 255, 0.5);
        _topView.layer.masksToBounds = YES;
        _topView.layer.cornerRadius = SCREENAPPLYHEIGHT(2);
    }
    return _topView;
}


- (UILabel *)vcTitleLabel
{
    if (!_vcTitleLabel) {
        _vcTitleLabel = [[UILabel alloc] init];
        _vcTitleLabel.textColor = [UIColor whiteColor];
        _vcTitleLabel.font = [StoryMakerFontManager getFontFutura:SCREENAPPLYHEIGHT(16)];
        _vcTitleLabel.textAlignment = NSTextAlignmentLeft;
        _vcTitleLabel.text = @"Cartoon";
    }
    return _vcTitleLabel;
}

@end
