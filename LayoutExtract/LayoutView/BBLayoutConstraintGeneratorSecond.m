//
//  BBLayoutConstraintGeneratorSecond.m
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/11/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

#import "BBLayoutConstraintGeneratorSecond.h"

@interface BBLayoutConstraintGeneratorSecond ()

@property (strong, nonatomic) NSNumber *tag;

@end

@implementation BBLayoutConstraintGeneratorSecond

- (id)initWithPositionDictionary:(NSDictionary *)positionDictionary constraint:(NSLayoutConstraint *)constraint andOrientation:(BBLSDeviceOrientation)orientation {
    self = [super initWithPositionDictionary:positionDictionary constraint:constraint andOrientation:orientation];
    if (self) {
        self.tag = [NSNumber numberWithInteger:((UIView*)constraint.secondItem).tag];
    }
    return self;
}

- (NSLayoutConstraint *)generated {
    NSAssert([self.positionDictionary objectForKey:self.tag], @"");
    if (!self.generatedConstraint) {
        self.generatedConstraint = [NSLayoutConstraint constraintWithItem:self.item1 attribute:self.attr1 relatedBy:self.relation toItem:[self.positionDictionary objectForKey:self.tag] attribute:self.attr2 multiplier:self.mul constant:self.cons];
        self.generatedConstraint.priority = self.priority;
    }
    return self.generatedConstraint;
}

@end
