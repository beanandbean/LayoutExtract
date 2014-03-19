//
//  BBLayoutConstraintGenerator.h
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/11/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

#import "BBLSInterpreter.h"

@interface BBLayoutConstraintGenerator : NSObject

@property (strong, nonatomic) NSLayoutConstraint *generatedConstraint;

@property (weak, nonatomic) NSDictionary *positionDictionary;

@property (weak, nonatomic) id item1;
@property (nonatomic) NSLayoutAttribute attr1;
@property (nonatomic) NSLayoutRelation relation;
@property (weak, nonatomic) id item2;
@property (nonatomic) NSLayoutAttribute attr2;
@property (nonatomic) CGFloat mul;
@property (nonatomic) CGFloat cons;
@property (nonatomic) UILayoutPriority priority;
@property (nonatomic) BBLSDeviceOrientation orientation;

- (id)initWithPositionDictionary:(NSDictionary *)positionDictionary constraint:(NSLayoutConstraint *)constraint andOrientation:(BBLSDeviceOrientation)orientation;

- (NSLayoutConstraint *)generated;
- (NSLayoutConstraint *)destroyed;

@end
