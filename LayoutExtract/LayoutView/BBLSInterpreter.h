//
//  BBLSInterpreter.h
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/14/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

static const NSInteger LS_ALL = INT_MAX;
static const NSInteger LS_PARENT = INT_MAX - 1;
static const NSInteger LS_NONE = INT_MIN;

typedef enum {
    BBLSDeviceOrientationLandscape,
    BBLSDeviceOrientationPortrait,
    BBLSDeviceOrientationUniversal
} BBLSDeviceOrientation;

@class BBLSInterpreter;

@protocol BBLSInterpreterDelegate <NSObject>

- (void)interpreter:(BBLSInterpreter *)interpreter addPositionWithTag:(NSInteger)tag;
- (void)interpreter:(BBLSInterpreter *)interpreter addConstraintWithTag:(NSInteger)tag1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toTag:(NSInteger)tag2 attribute:(NSLayoutAttribute)attr2 multiplier:(float)mul constant:(float)cons priority:(UILayoutPriority)priority forOrientation:(BBLSDeviceOrientation)orientation;
- (void)interpreter:(BBLSInterpreter *)interpreter setCornerRadiusOfTag:(NSInteger)tag value:(float)value forOrientation:(BBLSDeviceOrientation)orientation;

@end

@interface BBLSInterpreter : NSObject

- (id)initWithDelegate:(id<BBLSInterpreterDelegate>)delegate;
- (void)feed:(NSString *)script;

@end
