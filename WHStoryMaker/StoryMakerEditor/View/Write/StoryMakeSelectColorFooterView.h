//
//  StoryMakeSelectColorFooterView.h
//  GetZSCStoryMaker
//
//  Created by whbalzac on 10/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, StoryMakeSelectColorFooterViewType){
    
    StoryMakeSelectColorFooterViewTypeDrawing = 0,
    StoryMakeSelectColorFooterViewTypeWriting
};

@protocol StoryMakeSelectColorFooterViewDelegate <NSObject>

@optional
- (void)storyMakeSelectColorFooterViewCloseBtnClicked;
- (void)storyMakeSelectColorFooterViewConfirmBtnClicked:(NSString *)text font:(UIFont *)font color:(UIColor *)color;
- (void)storyMakeSelectColorFooterViewConfirmBtnClicked:(UIImage *)drawImage;

@end

@interface StoryMakeSelectColorFooterView : UIView

@property (nonatomic, weak) id <StoryMakeSelectColorFooterViewDelegate> delegate;

@property (nonatomic, assign) StoryMakeSelectColorFooterViewType type;

- (void)updateColorFooterViewInMainView;

@end
