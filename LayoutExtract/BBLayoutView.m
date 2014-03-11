//
//  BBLayoutView.m
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/11/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

#import "BBLayoutView.h"

#import "BBLayoutPosition.h"

#import "BBLayoutConstraintGeneratorFirst.h"
#import "BBLayoutConstraintGeneratorSecond.h"
#import "BBLayoutConstraintGeneratorBoth.h"

#define INTNUM(int) [NSNumber numberWithInteger:(NSInteger)int]
#define TAG(view) INTNUM(((UIView *)view).tag)

@interface BBLayoutView ()

@property (strong, nonatomic) NSMutableDictionary *layoutViews;
@property (strong, nonatomic) NSMutableDictionary *layoutConstraints;

@end

@implementation BBLayoutView

- (id)initWithNibNamed:(NSString *)nib {
    self = [self initWithNibNamed:nib platformSpecified:NO];
    return self;
}

- (id)initWithNibNamed:(NSString *)nib platformSpecified:(BOOL)specified {
    NSString *name;
    if (specified) {
        name = [NSString stringWithFormat:@"%@@%@", name, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"iphone" : @"ipad"];
    } else {
        name = nib;
    }
    self = [[NSBundle mainBundle] loadNibNamed:name owner:Nil options:nil].firstObject;
    if (self) {
        [self extractPositions];
    }
    return self;
}

- (void)extractPositions {
    self.layoutViews = [NSMutableDictionary dictionary];
    self.layoutConstraints = [NSMutableDictionary dictionary];
    NSMutableSet *layoutPos = [NSMutableSet set];
    for (UIView *view in self.subviews) {
        if (view.class == [BBLayoutPosition class]) {
            [self.layoutViews setObject:[BBLayoutPosition layoutPositionNull] forKey:TAG(view)];
            [self.layoutConstraints setObject:[NSMutableArray array] forKey:TAG(view)];
            [layoutPos addObject:view];
        }
    }
    for (NSLayoutConstraint *constraint in self.constraints) {
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

- (void)replacePositionTagged:(NSInteger)tag withView:(UIView *)view {
    if (self.layoutViews) {
        for (BBLayoutConstraintGenerator *generator in [self.layoutConstraints objectForKey:INTNUM(tag)]) {
            [self removeConstraint:generator.destroyed];
        }
        if (!view) {
            view = [BBLayoutPosition layoutPositionNull];
        }
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

- (void)reloadData {
    if (self.layoutViews) {
        if (self.dataSource) {
            for (NSNumber *tag in self.layoutConstraints) {
                for (BBLayoutConstraintGenerator *generator in [self.layoutConstraints objectForKey:tag]) {
                    NSLayoutConstraint *destroyed = generator.destroyed;
                    if ([self.constraints containsObject:destroyed]) {
                        [self removeConstraint:generator.destroyed];
                    }
                }
            }
            for (NSNumber *tag in self.layoutViews.allKeys) {
                UIView *view = [self.dataSource layoutView:self viewForPositionTagged:tag.integerValue];
                if (!view) {
                    view = [BBLayoutPosition layoutPositionNull];
                }
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

@end