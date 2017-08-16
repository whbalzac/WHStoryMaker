//
//  UIImage+imageWithColor.h
//  PopU
//
//  Created by songbo on 14-4-23.
//  Copyright (c) 2014年 Pinssible. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (imageWithColor)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color withCenter:(UIImage *)centerImage size:(CGSize)size;
+ (UIImage *)imageNamed:(NSString *)name withTintColor:(UIColor *)color;
+ (UIImage *)convertImageToGreyScale:(UIImage*)image;
+ (NSString *)contentTypeForImageData:(NSData *)data;
+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage *)imageWithImage:(UIImage *)image withTintColor:(UIColor *)color;
+ (UIImage *)makeImageWithView:(UIView *)view;
+ (UIImage *)Base64StrToUIImage:(NSString *)encodedImageStr;
@end


