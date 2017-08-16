//
//  StoryMakeStickerLabelView.h
//  GetZSCStoryMaker
//
//  Created by whbalzac on 11/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import "StoryMakeStickerBaseView.h"

@interface StoryMakeStickerLabelView : StoryMakeStickerBaseView

@property (nonatomic, strong) UILabel *contentLabel;

- (instancetype)initWithLabelHeight:(CGSize)labelSize;

@end
