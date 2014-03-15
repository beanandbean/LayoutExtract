//
//  BBLayoutView.h
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/11/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

#import "BBLayoutPosition.h"

#import "BBLSInterpreter.h"

typedef enum {
    BBLayoutDataPositionBundle,
    BBLayoutDataPositionDocument
} BBLayoutDataPosition;

@class BBLayoutView;

@protocol BBLayoutViewDataSource <NSObject>

- (UIView *)layoutView:(BBLayoutView *)layoutView viewForPositionTagged:(NSInteger)tag;

@end

@interface BBLayoutView : UIView <BBLSInterpreterDelegate>

@property (strong, nonatomic) id<BBLayoutViewDataSource> dataSource;

- (id)initWithNibNamed:(NSString *)nib atPosition:(BBLayoutDataPosition)position;
- (id)initWithNibData:(NSData *)nibData andLSData:(NSData *)lsData;

- (void)reloadData;

- (void)replacePositionTagged:(NSInteger)tag withView:(UIView *)view;

- (BBLayoutPosition *)addPositionWithTag:(NSInteger)tag;
- (void)addPositionConstraint:(NSLayoutConstraint *)constraint;

- (void)feedLayoutScript:(NSString *)script;

@end
