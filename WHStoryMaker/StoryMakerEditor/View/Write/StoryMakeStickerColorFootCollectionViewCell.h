//
//  StoryMakeStickerColorFootCollectionViewCell.h
//  GetZSCStoryMaker
//
//  Created by whbalzac on 10/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryMakeStickerColorFootCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIColor *contentColor;

+ (NSString *)identifierForReuseCell;

@end
