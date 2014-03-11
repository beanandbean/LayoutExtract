//
//  BBLayoutConstraintGeneratorBoth.m
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/11/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

#import "BBLayoutConstraintGeneratorBoth.h"

@interface BBLayoutConstraintGeneratorBoth ()

@property (strong, nonatomic) NSNumber *tag1;
@property (strong, nonatomic) NSNumber *tag2;

@end

@implementation BBLayoutConstraintGeneratorBoth

- (id)initWithPositionDictionary:(NSDictionary *)positionDictionary andConstraint:(NSLayoutConstraint *)constraint {
    self = [super init];
    if (self) {
        self.tag1 = [NSNumber numberWithInteger:((UIView *)constraint.firstItem).tag];
        self.tag2 = [NSNumber numberWithInteger:((UIView*)constraint.secondItem).tag];
    }
    return self;
}

- (NSLayoutConstraint *)generated {
    if (!self.generatedConstraint) {
        self.generatedConstraint = [NSLayoutConstraint constraintWithItem:[self.positionDictionary objectForKey:self.tag1] attribute:self.attr1 relatedBy:self.relation toItem:[self.positionDictionary objectForKey:self.tag2] attribute:self.attr2 multiplier:self.mul constant:self.cons];
        self.generatedConstraint.priority = self.priority;
    }
    return self.generatedConstraint;
}

@end
