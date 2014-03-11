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
    self = [[NSBundle mainBundle] loadNibNamed:nib owner:Nil options:nil].firstObject;
    NSMutableSet *layoutPos = [NSMutableSet set];
    if (self) {
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
    return self;
}

- (void)replacePositionTagged:(NSInteger)tag withView:(UIView *)view {
    if (!view) {
        view = [BBLayoutPosition layoutPositionNull];
    }
    view.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *old = [self.layoutViews objectForKey:INTNUM(tag)];
    [self.layoutViews setObject:view forKey:INTNUM(tag)];
    [self insertSubview:view aboveSubview:old];
    [old removeFromSuperview];
    for (BBLayoutConstraintGenerator *generator in [self.layoutConstraints objectForKey:INTNUM(tag)]) {
        [self removeConstraint:generator.destroyed];
        [self addConstraint:generator.generated];
    }
}

- (void)reloadData {
    if (self.dataSource) {
        for (NSNumber *tag in self.layoutViews) {
            [self replacePositionTagged:tag.integerValue withView:[self.dataSource layoutView:self viewForPositionTagged:tag.integerValue]];
        }
    }
}

#pragma mark - Lazy Init

- (NSMutableDictionary *)layoutViews {
    if (!_layoutViews) {
        _layoutViews = [NSMutableDictionary dictionary];
    }
    return _layoutViews;
}

- (NSMutableDictionary *)layoutConstraints {
    if (!_layoutConstraints) {
        _layoutConstraints = [NSMutableDictionary dictionary];
    }
    return _layoutConstraints;
}

@end
