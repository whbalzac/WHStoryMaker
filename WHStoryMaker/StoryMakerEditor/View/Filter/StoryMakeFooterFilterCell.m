//
//  StoryMakeFooterFilterCell.m
//  GetZSCStoryMaker
//
//  Created by whbalzac on 11/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import "StoryMakeFooterFilterCell.h"
#import "StoryMakerFontManager.h"

@implementation StoryMakeFooterFilterCell

#pragma mark - Class Methods
+ (NSString *)identifierForReuseCell {
    return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configureView];
    }
    return self;
}

- (void)configureView
{
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.imageView.mas_width);
    }];
    
    [self.contentView addSubview:self.filterNameLabel];
    [self.filterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(SCREENAPPLYHEIGHT(15));
    }];
}

#pragma mark -
#pragma mark - Getter

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = SCREENAPPLYHEIGHT(25);
        _imageView.layer.borderWidth = 2;
        _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _imageView;
}

- (UILabel *)filterNameLabel
{
    if (!_filterNameLabel){
        _filterNameLabel = [[UILabel alloc] init];
        _filterNameLabel.textColor = [UIColor whiteColor];
        _filterNameLabel.textAlignment = NSTextAlignmentCenter;
        _filterNameLabel.font = [StoryMakerFontManager getFontFutura:SCREENAPPLYHEIGHT(12)];
        _filterNameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _filterNameLabel;
}

@end
