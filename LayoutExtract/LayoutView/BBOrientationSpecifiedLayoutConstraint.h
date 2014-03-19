//
//  BBOrientationSpecifiedLayoutConstraint.h
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/18/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

#import "BBLSInterpreter.h"

@interface BBOrientationSpecifiedLayoutConstraint : NSLayoutConstraint

@property (nonatomic) BBLSDeviceOrientation orientation;

- (UILayoutPriority)truePriority;

@end
