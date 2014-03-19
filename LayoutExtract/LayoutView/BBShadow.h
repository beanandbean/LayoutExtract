//
//  BBShadow.h
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/19/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

@interface BBShadow : NSObject

@property (nonatomic) CGSize offset;
@property (nonatomic) float radius;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic) float opacity;

- (id)initWithOffset:(CGSize)offset radius:(float)radius color:(UIColor *)color andOpacity:(float)opacity;

@end
