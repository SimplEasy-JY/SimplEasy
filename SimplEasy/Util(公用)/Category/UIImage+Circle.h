//
//  UIImage+Circle.h
//
//  Created by EvenLam on 15/9/15.
//  Copyright (c) 2015年 LYF. All rights reserved.
//
//  将图片切成圆形返回
#import <UIKit/UIKit.h>

@interface UIImage (Circle)
/**
 * 根据指定图片的文件名获取一张圆形的图片对象，并加一个边框
 * @param name 图片文件名
 * @param borderWidth 边框的宽
 * @param borderColor 边框颜色
 * @return 切好的圆形图片
 */
+ (UIImage *)circleImageWithName: (NSString *)name borderWidth: (CGFloat)borderWidth borderColor: (UIColor *)borderColor;
+ (UIImage *)circleImageWithImage: (UIImage *)sourceImage borderWidth: (CGFloat)borderWidth borderColor: (UIColor *)borderColor;

/**
 * 将一张图片变成指定的大小
 * @param image 原图片
 * @param size 指定的大小
 * @return 指定大小的图片
 */
+ (UIImage *)scaleToSize: (UIImage *)image size: (CGSize)size;
@end
