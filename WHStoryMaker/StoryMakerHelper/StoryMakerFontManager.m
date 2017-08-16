//
//  FontManager.m
//  InstaGrab
//
//  Created by yangl on 15/9/23.
//  Copyright (c) 2015年 JellyKit Inc. All rights reserved.
//

#import "StoryMakerFontManager.h"

@implementation StoryMakerFontManager

+ (UIFont *)getFontFutura:(CGFloat)fontSize {
    UIFont* fontLight;
    fontLight = [UIFont fontWithName:@"Futura-Medium" size:fontSize];
    
    if(fontLight == nil) {
        fontLight = [UIFont systemFontOfSize:fontSize];
    }
    
    return fontLight;
}

+ (UIFont *)getFontFuturaBT:(CGFloat)fontSize {
    UIFont* fontLight;
    fontLight = [UIFont fontWithName:@"FuturaBT-Light" size:fontSize];
    
    if(fontLight == nil) {
        fontLight = [UIFont systemFontOfSize:fontSize];
    }
    
    return fontLight;
}

@end
