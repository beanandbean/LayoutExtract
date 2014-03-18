//
//  BBLayoutView.m
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/11/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

#import "BBLayoutView.h"

#import "BBLayoutConstraintGeneratorFirst.h"
#import "BBLayoutConstraintGeneratorSecond.h"
#import "BBLayoutConstraintGeneratorBoth.h"

#define CURRENT_ORIENTATION ([UIApplication sharedApplication].statusBarOrientation)
#define SPECIFIED_ORIENTATION_RELATED_OBJ(orientation, landscape, portrait) (UIInterfaceOrientationIsLandscape(orientation) ? landscape : portrait)
#define ORIENTATION_RELATED_OBJ(landscape, portrait) SPECIFIED_ORIENTATION_RELATED_OBJ(CURRENT_ORIENTATION, landscape, portrait)
#define CURRENT_ORIENTATION_INDEX ORIENTATION_RELATED_OBJ(BBLSDeviceOrientationLandscape, BBLSDeviceOrientationPortrait)

#define INTNUM(intnum) [NSNumber numberWithInteger:(NSInteger)intnum]
#define FLOATNUM(floatnum) [NSNumber numberWithFloat:(float)floatnum]

#define TAG(view) INTNUM(((UIView *)view).tag)

@interface BBLayoutView ()

@property (strong, nonatomic) NSMutableDictionary *layoutViews;
@property (strong, nonatomic) NSMutableDictionary *layoutConstraints;
@property (strong, nonatomic) NSMutableDictionary *layoutCornerRadii;

@end

@implementation BBLayoutView

- (id)init {
    self = [super init];
    if (self) {
        self.layoutViews = [NSMutableDictionary dictionary];
        self.layoutConstraints = [NSMutableDictionary dictionary];
        self.layoutCornerRadii = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layoutViews = [NSMutableDictionary dictionary];
        self.layoutConstraints = [NSMutableDictionary dictionary];
        self.layoutCornerRadii = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layoutViews = [NSMutableDictionary dictionary];
        self.layoutConstraints = [NSMutableDictionary dictionary];
        self.layoutCornerRadii = [NSMutableDictionary dictionary];
        [self extractPositions];
    }
    return self;
}

- (id)initWithNibNamed:(NSString *)name atPosition:(BBLayoutDataPosition)position {
    NSString *documentPath;
    if (position == BBLayoutDataPositionDocument) {
        documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    NSString *specified = [NSString stringWithFormat:@"%@@%@", name, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"iphone" : @"ipad"];
    NSString *nibPath;
    if (position == BBLayoutDataPositionDocument) {
        nibPath = [[documentPath stringByAppendingPathComponent:specified] stringByAppendingPathExtension:@"nib"];
    } else {
        nibPath = [[NSBundle mainBundle] pathForResource:specified ofType:@"nib"];
    }
    if (!nibPath || ![[NSFileManager defaultManager] fileExistsAtPath:nibPath]) {
        if (position == BBLayoutDataPositionDocument) {
            nibPath = [[documentPath stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"nib"];
        } else {
            nibPath = [[NSBundle mainBundle] pathForResource:name ofType:@"nib"];
        }
    }
    NSData *nibData = [NSData dataWithContentsOfFile:nibPath];
    NSString *scriptPath;
    if (position == BBLayoutDataPositionDocument) {
        scriptPath = [[documentPath stringByAppendingPathComponent:specified] stringByAppendingPathExtension:@"ls"];
    } else {
        scriptPath = [[NSBundle mainBundle] pathForResource:specified ofType:@"ls"];
    }
    if (!scriptPath || ![[NSFileManager defaultManager] fileExistsAtPath:scriptPath]) {
        if (position == BBLayoutDataPositionDocument) {
            scriptPath = [[documentPath stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"ls"];
        } else {
            scriptPath = [[NSBundle mainBundle] pathForResource:name ofType:@"ls"];
        }
    }
    NSData *lsData = [NSData dataWithContentsOfFile:scriptPath];
    self = [self initWithNibData:nibData andLSData:lsData];
    return self;
}

- (id)initWithNibData:(NSData *)nibData andLSData:(NSData *)lsData {
    UINib *nibObj = [UINib nibWithData:nibData bundle:nil];
    self = [nibObj instantiateWithOwner:nil options:nil].firstObject;
    if (self) {
        if (lsData) {
            NSString *script = [[NSString alloc] initWithData:lsData encoding:NSUTF8StringEncoding];
            [[[BBLSInterpreter alloc] initWithDelegate:self] feed:script];
        }
    }
    return self;
}

- (id)initWithLSNamed:(NSString *)name atPosition:(BBLayoutDataPosition)position {
    NSString *documentPath;
    if (position == BBLayoutDataPositionDocument) {
        documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    NSString *specified = [NSString stringWithFormat:@"%@@%@", name, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"iphone" : @"ipad"];
    NSString *scriptPath;
    if (position == BBLayoutDataPositionDocument) {
        scriptPath = [[documentPath stringByAppendingPathComponent:specified] stringByAppendingPathExtension:@"ls"];
    } else {
        scriptPath = [[NSBundle mainBundle] pathForResource:specified ofType:@"ls"];
    }
    if (!scriptPath || ![[NSFileManager defaultManager] fileExistsAtPath:scriptPath]) {
        if (position == BBLayoutDataPositionDocument) {
            scriptPath = [[documentPath stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"ls"];
        } else {
            scriptPath = [[NSBundle mainBundle] pathForResource:name ofType:@"ls"];
        }
    }
    NSData *lsData = [NSData dataWithContentsOfFile:scriptPath];
    self = [self initWithLSData:lsData];
    return self;
}

- (id)initWithLSData:(NSData *)lsData {
    self = [super init];
    if (self) {
        NSString *script = [[NSString alloc] initWithData:lsData encoding:NSUTF8StringEncoding];
        [[[BBLSInterpreter alloc] initWithDelegate:self] feed:script];
    }
    return self;
}

- (void)extractPositions {
    for (UIView *view in self.subviews) {
        if (view.class == [BBLayoutPosition class]) {
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.layoutViews setObject:view forKey:TAG(view)];
            [self.layoutConstraints setObject:[NSMutableArray array] forKey:TAG(view)];
        }
    }
    for (NSLayoutConstraint *constraint in self.constraints) {
        NSArray *layoutPos = self.layoutViews.allValues;
        if ([layoutPos containsObject:constraint.firstItem] && [layoutPos containsObject:constraint.secondItem]) {
            BBLayoutConstraintGeneratorBoth *generator = [[BBLayoutConstraintGeneratorBoth alloc] initWithPositionDictionary:self.layoutViews andConstraint:constraint];
            [((NSMutableArray *)[self.layoutConstraints objectForKey:TAG(constraint.firstItem)]) addObject:generator];
            [((NSMutableArray *)[self.layoutConstraints objectForKey:TAG(constraint.secondItem)]) addObject:generator];
        } else if ([layoutPos containsObject:constraint.firstItem]) {
            BBLayoutConstraintGeneratorFirst *generator = [[BBLayoutConstraintGeneratorFirst alloc] initWithPositionDictionary:self.layoutViews andConstraint:constraint];
            [((NSMutableArray *)[self.layoutConstraints objectForKey:TAG(constraint.firstItem)]) addObject:generator];
        } else if ([layoutPos containsObject:constraint.secondItem]) {
            BBLayoutConstraintGeneratorSecond *generator = [[BBLayoutConstraintGeneratorSecond alloc] initWithPositionDictionary:self.layoutViews andConstraint:constraint];
            [((NSMutableArray *)[self.layoutConstraints objectForKey:TAG(constraint.secondItem)]) addObject:generator];
        }
    }
}

- (void)reloadData {
    if (self.layoutViews) {
        if (self.dataSource) {
            for (NSNumber *tag in self.layoutConstraints) {
                for (BBLayoutConstraintGenerator *generator in [self.layoutConstraints objectForKey:tag]) {
                    NSLayoutConstraint *destroyed = generator.destroyed;
                    if ([self.constraints containsObject:destroyed]) {
                        [super removeConstraint:destroyed];
                    }
                }
            }
            for (NSNumber *tag in self.layoutViews.allKeys) {
                UIView *view = [self.dataSource layoutView:self viewForPositionTagged:tag.integerValue];
                if (!view) {
                    view = [[BBLayoutPosition alloc] init];
                }
                view.tag = tag.integerValue;
                view.translatesAutoresizingMaskIntoConstraints = NO;
                UIView *old = [self.layoutViews objectForKey:tag];
                [self.layoutViews setObject:view forKey:tag];
                [self insertSubview:view aboveSubview:old];
                [old removeFromSuperview];
            }
            for (NSNumber *tag in self.layoutConstraints) {
                for (BBLayoutConstraintGenerator *generator in [self.layoutConstraints objectForKey:tag]) {
                    NSLayoutConstraint *generated = generator.generated;
                    if (![self.constraints containsObject:generated]) {
                        [super addConstraint:generated];
                    }
                }
            }
        }
    }
}

- (void)replacePositionTagged:(NSInteger)tag withView:(UIView *)view {
    if (self.layoutViews) {
        for (BBLayoutConstraintGenerator *generator in [self.layoutConstraints objectForKey:INTNUM(tag)]) {
            [super removeConstraint:generator.destroyed];
        }
        if (!view) {
            view = [[BBLayoutPosition alloc] init];
        }
        view.tag = tag;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        UIView *old = [self.layoutViews objectForKey:INTNUM(tag)];
        [self.layoutViews setObject:view forKey:INTNUM(tag)];
        [self insertSubview:view aboveSubview:old];
        [old removeFromSuperview];
        for (BBLayoutConstraintGenerator *generator in [self.layoutConstraints objectForKey:INTNUM(tag)]) {
            [super addConstraint:generator.generated];
        }
    }
}

- (BBLayoutPosition *)addPositionWithTag:(NSInteger)tag {
    BBLayoutPosition *position = [[BBLayoutPosition alloc] init];
    position.tag = tag;
    [self.layoutViews setObject:position forKey:INTNUM(tag)];
    [self.layoutConstraints setObject:[NSMutableArray array] forKey:INTNUM(tag)];
    [self addSubview:position];
    return position;
}

- (void)addPositionSubview:(UIView *)view withTag:(NSInteger)tag {
    view.tag = tag;
    [self.layoutViews setObject:view forKey:INTNUM(tag)];
    [self.layoutConstraints setObject:[NSMutableArray array] forKey:INTNUM(tag)];
    [self addSubview:view];
}

- (void)addConstraint:(NSLayoutConstraint *)constraint {
    [super addConstraint:constraint];
    NSArray *layoutPos = self.layoutViews.allValues;
    if ([layoutPos containsObject:constraint.firstItem] && [layoutPos containsObject:constraint.secondItem]) {
        BBLayoutConstraintGeneratorBoth *generator = [[BBLayoutConstraintGeneratorBoth alloc] initWithPositionDictionary:self.layoutViews andConstraint:constraint];
        [((NSMutableArray *)[self.layoutConstraints objectForKey:TAG(constraint.firstItem)]) addObject:generator];
        [((NSMutableArray *)[self.layoutConstraints objectForKey:TAG(constraint.secondItem)]) addObject:generator];
    } else if ([layoutPos containsObject:constraint.firstItem]) {
        BBLayoutConstraintGeneratorFirst *generator = [[BBLayoutConstraintGeneratorFirst alloc] initWithPositionDictionary:self.layoutViews andConstraint:constraint];
        [((NSMutableArray *)[self.layoutConstraints objectForKey:TAG(constraint.firstItem)]) addObject:generator];
    } else if ([layoutPos containsObject:constraint.secondItem]) {
        BBLayoutConstraintGeneratorSecond *generator = [[BBLayoutConstraintGeneratorSecond alloc] initWithPositionDictionary:self.layoutViews andConstraint:constraint];
        [((NSMutableArray *)[self.layoutConstraints objectForKey:TAG(constraint.secondItem)]) addObject:generator];
    }
}

- (void)addConstraints:(NSArray *)constraints {
    for (NSLayoutConstraint *constraint in constraints) {
        [self addConstraint:constraint];
    }
}

- (void)removeConstraint:(NSLayoutConstraint *)constraint {
    [super removeConstraint:constraint];
    for (NSMutableArray *constraints in self.layoutConstraints.allValues) {
        for (BBLayoutConstraintGenerator *generator in constraints.copy) {
            if (generator.generatedConstraint == constraint) {
                [constraints removeObject:generator];
            }
        }
    }
}

- (void)removeConstraints:(NSArray *)constraints {
    for (NSLayoutConstraint *constraint in constraints) {
        [self removeConstraint:constraint];
    }
}

- (void)feedLayoutScript:(NSString *)script {
    [[[BBLSInterpreter alloc] initWithDelegate:self] feed:script];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    BBLSDeviceOrientation currentOrientationIndex = CURRENT_ORIENTATION_INDEX;
    for (NSNumber *tag in self.layoutCornerRadii) {
        if (tag.integerValue == LS_ALL) {
            for (UIView *view in self.layoutViews.allValues) {
                view.layer.cornerRadius = ((NSNumber *)[((NSArray *)[self.layoutCornerRadii objectForKey:tag]) objectAtIndex:currentOrientationIndex]).floatValue;
            }
        } else {
            ((UIView *)[self.layoutViews objectForKey:tag]).layer.cornerRadius = ((NSNumber *)[((NSArray *)[self.layoutCornerRadii objectForKey:tag]) objectAtIndex:currentOrientationIndex]).floatValue;
        }
    }
}

# pragma mark - BBLSInterpreterDelegate implementation

- (void)interpreter:(BBLSInterpreter *)interpreter addPositionWithTag:(NSInteger)tag {
    [self addPositionWithTag:tag];
}

- (void)interpreter:(BBLSInterpreter *)interpreter addConstraintWithTag:(NSInteger)tag1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toTag:(NSInteger)tag2 attribute:(NSLayoutAttribute)attr2 multiplier:(float)mul constant:(float)cons priority:(UILayoutPriority)priority {
    UIView *view1;
    if (tag1 == LS_PARENT) {
        view1 = self;
    } else if (tag1 == LS_NONE) {
        view1 = nil;
    } else if ([self.layoutViews.allKeys containsObject:INTNUM(tag1)]) {
        view1 = [self.layoutViews objectForKey:INTNUM(tag1)];
    } else {
        view1 = [self viewWithTag:tag1];
    }
    UIView *view2;
    if (tag2 == LS_PARENT) {
        view2 = self;
    } else if (tag2 == LS_NONE) {
        view2 = nil;
    } else if ([self.layoutViews.allKeys containsObject:INTNUM(tag2)]) {
        view2 = [self.layoutViews objectForKey:INTNUM(tag2)];
    } else {
        view2 = [self viewWithTag:tag2];
    }
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view1 attribute:attr1 relatedBy:relation toItem:view2 attribute:attr2 multiplier:mul constant:cons];
    constraint.priority = priority;
    [self addConstraint:constraint];
}

- (void)interpreter:(BBLSInterpreter *)interpreter setCornerRadiusOfTag:(NSInteger)tag value:(float)value forOrientation:(BBLSDeviceOrientation)orientation {
    if (tag == LS_ALL || [self.layoutViews.allKeys containsObject:INTNUM(tag)]) {
        NSMutableArray *pair;
        if ([self.layoutCornerRadii.allKeys containsObject:INTNUM(tag)]) {
            pair = [self.layoutCornerRadii objectForKey:INTNUM(tag)];
        } else {
            pair = [NSMutableArray arrayWithObjects:INTNUM(0), INTNUM(0), nil];
        }
        if (orientation == BBLSDeviceOrientationLandscape || orientation == BBLSDeviceOrientationUniversal) {
            [pair replaceObjectAtIndex:BBLSDeviceOrientationLandscape withObject:FLOATNUM(value)];
        }
        if (orientation == BBLSDeviceOrientationPortrait || orientation == BBLSDeviceOrientationUniversal) {
            [pair replaceObjectAtIndex:BBLSDeviceOrientationPortrait withObject:FLOATNUM(value)];
        }
        [self.layoutCornerRadii setObject:pair forKey:INTNUM(tag)];
    }
}

@end
