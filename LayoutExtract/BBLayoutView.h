//
//  BBLayoutView.h
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/11/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

#import "BBLSInterpreter.h"

@class BBLayoutView;

@protocol BBLayoutViewDataSource <NSObject>

- (UIView *)layoutView:(BBLayoutView *)layoutView viewForPositionTagged:(NSInteger)tag;

@end

@interface BBLayoutView : UIView <BBLSInterpreterDelegate>

@property (strong, nonatomic) id<BBLayoutViewDataSource> dataSource;

- (id)initWithNibNamed:(NSString *)nib;

- (void)extractPositions;

- (void)replacePositionTagged:(NSInteger)tag withView:(UIView *)view;

- (void)reloadData;

@end
