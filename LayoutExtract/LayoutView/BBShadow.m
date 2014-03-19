//
//  BBShadow.m
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/19/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

#import "BBShadow.h"

@implementation BBShadow

- (id)initWithOffset:(CGSize)offset radius:(float)radius color:(UIColor *)color andOpacity:(float)opacity {
    self = [super init];
    if (self) {
        self.offset = offset;
        self.radius = radius;
        self.color = color;
        self.opacity = opacity;
    }
    return self;
}

@end
