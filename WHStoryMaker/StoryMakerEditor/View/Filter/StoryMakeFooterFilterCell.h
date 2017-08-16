//
//  StoryMakeFooterFilterCell.h
//  GetZSCStoryMaker
//
//  Created by whbalzac on 11/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryMakeFooterFilterCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *filterNameLabel;

+ (NSString *)identifierForReuseCell;
@end
