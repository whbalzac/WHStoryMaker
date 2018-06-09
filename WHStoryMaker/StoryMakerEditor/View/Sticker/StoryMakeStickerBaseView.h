//
//  StoryMakeStickerBaseView.h
//  GetZSCStoryMaker
//
//  Created by whbalzac on 10/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StoryMakeStickerBaseView;

@protocol StoryMakeStickerBaseViewDelegate <NSObject>

@optional
- (void)storyMakeStickerBaseViewCloseBtnClicked:(StoryMakeStickerBaseView *)view;

@end


@interface StoryMakeStickerBaseView : UIView

@property (nonatomic, weak) id <StoryMakeStickerBaseViewDelegate> delegate;

@property (nonatomic, assign) BOOL isSelected;

- (void)adjustSizeOfSelect:(CGFloat)scale;

@end
