//
//  StoryMakeStickerColorFootSingleViewController.h
//  GetZSCStoryMaker
//
//  Created by whbalzac on 10/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, StoryMakeStickerColorFootSingleType){
    
    StoryMakeStickerColorFootSingleTypeIndex0 = 0,
    StoryMakeStickerColorFootSingleTypeIndex1,
    StoryMakeStickerColorFootSingleTypeIndex2,
    
    StoryMakeStickerColorFootSingleTypeCount,
};

@protocol StoryMakeStickerColorFootSingleViewControllerDelegate <NSObject>
@optional
- (void)colorFootSingleViewControllerDidSelectedColor:(UIColor *)color;
@end

@interface StoryMakeStickerColorFootSingleViewController : UIViewController

@property (nonatomic, weak) id <StoryMakeStickerColorFootSingleViewControllerDelegate> delegate;

- (instancetype)initWithType:(StoryMakeStickerColorFootSingleType)type;

@end
