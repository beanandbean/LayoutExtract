//
//  BBLayoutView.m
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/11/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

#import "BBLayoutView.h"

@implementation BBLayoutView

- (id)initWithNibNamed:(NSString *)nib {
    self = [[NSBundle mainBundle] loadNibNamed:nib owner:Nil options:nil].firstObject;
    return self;
}

@end
