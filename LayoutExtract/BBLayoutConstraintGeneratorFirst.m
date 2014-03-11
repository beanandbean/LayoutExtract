//
//  BBLayoutConstraintGeneratorFirst.m
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/11/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

#import "BBLayoutConstraintGeneratorFirst.h"

@interface BBLayoutConstraintGeneratorFirst ()

@property (strong, nonatomic) NSNumber *tag;

@end

@implementation BBLayoutConstraintGeneratorFirst

- (id)initWithPositionDictionary:(NSDictionary *)positionDictionary andConstraint:(NSLayoutConstraint *)constraint {
    self = [super initWithPositionDictionary:positionDictionary andConstraint:constraint];
    if (self) {
        self.tag = [NSNumber numberWithInteger:((UIView *)constraint.firstItem).tag];
    }
    return self;
}

- (NSLayoutConstraint *)generated {
    NSAssert([self.positionDictionary objectForKey:self.tag], @"");
    if (!self.generatedConstraint) {
        self.generatedConstraint = [NSLayoutConstraint constraintWithItem:[self.positionDictionary objectForKey:self.tag] attribute:self.attr1 relatedBy:self.relation toItem:self.item2 attribute:self.attr2 multiplier:self.mul constant:self.cons];
        self.generatedConstraint.priority = self.priority;
    }
    return self.generatedConstraint;
}

@end
