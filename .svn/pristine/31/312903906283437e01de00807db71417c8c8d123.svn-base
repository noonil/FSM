
//
//  NSString+Extension.m
//  MMWeibo
//
//  Created by Min on 15/12/3.
//  Copyright © 2015年 Min. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

/** 返回文字的size*/
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW {
    
    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font {
    
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

@end
