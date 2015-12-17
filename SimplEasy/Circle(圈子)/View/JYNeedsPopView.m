//
//  JYNeedsPopView.m
//  SimplEasy
//
//  Created by EvenLam on 15/12/17.
//  Copyright © 2015年 SimplEasy. All rights reserved.
//

#import "JYNeedsPopView.h"

static const CGFloat MARGIN = 10.0;
static const CGFloat PADDING = 2.0;

@implementation JYNeedsPopView


- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 1;
    CGFloat arrowW = 8.0;
    CGFloat arrowH = 12.0;
    CGFloat radius = 5;
    
    CGPoint originP = CGPointMake(MARGIN, self.size.height/2);
    CGPoint secondP = CGPointMake(MARGIN + arrowW, self.size.height/2-arrowH/2);
    CGPoint secondLastP = CGPointMake(MARGIN + arrowW, self.size.height/2+arrowH/2);
    CGPoint leftTop = CGPointMake(MARGIN + arrowW + radius, PADDING + radius);
    CGPoint rightTop = CGPointMake(self.size.width - PADDING - radius,  PADDING + radius);
    CGPoint leftDown = CGPointMake(MARGIN + arrowW + radius, self.size.height-PADDING-radius);
    CGPoint rightDown = CGPointMake(self.size.width - PADDING - radius, self.size.height-PADDING-radius);
    
    [path moveToPoint:originP];
    [path addLineToPoint:secondP];
    [path addArcWithCenter:leftTop radius:radius startAngle:M_PI endAngle:M_PI_2*3 clockwise:YES];
    [path addArcWithCenter:rightTop radius:radius startAngle:M_PI_2*3 endAngle:M_PI_2*4 clockwise:YES];
    [path addArcWithCenter:rightDown radius:radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addArcWithCenter:leftDown radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:secondLastP];
    [path closePath];
    
    [self.lineColor setStroke];
    [[UIColor whiteColor] setFill];
    [path stroke];
    [path fill];
}


@end
