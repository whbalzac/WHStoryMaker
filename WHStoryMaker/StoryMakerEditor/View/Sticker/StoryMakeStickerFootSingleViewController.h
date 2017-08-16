//
//  StoryMakeStickerFootSingleViewController.h
//  GetZSCStoryMaker
//
//  Created by whbalzac on 09/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, StoryMakeStickerFootSingleType){
    
    StoryMakeStickerFootSingleTypeIndex0 = 0,
    StoryMakeStickerFootSingleTypeIndex1,
    StoryMakeStickerFootSingleTypeIndex2,

    StoryMakeStickerFootSingleTypeCount,
};

@protocol StoryMakeStickerFootSingleViewControllerDelegate <NSObject>

@optional

- (void)singleViewControllerDidSelectedImage:(UIImage *)image;

@end

@interface StoryMakeStickerFootSingleViewController : UIViewController

@property (nonatomic, weak) id <StoryMakeStickerFootSingleViewControllerDelegate> delegate;

- (instancetype)initWithType:(StoryMakeStickerFootSingleType)type;

@end
