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

- (id)initWithNibNamed:(NSString *)nib atPosition:(BBLayoutDataPosition)position {
    NSString *documentPath;
    if (position == BBLayoutDataPositionDocument) {
        documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    NSString *specified = [NSString stringWithFormat:@"%@@%@", nib, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"iphone" : @"ipad"];
    NSString *nibPath;
    if (position == BBLayoutDataPositionDocument) {
        nibPath = [[documentPath stringByAppendingPathComponent:specified] stringByAppendingPathExtension:@"nib"];
    } else {
        nibPath = [[NSBundle mainBundle] pathForResource:specified ofType:@"nib"];
    }
    if (!nibPath || ![[NSFileManager defaultManager] fileExistsAtPath:nibPath]) {
        if (position == BBLayoutDataPositionDocument) {
            nibPath = [[documentPath stringByAppendingPathComponent:nib] stringByAppendingPathExtension:@"nib"];
        } else {
            nibPath = [[NSBundle mainBundle] pathForResource:nib ofType:@"nib"];
        }
    }
    NSData *nibData = [NSData dataWithContentsOfFile:nibPath];
    NSString *scriptPath;
    if (position == BBLayoutDataPositionDocument) {
        scriptPath = [[documentPath stringByAppendingPathComponent:specified] stringByAppendingPathExtension:@"ls"];
    } else {
        nibPath = [[NSBundle mainBundle] pathForResource:specified ofType:@"ls"];
    }
    if (!scriptPath || ![[NSFileManager defaultManager] fileExistsAtPath:scriptPath]) {
        if (position == BBLayoutDataPositionDocument) {
            scriptPath = [[documentPath stringByAppendingPathComponent:nib] stringByAppendingPathExtension:@"ls"];
        } else {
            scriptPath = [[NSBundle mainBundle] pathForResource:nib ofType:@"ls"];
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
        self.layoutViews = [NSMutableDictionary dictionary];
        self.layoutConstraints = [NSMutableDictionary dictionary];
        self.layoutCornerRadii = [NSMutableDictionary dictionary];
        [self extractPositions];
        if (lsData) {
            NSString *script = [[NSString alloc] initWithData:lsData encoding:NSUTF8StringEncoding];
            [[[BBLSInterpreter alloc] initWithDelegate:self] feed:script];
        }
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
                        [self removeConstraint:destroyed];;
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
                        [self addConstraint:generated];
                    }
                }
            }
        }
    }
}

- (void)replacePositionTagged:(NSInteger)tag withView:(UIView *)view {
    if (self.layoutViews) {
        for (BBLayoutConstraintGenerator *generator in [self.layoutConstraints objectForKey:INTNUM(tag)]) {
            [self removeConstraint:generator.destroyed];
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
            [self addConstraint:generator.generated];
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

- (void)addPositionConstraint:(NSLayoutConstraint *)constraint {
    [self addConstraint:constraint];
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

- (void)feedLayoutScript:(NSString *)script {
    [[[BBLSInterpreter alloc] initWithDelegate:self] feed:script];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (NSNumber *tag in self.layoutCornerRadii) {
        if (tag.integerValue == LS_ALL) {
            for (UIView *view in self.layoutViews.allValues) {
                view.layer.cornerRadius = ((NSNumber *)[self.layoutCornerRadii objectForKey:tag]).floatValue;
            }
        } else {
            ((UIView *)[self.layoutViews objectForKey:tag]).layer.cornerRadius = ((NSNumber *)[self.layoutCornerRadii objectForKey:tag]).floatValue;
        }
    }
}

# pragma mark - BBLSInterpreterDelegate implementation

- (void)interpreter:(BBLSInterpreter *)interpreter floatPropertyAssignmentDetectedToProperty:(NSString *)property ofTag:(NSInteger)tag withValue:(float)value {
    if ((tag == LS_ALL || [self.layoutViews.allKeys containsObject:INTNUM(tag)]) && [property isEqualToString:@"cornerRadius"]) {
        [self.layoutCornerRadii setObject:FLOATNUM(value) forKey:INTNUM(tag)];
    }
}

@end
