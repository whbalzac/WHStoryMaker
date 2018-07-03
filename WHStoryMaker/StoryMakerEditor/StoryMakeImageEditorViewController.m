//
//  StoryMakeImageEditorViewController.m
//  GetZSCStoryMaker
//
//  Created by whbalzac on 09/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import "StoryMakeImageEditorViewController.h"
#import "StoryMakerFontManager.h"
#import "UIImage+imageWithColor.h"
#import "StoryMakeToolsView.h"
#import "StoryMakeStickerView.h"
#import "StoryMakeStickerImageView.h"
#import "StoryMakeSelectColorFooterView.h"
#import "StoryMakeStickerLabelView.h"
#import "StoryMakeFilterFooterView.h"

@interface StoryMakeImageEditorViewController ()<StoryMakeToolsViewDelegate, StoryMakeStickerViewDelegate, StoryMakeStickerBaseViewDelegate, StoryMakeSelectColorFooterViewDelegate, StoryMakeFilterFooterViewDelegate>

@property (nonatomic, strong) UIImage *contentImage;

@property (nonatomic, strong) UIImageView *drawImgView;

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) StoryMakeToolsView *toolsBtnView;

@property (nonatomic, strong) StoryMakeStickerView *stickerFooterView;
@property (nonatomic, strong) StoryMakeSelectColorFooterView *colorFooterView;
@property (nonatomic, strong) StoryMakeFilterFooterView *filterFooterView;

@property (nonatomic, strong) NSMutableArray <UIView *> *stickerViewArray;
@property (nonatomic, assign) NSInteger stickerTags;

@end

@implementation StoryMakeImageEditorViewController

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init]) {
        self.contentImage = image;
        self.stickerViewArray = [NSMutableArray array];
        self.stickerTags = 0;
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    BOOL selected = NO;
    
    for (UIView *obj in self.stickerViewArray) {
        if ([obj isKindOfClass:[StoryMakeStickerBaseView class]]) {
            StoryMakeStickerBaseView *view = (StoryMakeStickerBaseView *)obj;
            if (CGRectContainsPoint(view.frame, point) && !selected) {
                view.isSelected = YES;
                selected = YES;
            }else{
                view.isSelected = NO;
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark -
#pragma mark - Configure

- (void)configureView
{
    [self.view addSubview:self.drawImgView];
    [self.drawImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    // up layer tools
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.confirmBtn];
    [self.view addSubview:self.toolsBtnView];
    [self.view addSubview:self.stickerFooterView];
    [self.view addSubview:self.colorFooterView];
    [self.view addSubview:self.filterFooterView];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view.mas_top).offset(SCREENAPPLYHEIGHT(31));
        make.left.mas_equalTo(self.view.mas_left).offset(SCREENAPPLYHEIGHT(10));
        make.height.width.mas_equalTo(SCREENAPPLYHEIGHT(48));
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view.mas_top).offset(SCREENAPPLYHEIGHT(31));
        make.right.mas_equalTo(self.view.mas_right).offset(-SCREENAPPLYHEIGHT(16));
        make.height.mas_equalTo(SCREENAPPLYHEIGHT(44));
        make.width.mas_equalTo(SCREENAPPLYHEIGHT(84));
    }];
    
    [self.toolsBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(SCREENAPPLYHEIGHT(74));
    }];
}

#pragma mark -
#pragma mark - Btn Action

- (void)cancelBtnAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmBtnAction
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存到相册？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.stickerViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[StoryMakeStickerBaseView class]]) {
                    ((StoryMakeStickerBaseView *)obj).isSelected = NO;
                }
            }];
            
            UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, [UIScreen mainScreen].scale);
            [self.drawImgView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [self loadImageFinished:image];
            
            
        });
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)loadImageFinished:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    
}

#pragma mark -
#pragma mark - StoryMakeToolsViewDelegate

- (void)stickerBtnDidSelected
{
    [self showStickerFooterView];
}

- (void)drawBtnDidSelected
{
    self.colorFooterView.type = StoryMakeSelectColorFooterViewTypeDrawing;
    [self showColorFooterView];
}

- (void)writeBtnDidSelected
{
    self.colorFooterView.type = StoryMakeSelectColorFooterViewTypeWriting;
    [self showColorFooterView];
}

- (void)filterBtnDidSelected
{
    [self.stickerViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[StoryMakeStickerBaseView class]]) {
            ((StoryMakeStickerBaseView *)obj).isSelected = NO;
        }
    }];
    
    [self showFilterFooterView];
}

#pragma mark -
#pragma mark - StoryMakeStickerViewDelegate

- (void)stickerViewDidSelectedImage:(UIImage *)image
{
    StoryMakeStickerImageView *stickerImageView = [[StoryMakeStickerImageView alloc] init];
    stickerImageView.delegate = self;
    stickerImageView.tag = self.stickerTags ++;
    stickerImageView.frame = CGRectMake(0, 0, SCREENAPPLYHEIGHT(128), SCREENAPPLYHEIGHT(128));
    stickerImageView.center = self.drawImgView.center;
    stickerImageView.contentImageView.image = image;
    [self.drawImgView addSubview:stickerImageView];
    
    [self.stickerViewArray insertObject:stickerImageView atIndex:0];
    
    [self hideStickerFooterView];
}

#pragma mark -
#pragma mark - StoryMakeStickerBaseViewDelegate

- (void)storyMakeStickerBaseViewCloseBtnClicked:(StoryMakeStickerBaseView *)view
{
    if (IsEmpty(view)) {
        return;
    }
    
    [self.stickerViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[StoryMakeStickerBaseView class]]) {
            StoryMakeStickerBaseView *singleView = (StoryMakeStickerBaseView *)obj;
            if (singleView == view) {
                [singleView removeFromSuperview];
                [self.stickerViewArray removeObjectAtIndex:idx];
                *stop = YES;
            }
        }
    }];
}

#pragma mark -
#pragma mark - StoryMakeSelectColorFooterViewDelegate

- (void)storyMakeSelectColorFooterViewCloseBtnClicked
{
    [self hideColorFooterView];
}

- (void)storyMakeSelectColorFooterViewConfirmBtnClicked:(NSString *)text font:(UIFont *)font color:(UIColor *)color
{
    self.colorFooterView.center = CGPointMake(self.view.center.x, self.view.center.y + SCREENAPPLYHEIGHT(667));
    self.colorFooterView.hidden = YES;
    [self showToolsView];
    
    CGRect rect1 = [text boundingRectWithSize:CGSizeMake(SCREENAPPLYHEIGHT(340), MAXFLOAT)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil];
    CGRect rect2 = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, SCREENAPPLYHEIGHT(100))
                                        options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil];
    
    if (rect2.size.width > SCREENAPPLYHEIGHT(340)) {
        rect2.size.width = SCREENAPPLYHEIGHT(340);
    }
    
    StoryMakeStickerLabelView *stickeLabelView = [[StoryMakeStickerLabelView alloc] initWithLabelHeight:CGSizeMake(rect2.size.width, rect1.size.height)];
    stickeLabelView.delegate = self;
    stickeLabelView.tag = self.stickerTags ++;
    stickeLabelView.frame = CGRectMake(0, 0, rect2.size.width + SCREENAPPLYHEIGHT(44), rect1.size.height + SCREENAPPLYHEIGHT(34));
    stickeLabelView.center = CGPointMake(SCREENAPPLYHEIGHT(187.5), SCREENAPPLYHEIGHT(180));
    stickeLabelView.contentLabel.text = text;
    stickeLabelView.contentLabel.font = font;
    stickeLabelView.contentLabel.textColor = color;
    
    [self.drawImgView addSubview:stickeLabelView];
    
    [self.stickerViewArray insertObject:stickeLabelView atIndex:0];
}

- (void)storyMakeSelectColorFooterViewConfirmBtnClicked:(UIImage *)drawImage
{
    self.colorFooterView.center = CGPointMake(self.view.center.x, self.view.center.y + SCREENAPPLYHEIGHT(667));
    self.colorFooterView.hidden = YES;
    [self showToolsView];
    
    UIImageView *drawImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    drawImageView.image = drawImage;
    [self.drawImgView addSubview:drawImageView];
    
    [self.stickerViewArray insertObject:drawImageView atIndex:0];
}

#pragma mark -
#pragma mark - StoryMakeFilterFooterViewDelegate
- (void)storyMakeFilterFooterViewCloseBtnClicked
{
    [self hideFilterFooterView];
}

- (void)storyMakeFilterFooterViewConfirmBtnClicked:(UIImage *)drawImage
{
    self.filterFooterView.center = CGPointMake(self.view.center.x, self.view.center.y + SCREENAPPLYHEIGHT(667));
    self.filterFooterView.hidden = YES;
    [self showToolsView];
    
    self.drawImgView.image = drawImage;
    
    for (UIView *obj in self.stickerViewArray) {
        [obj removeFromSuperview];
    }
    [self.stickerViewArray removeAllObjects];
}

#pragma mark -
#pragma mark - ToolsView

- (void)showToolsView
{
    self.toolsBtnView.hidden = NO;
    self.cancelBtn.hidden = NO;
    self.confirmBtn.hidden = NO;
}

- (void)hideToolsView
{
    self.toolsBtnView.hidden = YES;
    self.cancelBtn.hidden = YES;
    self.confirmBtn.hidden = YES;
}

#pragma mark -
#pragma mark - Sticker

- (void)showStickerFooterView
{
    self.stickerFooterView.hidden = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.stickerFooterView.center = self.view.center;
                     }];
    
}

- (void)hideStickerFooterView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.stickerFooterView.center = CGPointMake(self.view.center.x, self.view.center.y + SCREENAPPLYHEIGHT(667));
                     } completion:^(BOOL finished) {
                         self.stickerFooterView.hidden = YES;
                     }];
}

#pragma mark -
#pragma mark - ColorFooter

- (void)showColorFooterView
{
    self.colorFooterView.hidden = NO;
    [self hideToolsView];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.colorFooterView.center = self.view.center;
                     } completion:^(BOOL finished) {
                         [self.colorFooterView updateColorFooterViewInMainView];
                     }];
    
}

- (void)hideColorFooterView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.colorFooterView.center = CGPointMake(self.view.center.x, self.view.center.y + SCREENAPPLYHEIGHT(667));
                     } completion:^(BOOL finished) {
                         self.colorFooterView.hidden = YES;
                         [self showToolsView];
                     }];
}

#pragma mark -
#pragma mark - ColorFooter

- (void)showFilterFooterView
{
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, [UIScreen mainScreen].scale);
    [self.drawImgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.filterFooterView.hidden = NO;
    [self.filterFooterView updateFilterViewWithImage:image];
    
    [self hideToolsView];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.filterFooterView.center = self.view.center;
                     }];
    
}

- (void)hideFilterFooterView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.filterFooterView.center = CGPointMake(self.view.center.x, self.view.center.y + SCREENAPPLYHEIGHT(667));
                     } completion:^(BOOL finished) {
                         self.filterFooterView.hidden = YES;
                         [self showToolsView];
                     }];
}

#pragma mark -
#pragma mark - Getter

- (UIImageView *)drawImgView
{
    if (!_drawImgView) {
        _drawImgView = [[UIImageView alloc] initWithImage:self.contentImage];
        _drawImgView.contentMode = UIViewContentModeScaleAspectFit;
        _drawImgView.backgroundColor = [UIColor blackColor];
        _drawImgView.userInteractionEnabled = YES;
    }
    return _drawImgView;
}

- (UIButton *)cancelBtn {
    if(!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setImage:[UIImage imageNamed:@"story_maker_close"] forState:UIControlStateNormal];
        _cancelBtn.layer.shadowColor = UIColorFromRGB(0, 0, 0).CGColor;
        _cancelBtn.layer.shadowOffset = CGSizeMake(0, 2);
        _cancelBtn.layer.shadowRadius = 2;
        _cancelBtn.layer.shadowOpacity = 0.3;
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if(!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]
                                           initWithString:@"Next "
                                           attributes:@{NSFontAttributeName : [StoryMakerFontManager getFontFutura:SCREENAPPLYHEIGHT(16)],
                                                        NSForegroundColorAttributeName : UIColorFromRGBA(51, 51, 51, 1.0)
                                                        }];
        NSTextAttachment *imageAtta = [[NSTextAttachment alloc] init];
        imageAtta.image = [UIImage imageNamed:@"story_maker_next" withTintColor:UIColorFromRGBA(51, 51, 51, 1.0)];
        imageAtta.bounds = CGRectMake(0, -SCREENAPPLYHEIGHT(0), SCREENAPPLYHEIGHT(8), SCREENAPPLYHEIGHT(12));
        [attr appendAttributedString:[NSAttributedString attributedStringWithAttachment:imageAtta]];
        [_confirmBtn setAttributedTitle:attr forState:UIControlStateNormal];
        [_confirmBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_confirmBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(179, 179, 179)] forState:UIControlStateHighlighted];
        
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.layer.cornerRadius = SCREENAPPLYHEIGHT(22);
        _confirmBtn.layer.shadowColor = UIColorFromRGB(0, 0, 0).CGColor;
        _confirmBtn.layer.shadowOffset = CGSizeMake(0, 2);
        _confirmBtn.layer.shadowRadius = 2;
        _confirmBtn.layer.shadowOpacity = 0.3;
        [_confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (StoryMakeToolsView *)toolsBtnView
{
    if (!_toolsBtnView) {
        _toolsBtnView = [[StoryMakeToolsView alloc] init];
        _toolsBtnView.delegate = self;
    }
    
    return _toolsBtnView;
}

- (StoryMakeStickerView *)stickerFooterView
{
    if (!_stickerFooterView) {
        _stickerFooterView = [[StoryMakeStickerView alloc] init];
        _stickerFooterView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), SCREEN_WIDTH, SCREEN_HEIGHT);
        _stickerFooterView.delegate = self;
        _stickerFooterView.hidden = YES;
    }
    return _stickerFooterView;
}

- (StoryMakeSelectColorFooterView *)colorFooterView
{
    if (!_colorFooterView) {
        _colorFooterView = [[StoryMakeSelectColorFooterView alloc] init];
        _colorFooterView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), SCREEN_WIDTH, SCREEN_HEIGHT);
        _colorFooterView.delegate = self;
        _colorFooterView.hidden = YES;
    }
    return _colorFooterView;
}

- (StoryMakeFilterFooterView *)filterFooterView
{
    if (!_filterFooterView) {
        _filterFooterView = [[StoryMakeFilterFooterView alloc] init];
        _filterFooterView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), SCREEN_WIDTH, SCREEN_HEIGHT);
        _filterFooterView.delegate = self;
        _filterFooterView.hidden = YES;
    }
    return _filterFooterView;
}

@end
