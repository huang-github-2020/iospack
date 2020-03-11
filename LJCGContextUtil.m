//
//  LJCGContentUtil.m
//  YiFu
//
//  Created by 伍孟华 on 2018/7/6.
//  Copyright © 2018年 伍孟华. All rights reserved.
//

#import "LJCGContextUtil.h"
#import <UIKit/UIKit.h>
#import "LJTimeChartModel.h"
//#import "LJDrawPointModel.h"
//#import "LJDrawRectModel.h"

@implementation LJCGContextUtil

+(void)lj_addLineDash:(CGContextRef)contextRef lineWidth:(float)lineWidth lineColorRef:(CGColorRef)lineColorRef lengths:(CGFloat[])lengths movePoint:(CGPoint)movePoint toPoint:(CGPoint)toPoint
{
    //绘制虚线
    CGContextSetLineWidth(contextRef, lineWidth);//线条宽度
    CGContextSetStrokeColorWithColor(contextRef, lineColorRef);
    CGContextSetLineDash(contextRef, 0, lengths, 2);//画虚线,可参考
    CGContextMoveToPoint(contextRef, movePoint.x, movePoint.y);//开始画线, x，y 为开始点的坐标
    CGContextAddLineToPoint(contextRef, toPoint.x, toPoint.y);//画直线, x，y 为线条结束点的坐标
    CGContextStrokePath(contextRef);//开始画线
}

+(void)lj_AddLineToPoint:(CGContextRef)contextRef lineWidth:(float)lineWidth lineColorRef:(CGColorRef)lineColorRef movePoint:(CGPoint)movePoint toPoint:(CGPoint)toPoint
{
    CGContextSetStrokeColorWithColor(contextRef, lineColorRef);//线条颜色
    CGContextSetLineWidth(contextRef, lineWidth);//线条宽度
    CGContextSetLineDash(contextRef, 0, 0, 0);//不需要虚线
    CGContextSetLineJoin(contextRef, kCGLineJoinMiter);//线条结尾处绘制一个直径为线条宽度的半圆。
    CGContextSetLineCap(contextRef , kCGLineCapButt);// 稍微圆角
    CGContextMoveToPoint(contextRef, movePoint.x, movePoint.y); //开始画线, x，y 为开始点的坐标
    CGContextAddLineToPoint(contextRef, toPoint.x, toPoint.y);//画直线, x，y 为线条结束点的坐标
    CGContextStrokePath(contextRef); //开始画线
}
+(void)lj_AddLineToPointsOff:(CGContextRef)contextRef lineWidth:(float)lineWidth lineColorRef:(CGColorRef)lineColorRef movePoints:(NSArray*)movePoints
{
//    CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
    
    contextRef = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextRef, lineColorRef);//线条颜色
    CGContextSetLineWidth(contextRef, lineWidth);//线条宽度
    CGContextSetLineDash(contextRef, 0, 0, 0);//不需要虚线
    if (movePoints && movePoints.count > 0) {
        for (int i = 0; i < movePoints.count; i++) {
            LJTimeChartModel *model = movePoints[i];
            CGContextMoveToPoint(contextRef, model.startVolPoint.x, model.startVolPoint.y); //开始画线, x，y 为开始点的坐标
            CGContextAddLineToPoint(contextRef, model.endVolPoint.x, model.endVolPoint.y);//画直线, x，y 为线条结束点的坐标
        }
    }
    CGContextStrokePath(contextRef); //开始画线
    
//    CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
//    NSLog(@"Linked in %f ms", linkTime *1000.0);
}


+(void)lj_AddLineToPoints:(CGContextRef)contextRef lineWidth:(float)lineWidth lineColorRef:(CGColorRef)lineColorRef points:(NSArray *)points lineType:(LJ_ENUM_CGContext_LineType)lineType
{
//    CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
    
    CGContextSetStrokeColorWithColor(contextRef, lineColorRef);//线条颜色
    CGContextSetLineWidth(contextRef, lineWidth);//线条宽度
    CGContextSetLineDash(contextRef, 0, 0, 0);//不需要虚线
    CGPoint addLines[points.count==1 ? 1+points.count : points.count];
    for (int i=0; i< points.count; i++) {
        LJTimeChartModel *model = points[i];
        if (lineType == LJ_ENUM_CGContent_CLP) {
            addLines[i] = model.linePoint;
        }else if (lineType == LJ_ENUM_CGContent_AVG){
            addLines[i] = model.avgPoint;
        }else if (lineType == LJ_ENUM_CGContent_OPI){
            addLines[i] = model.opiPoint;
        }
    }
    if (points.count == 1) {
        LJTimeChartModel *model = points[0];
        if (lineType == LJ_ENUM_CGContent_CLP) {
            addLines[1] = model.linePoint;
        }else if (lineType == LJ_ENUM_CGContent_AVG){
            addLines[1] = model.avgPoint;
        }else if (lineType == LJ_ENUM_CGContent_OPI){
            addLines[1] = model.opiPoint;
        }
    }
    CGContextAddLines(contextRef, addLines, sizeof(addLines)/sizeof(addLines[0]));
    CGContextStrokePath(contextRef); //开始画线
}

+(void)lj_AddLineToPoints_KLine:(CGContextRef)contextRef lineWidth:(float)lineWidth lineColorRef:(CGColorRef)lineColorRef points:(NSArray *)points
{
//    CGContextSetStrokeColorWithColor(contextRef, lineColorRef);//线条颜色
//    CGContextSetLineWidth(contextRef, lineWidth);//线条宽度
//    CGContextSetLineDash(contextRef, 0, 0, 0);//不需要虚线
//    CGPoint addLines[points.count==1 ? 1+points.count : points.count];
//    for (int i=0; i< points.count; i++) {
//        LJDrawPointModel *model = points[i];
//        addLines[i] = model.movePoint;
//    }
//    if (points.count == 1) {
//        LJDrawPointModel *model = points[0];
//        addLines[1] = model.movePoint;
//    }
//    CGContextAddLines(contextRef, addLines, sizeof(addLines)/sizeof(addLines[0]));
//    CGContextStrokePath(contextRef); //开始画线
}

+(void)lj_AddRect:(CGContextRef)contextRef lineWidth:(float)lineWidth fillColorRef:(CGColorRef)fillColorRef strokeColorRef:(CGColorRef)strokeColorRef rect:(CGRect)rect
{
    [LJCGContextUtil lj_AddRect:contextRef lineWidth:lineWidth fillColorRef:fillColorRef strokeColorRef:strokeColorRef rect:rect alpha:1];
}
+(void)lj_AddRect:(CGContextRef)contextRef lineWidth:(float)lineWidth fillColorRef:(CGColorRef)fillColorRef strokeColorRef:(CGColorRef)strokeColorRef rect:(CGRect)rect alpha:(CGFloat)alpha
{
    //矩形，并填充颜色
    CGContextSetLineWidth(contextRef, lineWidth);//线的宽度
    CGContextSetLineDash(contextRef, 0, 0, 0);//不需要虚线
    CGContextSetFillColorWithColor(contextRef, fillColorRef);//填充颜色
    CGContextSetAlpha(contextRef, alpha);
    CGContextSetStrokeColorWithColor(contextRef, strokeColorRef);//线框颜色
    CGContextAddRect(contextRef,rect);//画方框
    CGContextDrawPath(contextRef, kCGPathFillStroke);//绘画路径
}

+(void)lj_AddRects:(CGContextRef)contextRef lineWidth:(float)lineWidth fillColorRef:(CGColorRef)fillColorRef strokeColorRef:(CGColorRef)strokeColorRef rects:(NSArray *)rects
{
    //矩形，并填充颜色
//    CGContextSetLineWidth(contextRef, lineWidth);//线的宽度
//    CGContextSetLineDash(contextRef, 0, 0, 0);//不需要虚线
//    CGContextSetFillColorWithColor(contextRef, fillColorRef);//填充颜色
//    CGContextSetStrokeColorWithColor(contextRef, strokeColorRef);//线框颜色
//    CGRect addRects[rects.count];
//    for (int i=0; i< rects.count; i++) {
//        LJDrawRectModel *rectModel = [rects objectAtIndex:i];
//        addRects[i] = rectModel.rect;
//    }
//    //参数二：线数组，参数三：线的个数
//    CGContextAddRects(contextRef, addRects, sizeof(addRects)/sizeof(addRects[0]));
//    CGContextDrawPath(contextRef, kCGPathFillStroke);//绘画路径
}

+(void)lj_AddRectFont:(CGContextRef)contextRef text:(NSString *)text font:(UIFont *)font fontColor:(UIColor *)fontColor alignment:(NSTextAlignment)alignment rect:(CGRect)rect
{
    
    //文本风格，设置居中
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:alignment];
    //打印文本
    NSDictionary* dic = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:fontColor,NSBackgroundColorAttributeName : [UIColor clearColor]};
    [text drawInRect:rect withAttributes:dic];
    
    
    
    
    
    
    
//    CGContextSetLineWidth(contextRef, 1.0);
//    CGContextSetFillColorWithColor(contextRef, fontColor.CGColor);//填充颜色
//    [text drawInRect:rect withFont:font];
    
}
@end
