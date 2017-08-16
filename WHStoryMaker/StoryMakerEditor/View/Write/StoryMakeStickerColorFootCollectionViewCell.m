//
//  StoryMakeStickerColorFootCollectionViewCell.m
//  GetZSCStoryMaker
//
//  Created by whbalzac on 10/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import "StoryMakeStickerColorFootCollectionViewCell.h"

@implementation StoryMakeStickerColorFootCollectionViewCell

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
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = SCREENAPPLYHEIGHT(12);
    self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.contentView.layer.borderWidth = 1.0f;
}

- (void)setContentColor:(UIColor *)contentColor
{
    _contentColor = contentColor;
    self.contentView.backgroundColor = contentColor;
}

@end
