//
//  BBLayoutConstraintGenerator.m
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/11/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

#import "BBLayoutConstraintGenerator.h"

@implementation BBLayoutConstraintGenerator

- (id)initWithPositionDictionary:(NSDictionary *)positionDictionary andConstraint:(NSLayoutConstraint *)constraint {
    self = [super init];
    if (self) {
        self.positionDictionary = positionDictionary;
        self.generatedConstraint = constraint;
        self.item1 = constraint.firstItem;
        self.attr1 = constraint.firstAttribute;
        self.relation = constraint.relation;
        self.item2 = constraint.secondItem;
        self.attr2 = constraint.secondAttribute;
        self.mul = constraint.multiplier;
        self.cons = constraint.constant;
        self.priority = constraint.priority;
    }
    return self;
}

- (NSLayoutConstraint *)generated {
    if (!self.generatedConstraint) {
        self.generatedConstraint = [NSLayoutConstraint constraintWithItem:self.item1 attribute:self.attr1 relatedBy:self.relation toItem:self.item2 attribute:self.attr2 multiplier:self.mul constant:self.cons];
        self.generatedConstraint.priority = self.priority;
    }
    return self.generatedConstraint;
}

- (NSLayoutConstraint *)destroyed {
    NSLayoutConstraint *constraint = self.generatedConstraint;
    self.generatedConstraint = nil;
    return constraint;
}

@end
