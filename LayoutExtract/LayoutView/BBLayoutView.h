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

- (id)initWithNibNamed:(NSString *)name atPosition:(BBLayoutDataPosition)position;
- (id)initWithNibData:(NSData *)nibData andLSData:(NSData *)lsData;

- (id)initWithLSNamed:(NSString *)name atPosition:(BBLayoutDataPosition)position;
- (id)initWithLSData:(NSData *)lsData;

- (void)reloadData;

- (void)replacePositionTagged:(NSInteger)tag withView:(UIView *)view;

- (BBLayoutPosition *)addPositionWithTag:(NSInteger)tag;
- (void)addPositionSubview:(UIView *)view withTag:(NSInteger)tag;

- (void)feedLayoutScript:(NSString *)script;

@end
