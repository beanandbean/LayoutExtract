//
//  BBLayoutPosition.m
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/11/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

#import "BBLayoutPosition.h"

static BBLayoutPosition *g_layoutPositionNull;

@implementation BBLayoutPosition

+ (BBLayoutPosition *)layoutPositionNull {
    if (!g_layoutPositionNull) {
        g_layoutPositionNull = [[BBLayoutPosition alloc] init];
    }
    return g_layoutPositionNull;
}

- (id)init {
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

@end
