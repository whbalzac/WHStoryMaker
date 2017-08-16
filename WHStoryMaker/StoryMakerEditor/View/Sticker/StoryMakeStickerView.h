//
//  StoryMakeStickerView.h
//  GetZSCStoryMaker
//
//  Created by whbalzac on 09/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StoryMakeStickerViewDelegate <NSObject>
@optional
- (void)stickerViewDidSelectedImage:(UIImage *)image;
@end

@interface StoryMakeStickerView : UIView

@property (nonatomic, weak) id <StoryMakeStickerViewDelegate> delegate;

@end
