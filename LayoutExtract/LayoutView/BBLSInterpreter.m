//
//  BBLSInterpreter.m
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/14/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

#import "BBLSInterpreter.h"

#define EOS [BBLSInterpreterEndOfScriptException exceptionWithName:@"EndOfScript" reason:@"EOS detected!" userInfo:nil]

#define ACTIONS [BBLSInterpreter actions]
#define CONSTRAINT_ATTRIBUTES [BBLSInterpreter constraintAttributes]
#define CONSTRAINT_RELATIONS [BBLSInterpreter constraintRelations]

#define INTNUM(intnum) [NSNumber numberWithInteger:(NSInteger)intnum]

#define SELOBJ(name) [NSValue valueWithPointer:@selector(name)]

static NSDictionary *g_actions;
static NSDictionary *g_constraintAttributes;
static NSDictionary *g_constraintRelations;

@interface BBLSInterpreterEndOfScriptException : NSException

@end

@implementation BBLSInterpreterEndOfScriptException

@end

@interface BBLSInterpreter ()

@property (weak, nonatomic) id<BBLSInterpreterDelegate> delegate;

@property (strong, nonatomic) NSArray *parts;
@property (nonatomic) int index;

@end

@implementation BBLSInterpreter

+ (NSDictionary *)actions {
    if (!g_actions) {
        g_actions = [NSDictionary dictionaryWithObjectsAndKeys:
                     SELOBJ(addPositionDetected), @"position",
                     SELOBJ(addConstraintDetected), @"constraint",
                     SELOBJ(setCornerRadiusDetected), @"cornerRadius",
                     nil];
    }
    return g_actions;
}

+ (NSDictionary *)constraintAttributes {
    if (!g_constraintAttributes) {
        g_constraintAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                  INTNUM(NSLayoutAttributeBaseline), @"baseline",
                                  INTNUM(NSLayoutAttributeBottom), @"bottom",
                                  INTNUM(NSLayoutAttributeCenterX), @"centerX",
                                  INTNUM(NSLayoutAttributeCenterY), @"centerY",
                                  INTNUM(NSLayoutAttributeHeight), @"height",
                                  INTNUM(NSLayoutAttributeLeading), @"leading",
                                  INTNUM(NSLayoutAttributeLeft), @"left",
                                  INTNUM(NSLayoutAttributeRight), @"right",
                                  INTNUM(NSLayoutAttributeTop), @"top",
                                  INTNUM(NSLayoutAttributeTrailing), @"trailing",
                                  INTNUM(NSLayoutAttributeWidth), @"width",
                                  nil];
    }
    return g_constraintAttributes;
}

+ (NSDictionary *)constraintRelations {
    if (!g_constraintRelations) {
        g_constraintRelations = [NSDictionary dictionaryWithObjectsAndKeys:
                                  INTNUM(NSLayoutRelationEqual), @"=",
                                  INTNUM(NSLayoutRelationGreaterThanOrEqual), @">=",
                                  INTNUM(NSLayoutRelationLessThanOrEqual), @"<=",
                                  nil];
    }
    return g_constraintRelations;
}

- (id)initWithDelegate:(id<BBLSInterpreterDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)feed:(NSString *)script {
    self.index = 0;
    self.parts = [script componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    @try {
        while (1) {
            NSString *part = self.nextPart;
            NSValue *actionObj = [ACTIONS objectForKey:part];
            if (actionObj && [self respondsToSelector:actionObj.pointerValue]) {
                SEL selector = actionObj.pointerValue;
                IMP imp = [self methodForSelector:selector];
                void (*func)(id, SEL) = (void *)imp;
                func(self, selector);
            }
        }
    }
    @catch (BBLSInterpreterEndOfScriptException *e) {
    }
    @finally {
        self.index = INT_MAX;
        self.parts = nil;
    }
}

- (NSString *)nextPart {
    NSString *result;
    while (!result || !result.length) {
        if (self.index < self.parts.count) {
            result = [self.parts objectAtIndex:self.index++];
        } else {
            @throw EOS;
        }
    }
    return result;
}

- (void)addPositionDetected {
    NSInteger tag = self.nextPart.integerValue;
    [self.delegate interpreter:self addPositionWithTag:tag];
}

- (void)addConstraintDetected {
    NSString *tagString1 = self.nextPart;
    UILayoutPriority priority;
    if ([tagString1 isEqualToString:@"@p"]) {
        priority = self.nextPart.floatValue;
        tagString1 = self.nextPart;
    } else {
        priority = 1000;
    }
    NSInteger tag1;
    if ([tagString1 isEqualToString:@"p"]) {
        tag1 = LS_PARENT;
    } else if ([tagString1 isEqualToString:@"NA"]) {
        tag1 = LS_NONE;
    } else {
        tag1 = tagString1.integerValue;
    }
    NSLayoutAttribute attr1;
    if (tag1 == LS_NONE) {
        attr1 = NSLayoutAttributeNotAnAttribute;
    } else {
        attr1 = ((NSNumber *)[CONSTRAINT_ATTRIBUTES objectForKey:self.nextPart]).integerValue;
    }
    NSLayoutRelation relation = ((NSNumber *)[CONSTRAINT_RELATIONS objectForKey:self.nextPart]).integerValue;
    NSString *tagString2 = self.nextPart;
    NSInteger tag2;
    if ([tagString2 isEqualToString:@"p"]) {
        tag2 = LS_PARENT;
    } else if ([tagString2 isEqualToString:@"NA"]) {
        tag2 = LS_NONE;
    } else {
        tag2 = tagString2.integerValue;
    }
    NSLayoutAttribute attr2;
    if (tag2 == LS_NONE) {
        attr2 = NSLayoutAttributeNotAnAttribute;
    } else {
        attr2 = ((NSNumber *)[CONSTRAINT_ATTRIBUTES objectForKey:self.nextPart]).integerValue;
    }
    float mul = self.nextPart.floatValue;
    float cons = self.nextPart.floatValue;
    [self.delegate interpreter:self addConstraintWithTag:tag1 attribute:attr1 relatedBy:relation toTag:tag2 attribute:attr2 multiplier:mul constant:cons priority:priority];
}

- (void)setCornerRadiusDetected {
    NSString *tagString = self.nextPart;
    BBLSDeviceOrientation orientation;
    if ([tagString isEqualToString:@"@landscape"]) {
        orientation = BBLSDeviceOrientationLandscape;
        tagString = self.nextPart;
    } else if ([tagString isEqualToString:@"@portrait"]) {
        orientation = BBLSDeviceOrientationPortrait;
        tagString = self.nextPart;
    } else {
        orientation = BBLSDeviceOrientationUniversal;
    }
    NSInteger tag;
    if ([tagString isEqualToString:@"*"]) {
        tag = LS_ALL;
    } else {
        tag = tagString.integerValue;
    }
    float value = self.nextPart.floatValue;
    [self.delegate interpreter:self setCornerRadiusOfTag:tag value:value forOrientation:orientation];
}

@end
