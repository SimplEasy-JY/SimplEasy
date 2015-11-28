//
//  UIImage+Circle.m
//
//  Created by EvenLam on 15/9/15.
//  Copyright (c) 2015年 LYF. All rights reserved.
//

#import "UIImage+Circle.h"

@implementation UIImage (Circle)
+ (UIImage *)circleImageWithName: (NSString *)name borderWidth: (CGFloat)borderWidth borderColor: (UIColor *)borderColor{
//    1. 开启上下文
    UIImage *sourceImage = [UIImage imageNamed:name];
    UIImage *newImage = [self circleImageWithImage:sourceImage borderWidth:borderWidth borderColor:borderColor];
    return newImage;
}
+ (UIImage *)circleImageWithImage: (UIImage *)sourceImage borderWidth: (CGFloat)borderWidth borderColor: (UIColor *)borderColor{
    
        //    1. 开启上下文
        //    UIImage *sourceImage = [UIImage imageNamed:name];
        CGFloat imageWidth = sourceImage.size.width + 2*borderWidth;
        CGFloat imageHeight = sourceImage.size.height + 2*borderWidth;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWidth, imageHeight), NO, 0);
        //    2. 获取上下文
        UIGraphicsGetCurrentContext();
        //    3. 画圆
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(imageWidth*0.5, imageHeight*0.5) radius:MIN(sourceImage.size.width,sourceImage.size.height)*0.5 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        bezierPath.lineWidth = borderWidth;
        [borderColor setStroke];
        [bezierPath stroke];
        //    4. 使用BezierPath进行剪切
        [bezierPath addClip];
    
        //    5. 画图
        [sourceImage drawInRect:CGRectMake(borderWidth, borderWidth, sourceImage.size.width, sourceImage.size.height)];
//        });
    //    6. 从内存中创建新图片对象
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //    7. 结束上下文
    UIGraphicsEndImageContext();
    
    
    return newImage;
   
}
+ (UIImage *)scaleToSize: (UIImage *)image size: (CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
