//
//  BBOrientationSpecifiedLayoutConstraint.m
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/18/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

#import "BBOrientationSpecifiedLayoutConstraint.h"

#define CURRENT_ORIENTATION ([UIApplication sharedApplication].statusBarOrientation)
#define SPECIFIED_ORIENTATION_RELATED_OBJ(orientation, landscape, portrait) (UIInterfaceOrientationIsLandscape(orientation) ? landscape : portrait)
#define ORIENTATION_RELATED_OBJ(landscape, portrait) SPECIFIED_ORIENTATION_RELATED_OBJ(CURRENT_ORIENTATION, landscape, portrait)
#define CURRENT_ORIENTATION_INDEX ORIENTATION_RELATED_OBJ(BBLSDeviceOrientationLandscape, BBLSDeviceOrientationPortrait)

@implementation BBOrientationSpecifiedLayoutConstraint

- (UILayoutPriority)priority {
    if (CURRENT_ORIENTATION_INDEX != self.orientation) {
        NSLog(@"1");
        return 1;
    } else {
        NSLog(@"%f", [super priority]);
        return [super priority];
    }
}

- (UILayoutPriority)truePriority {
    return [super priority];
}

@end
