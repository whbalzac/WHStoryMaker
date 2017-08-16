//
//  StoryMakeFilterFooterView.h
//  GetZSCStoryMaker
//
//  Created by whbalzac on 11/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StoryMakeFilterFooterViewDelegate <NSObject>

@optional
- (void)storyMakeFilterFooterViewCloseBtnClicked;
- (void)storyMakeFilterFooterViewConfirmBtnClicked:(UIImage *)drawImage;

@end

@interface StoryMakeFilterFooterView : UIView

@property (nonatomic, weak) id <StoryMakeFilterFooterViewDelegate> delegate;

- (void)updateFilterViewWithImage:(UIImage *)image;

@end
