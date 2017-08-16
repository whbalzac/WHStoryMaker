//
//  StoryMakeToolsView.h
//  GetZSCStoryMaker
//
//  Created by whbalzac on 09/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StoryMakeToolsViewDelegate <NSObject>

@optional

- (void)stickerBtnDidSelected;
- (void)drawBtnDidSelected;
- (void)writeBtnDidSelected;
- (void)filterBtnDidSelected;

@end


@interface StoryMakeToolsView : UIView

@property (nonatomic, weak) id <StoryMakeToolsViewDelegate> delegate;

@end
