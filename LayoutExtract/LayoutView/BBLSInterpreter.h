//
//  BBLSInterpreter.h
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/14/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

static const NSInteger LS_ALL = INT_MAX;

@class BBLSInterpreter;

@protocol BBLSInterpreterDelegate <NSObject>

- (void)interpreter:(BBLSInterpreter *)interpreter floatPropertyAssignmentDetectedToProperty:(NSString *)property ofTag:(NSInteger)tag withValue:(float)value;

@end

@interface BBLSInterpreter : NSObject

- (id)initWithDelegate:(id<BBLSInterpreterDelegate>)delegate;
- (void)feed:(NSString *)script;

@end
