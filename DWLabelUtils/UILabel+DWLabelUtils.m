//
//  UILabel+DWLabelUtils.m
//  ppp
//
//  Created by Wicky on 2016/12/3.
//  Copyright © 2016年 Wicky. All rights reserved.
//

#import "UILabel+DWLabelUtils.h"
#import <objc/runtime.h>


@implementation UILabel (DWLabelUtils)
+(void)load
{
    Method originRectMethod = class_getInstanceMethod(self, @selector(textRectForBounds:limitedToNumberOfLines:));
    Method destinationRectMethod = class_getInstanceMethod(self, @selector(dw_textRectForBounds:limitedToNumberOfLines:));
    method_exchangeImplementations(originRectMethod, destinationRectMethod);
    Method originDrawMethod = class_getInstanceMethod(self, @selector(drawTextInRect:));
    Method destinationDrawMethod = class_getInstanceMethod(self, @selector(dw_drawTextInRect:));
    method_exchangeImplementations(originDrawMethod, destinationDrawMethod);
}

-(void)dw_drawTextInRect:(CGRect)rect
{
    CGRect frame = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    [self dw_drawTextInRect:frame];
}

-(CGRect)dw_textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect rect = [self dw_textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];///获取系统计算的rect，不影响水平对齐方式
    CGPoint origin = rect.origin;
    switch (self.textVerticalAlignment) {///调整竖直对齐方式
        case DWTextVerticalAlignmentTop:
            origin.y = 0;
            break;
        case DWTextVerticalAlignmentBottom:
            origin.y = self.bounds.size.height - rect.size.height;
            break;
        default:
            origin.y = self.bounds.size.height / 2.0 - rect.size.height / 2.0;
            break;
    }
    rect.origin = origin;
    return rect;
}

-(void)setTextVerticalAlignment:(DWTextVerticalAlignment)textVerticalAlignment
{
    objc_setAssociatedObject(self, @selector(textVerticalAlignment), @(textVerticalAlignment), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(DWTextVerticalAlignment)textVerticalAlignment
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
@end
