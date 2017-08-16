//
//  StoryMakeSelectColorFooterView.m
//  GetZSCStoryMaker
//
//  Created by whbalzac on 10/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import "StoryMakeSelectColorFooterView.h"
#import "StoryMakeStickerColorFootSingleViewController.h"
#import "UIImage+imageWithColor.h"
#import "StoryMakerFontManager.h"
#import "CDPMonitorKeyboard.h"
#import "LSDrawView.h"

#define kInitailFontValue 20
#define kInitailLineWidthValue 6

@interface StoryMakeSelectColorFooterView ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource, StoryMakeStickerColorFootSingleViewControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, assign) StoryMakeStickerColorFootSingleType currentIndex;
@property (nonatomic, strong) StoryMakeStickerColorFootSingleViewController  *nextViewController;
@property (nonatomic, strong) NSArray <UIViewController *> *viewControllerArray;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) UIButton *changeSizeButton;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UISlider *sizeSlider;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) CAShapeLayer *sliderBackLayer;

@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) LSDrawView *drawView;

@end

@implementation StoryMakeSelectColorFooterView

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
    self.backgroundColor = UIColorFromRGBA(0, 0, 0, 0.8);
    
    [self addSubview:self.drawView];
    [self.drawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.drawView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(SCREENAPPLYHEIGHT(310));
    }];
    
    [self.bottomView addSubview:self.changeSizeButton];
    [self.changeSizeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(SCREENAPPLYHEIGHT(32));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-SCREENAPPLYHEIGHT(27));
        make.left.mas_equalTo(self.mas_left).offset(SCREENAPPLYHEIGHT(12));
    }];
    
    [self.bottomView.layer addSublayer:self.sliderBackLayer];
    
    [self.bottomView addSubview:self.sizeSlider];
    [self.sizeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SCREENAPPLYHEIGHT(30));
        make.width.mas_equalTo(SCREENAPPLYHEIGHT(240));
        make.centerX.mas_equalTo(self.changeSizeButton);
        make.bottom.mas_equalTo(self.changeSizeButton.mas_top).offset(-SCREENAPPLYHEIGHT(12 + 105));
    }];
    
    [self.bottomView addSubview:self.sizeLabel];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.changeSizeButton.mas_right);
        make.bottom.mas_equalTo(self.changeSizeButton.mas_top).offset(-SCREENAPPLYHEIGHT(12));
    }];
    
    [self.bottomView addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.changeSizeButton.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(SCREENAPPLYHEIGHT(56));
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(SCREENAPPLYHEIGHT(24));
    }];
    
    [self.bottomView addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-SCREENAPPLYHEIGHT(11));
        make.width.mas_equalTo(SCREENAPPLYHEIGHT(36));
        make.height.mas_equalTo(SCREENAPPLYHEIGHT(8));
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
    
    //键盘的弹起改变view视图
    [[CDPMonitorKeyboard defaultMonitorKeyboard] sendValueWithSuperView:self.bottomView
                                                     higherThanKeyboard:SCREENAPPLYHEIGHT(185)
                                                                andMode:CDPMonitorKeyboardDefaultMode
                                          navigationControllerTopHeight:SCREENAPPLYHEIGHT(185)];
}

- (void)dealloc
{
    [[CDPMonitorKeyboard defaultMonitorKeyboard] clearAll];
}

#pragma mark -
#pragma mark - Public method

- (void)setType:(StoryMakeSelectColorFooterViewType)type
{
    _type = type;
    
    if (self.type == StoryMakeSelectColorFooterViewTypeWriting) {
        self.drawView.isIgnoreTouch = YES;
    }else if (self.type == StoryMakeSelectColorFooterViewTypeDrawing) {
        self.drawView.isIgnoreTouch = NO;
    }
    
    self.sizeLabel.alpha = 0.0;
    self.sizeSlider.alpha = 0.0;
    self.sliderBackLayer.opacity = 0.0;
    [self.drawView clean];
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSInteger index = [self.viewControllerArray indexOfObject:(StoryMakeStickerColorFootSingleViewController *)viewController];
    if (NSNotFound == index || StoryMakeStickerColorFootSingleTypeIndex0 == index) {
        return nil;
    }
    else{
        return self.viewControllerArray[index - 1];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSInteger index = [self.viewControllerArray indexOfObject:(StoryMakeStickerColorFootSingleViewController *)viewController];
    if (NSNotFound == index || StoryMakeStickerColorFootSingleTypeIndex2 == index) {
        return nil;
    }
    else{
        return self.viewControllerArray[index + 1];
    }
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    
    self.nextViewController = (StoryMakeStickerColorFootSingleViewController *)pendingViewControllers.firstObject;
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed{
    
    if (finished) {
        NSInteger index = [self.viewControllerArray indexOfObject:self.nextViewController];
        self.pageControl.currentPage = index;
    } else {
        self.nextViewController = (StoryMakeStickerColorFootSingleViewController *)previousViewControllers.firstObject;
    }
}

#pragma mark -
#pragma mark - Btn action

- (void)changeSizeButtonAction:(UIButton *)btn
{
    [self.changeSizeButton setSelected:!btn.isSelected];
    if (btn.isSelected) {
        self.sizeLabel.alpha = 1.0;
        self.sizeSlider.alpha = 1.0;
        self.sliderBackLayer.opacity = 1.0;
        
        [UIView animateWithDuration:1.5
                         animations:^{
                             self.sizeLabel.alpha = 0.0;
                         }];
    }else{
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.sizeLabel.alpha = 0.0;
                             self.sizeSlider.alpha = 0.0;
                             self.sliderBackLayer.opacity = 0.0;
                         }];
    }
}

- (void)cancelBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(storyMakeSelectColorFooterViewCloseBtnClicked)]) {        
        [self.delegate storyMakeSelectColorFooterViewCloseBtnClicked];
        [self.contentTextView removeFromSuperview];
        self.contentTextView = nil;
    }
}

- (void)confirmBtnAction
{
    if (self.type == StoryMakeSelectColorFooterViewTypeWriting) {
        
        if (IsEmpty(self.contentTextView.text)) {
            [self cancelBtnAction];
            return;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(storyMakeSelectColorFooterViewConfirmBtnClicked:font:color:)]) {
            [self.delegate storyMakeSelectColorFooterViewConfirmBtnClicked:self.contentTextView.text font:self.contentTextView.font color:self.contentTextView.textColor];
            [self.contentTextView removeFromSuperview];
            self.contentTextView = nil;
        }
        
    }else if (self.type == StoryMakeSelectColorFooterViewTypeDrawing) {
        
        if ([self.drawView isDrawBoardEmpty]) {
            [self cancelBtnAction];
            return;
        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(storyMakeSelectColorFooterViewConfirmBtnClicked:)]) {
                [self.delegate storyMakeSelectColorFooterViewConfirmBtnClicked:[self.drawView getDrawBoardImage]];
            }
        }
    }
}

- (void)sliderValueChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    self.sizeLabel.text = [NSString stringWithFormat:@"%d", (int)slider.value];
    
    if (self.type == StoryMakeSelectColorFooterViewTypeWriting) {
        self.sizeLabel.font = [StoryMakerFontManager getFontFutura:(int)slider.value];
    }else if (self.type == StoryMakeSelectColorFooterViewTypeDrawing) {
        self.sizeLabel.font = [StoryMakerFontManager getFontFutura:3 * (int)slider.value];
    }
        
    self.sizeLabel.alpha = 1.0;
    [UIView animateWithDuration:1.5
                     animations:^{
                         self.sizeLabel.alpha = 0.0;
                     }];
    
    if (self.type == StoryMakeSelectColorFooterViewTypeWriting) {
        self.contentTextView.font = [StoryMakerFontManager getFontFutura:(int)slider.value];
        CGSize size = [self sizeWithString:[NSString stringWithFormat:@"%@\n",self.contentTextView.text] font:self.contentTextView.font width:CGRectGetWidth(self.contentTextView.frame)];
        if (size.height <= 200) {
            CGRect frame = self.contentTextView.frame;
            frame.size.height = size.height + SCREENAPPLYHEIGHT(10);
            self.contentTextView.frame = frame;
            self.contentTextView.center = CGPointMake(SCREENAPPLYHEIGHT(187.5), SCREENAPPLYHEIGHT(180));
        }else{
            CGRect frame = self.contentTextView.frame;
            frame.size.height = SCREENAPPLYHEIGHT(210);
            self.contentTextView.frame = frame;
            self.contentTextView.center = CGPointMake(SCREENAPPLYHEIGHT(187.5), SCREENAPPLYHEIGHT(180));
        }
    }else if (self.type == StoryMakeSelectColorFooterViewTypeDrawing) {
        self.drawView.brushWidth = (int)slider.value;
    }
}

#pragma mark -
#pragma mark - StoryMakeStickerColorFootSingleViewControllerDelegate

- (void)colorFootSingleViewControllerDidSelectedColor:(UIColor *)color
{
    if (CGColorEqualToColor(color.CGColor, UIColorFromRGB(255, 255, 255).CGColor)) {
        [self.changeSizeButton setImage:[UIImage imageNamed:@"story_maker_fontborder" withTintColor:[UIColor blackColor]] forState:UIControlStateNormal];
        [self.changeSizeButton setBackgroundColor:[UIColor whiteColor]];
    }else{
        [self.changeSizeButton setImage:[UIImage imageNamed:@"story_maker_fontborder" withTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self.changeSizeButton setBackgroundColor:color];
    }
    
    self.sizeLabel.textColor = color;
    
    if (self.type == StoryMakeSelectColorFooterViewTypeWriting) {
        self.contentTextView.textColor = color;
    }else if (self.type == StoryMakeSelectColorFooterViewTypeDrawing) {
        self.drawView.brushColor = color;
    }
}

#pragma mark -
#pragma mark - Public method

- (void)updateColorFooterViewInMainView
{
    if (self.type == StoryMakeSelectColorFooterViewTypeWriting) {
        
        self.sizeLabel.textColor = UIColorFromRGB(255, 255, 255);
        self.sizeLabel.font = [StoryMakerFontManager getFontFutura:kInitailFontValue];
        self.sizeLabel.text = [NSString stringWithFormat:@"%d",kInitailFontValue];
        self.sizeSlider.thumbTintColor = UIColorFromRGB(255, 255, 255);
        self.sizeSlider.value = kInitailFontValue;
        self.sizeSlider.minimumValue = 8;
        self.sizeSlider.maximumValue = 50;
        
        [self.changeSizeButton setImage:[UIImage imageNamed:@"story_maker_fontborder" withTintColor:[UIColor blackColor]] forState:UIControlStateNormal];
        [self.changeSizeButton setBackgroundColor:[UIColor whiteColor]];
        
        self.contentTextView = [[UITextView alloc] init];
        self.contentTextView.font = [StoryMakerFontManager getFontFutura:kInitailFontValue];
        self.contentTextView.backgroundColor = [UIColor clearColor];
        self.contentTextView.textColor = UIColorFromRGB(255, 255, 255);
        self.contentTextView.tintColor = UIColorFromRGB(255, 255, 255);
        self.contentTextView.delegate = self;
        self.contentTextView.textAlignment = NSTextAlignmentCenter;
        self.contentTextView.frame = CGRectMake(0, 0, SCREENAPPLYHEIGHT(340), SCREENAPPLYHEIGHT(30));
        self.contentTextView.center = CGPointMake(SCREENAPPLYHEIGHT(187.5), SCREENAPPLYHEIGHT(180));
        
        [self.contentTextView becomeFirstResponder];
        [self insertSubview:self.contentTextView belowSubview:self.bottomView];
        
    }else if (self.type == StoryMakeSelectColorFooterViewTypeDrawing) {
        
        self.sizeLabel.textColor = UIColorFromRGB(255, 255, 255);
        self.sizeLabel.font = [StoryMakerFontManager getFontFutura:3 * kInitailLineWidthValue];
        self.sizeLabel.text = [NSString stringWithFormat:@"%d",kInitailLineWidthValue];
        self.sizeSlider.thumbTintColor = UIColorFromRGB(255, 255, 255);
        self.sizeSlider.value = kInitailLineWidthValue;
        self.sizeSlider.minimumValue = 1;
        self.sizeSlider.maximumValue = 10;
        
        [self.changeSizeButton setImage:[UIImage imageNamed:@"story_maker_fontborder" withTintColor:[UIColor blackColor]] forState:UIControlStateNormal];
        [self.changeSizeButton setBackgroundColor:[UIColor whiteColor]];
        
        self.drawView.brushColor = UIColorFromRGB(255, 255, 255);
        self.drawView.brushWidth = kInitailLineWidthValue;
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    CGSize size = [self sizeWithString:[NSString stringWithFormat:@"%@\n",textView.text] font:textView.font width:CGRectGetWidth(textView.frame)];
    
    if (size.height <= 200) {
        CGRect frame = textView.frame;
        frame.size.height = size.height + SCREENAPPLYHEIGHT(10);
        textView.frame = frame;
        textView.center = CGPointMake(SCREENAPPLYHEIGHT(187.5), SCREENAPPLYHEIGHT(180));
    }else{
        CGRect frame = self.contentTextView.frame;
        frame.size.height = SCREENAPPLYHEIGHT(210);
        self.contentTextView.frame = frame;
        self.contentTextView.center = CGPointMake(SCREENAPPLYHEIGHT(187.5), SCREENAPPLYHEIGHT(180));
    }
    
    NSLog(@"StoryMake.ContentTexViewHeight : %f",size.height);
}

-(CGSize)sizeWithString:(NSString*)string font:(UIFont*)font width:(float)width
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 80000)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil];
    return rect.size;
}

#pragma mark -
#pragma mark - Getter

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

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

- (UIButton *)changeSizeButton
{
    if (!_changeSizeButton) {
        _changeSizeButton = [[UIButton alloc] init];
        [_changeSizeButton setImage:[UIImage imageNamed:@"story_maker_fontborder" withTintColor:[UIColor blackColor]] forState:UIControlStateNormal];
        [_changeSizeButton setBackgroundColor:[UIColor whiteColor]];
        _changeSizeButton.layer.masksToBounds = YES;
        _changeSizeButton.layer.cornerRadius = SCREENAPPLYHEIGHT(16);
        _changeSizeButton.layer.borderWidth = 1;
        _changeSizeButton.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [_changeSizeButton addTarget:self action:@selector(changeSizeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeSizeButton;
}

- (NSArray<UIViewController *> *)viewControllerArray
{
    if (!_viewControllerArray) {
        
        NSMutableArray *array = [NSMutableArray array];
        NSInteger i;
        for (i = 0; i < StoryMakeStickerColorFootSingleTypeCount; ++i) {
            StoryMakeStickerColorFootSingleViewController *singleVC = [[StoryMakeStickerColorFootSingleViewController alloc] initWithType:(StoryMakeStickerColorFootSingleType)i];
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
        
        [_pageViewController setViewControllers:@[self.viewControllerArray[StoryMakeStickerColorFootSingleTypeIndex0]]
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
        _pageControl.numberOfPages = StoryMakeStickerColorFootSingleTypeCount;
        _pageControl.currentPage = StoryMakeStickerColorFootSingleTypeIndex0;
        _pageControl.currentPageIndicatorTintColor = UIColorFromRGBA(255, 255, 255, 1.0);
        _pageControl.pageIndicatorTintColor = UIColorFromRGBA(255, 255, 255, 0.5);
    }
    return _pageControl;
}

- (UISlider *)sizeSlider
{
    if (!_sizeSlider) {
        _sizeSlider = [[UISlider alloc] init];
        _sizeSlider.transform = CGAffineTransformMakeRotation(M_PI * 1.5);
        _sizeSlider.thumbTintColor = UIColorFromRGB(255, 255, 255);
        _sizeSlider.minimumTrackTintColor = [UIColor clearColor];
        _sizeSlider.maximumTrackTintColor = [UIColor clearColor];
        _sizeSlider.minimumValue = 8;
        _sizeSlider.maximumValue = 50;
        _sizeSlider.value = kInitailFontValue;
        _sizeSlider.continuous = NO;
        _sizeSlider.alpha = 0.0;
        
         [_sizeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _sizeSlider;
}

- (UILabel *)sizeLabel {
    if(!_sizeLabel) {
        _sizeLabel = [[UILabel alloc] init];
        _sizeLabel.text = [NSString stringWithFormat:@"%d",kInitailFontValue];
        _sizeLabel.textColor = [UIColor whiteColor];
        _sizeLabel.font = [StoryMakerFontManager getFontFutura:kInitailFontValue];
        _sizeLabel.textAlignment = NSTextAlignmentCenter;
        
        _sizeLabel.layer.masksToBounds = YES;
        _sizeLabel.layer.cornerRadius = _sizeLabel.frame.size.height / 2;
        _sizeLabel.alpha = 0.0;
    }
    return _sizeLabel;
}

- (CAShapeLayer *)sliderBackLayer
{
    if (!_sliderBackLayer) {
        _sliderBackLayer = [CAShapeLayer layer];
        _sliderBackLayer.frame = CGRectMake(0, 0, SCREENAPPLYHEIGHT(6), SCREENAPPLYHEIGHT(240));
        _sliderBackLayer.position = CGPointMake(SCREENAPPLYHEIGHT(28), SCREENAPPLYHEIGHT(120));
        
        UIBezierPath *path = [[UIBezierPath alloc] init];
//        [path moveToPoint:CGPointMake(CGRectGetMinX(_sliderBackLayer.bounds), CGRectGetMinY(_sliderBackLayer.bounds))];
//        [path addLineToPoint:CGPointMake(CGRectGetMaxX(_sliderBackLayer.bounds), CGRectGetMinY(_sliderBackLayer.bounds))];
//        [path addLineToPoint:CGPointMake(CGRectGetMidX(_sliderBackLayer.bounds), CGRectGetMaxY(_sliderBackLayer.bounds))];
//        [path addLineToPoint:CGPointMake(CGRectGetMinX(_sliderBackLayer.bounds), CGRectGetMinY(_sliderBackLayer.bounds))];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(6, 0)];
        [path addLineToPoint:CGPointMake(3, 240)];
        [path addLineToPoint:CGPointMake(0, 0)];
         _sliderBackLayer.fillColor = UIColorFromRGBA(255, 255, 255, 0.5).CGColor;
        _sliderBackLayer.lineJoin = kCALineJoinRound;
        _sliderBackLayer.lineCap = kCALineCapRound;
        _sliderBackLayer.path = path.CGPath;
        _sliderBackLayer.opacity = 0.0;
    }
    return _sliderBackLayer;
}

- (LSDrawView *)drawView
{
    if (!_drawView) {
        _drawView = [[LSDrawView alloc] init];
        _drawView.brushColor = UIColorFromRGB(255, 255, 255);
        _drawView.brushWidth = kInitailLineWidthValue;
        _drawView.shapeType = LSShapeCurve;
    }
    return _drawView;
}

@end
