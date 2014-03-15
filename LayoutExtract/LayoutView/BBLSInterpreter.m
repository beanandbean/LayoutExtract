//
//  BBLSInterpreter.m
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/14/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

#import "BBLSInterpreter.h"

static NSRegularExpression *g_floatPropertyExpression;

@interface BBLSInterpreter ()

@property (weak, nonatomic) id<BBLSInterpreterDelegate> delegate;

@end

@implementation BBLSInterpreter

// $(TAG).PROP = [-]VALUE
//
// SPACE ---- \\s*
//    $( ---- \\$\\(
//   TAG -01- ([0123456789]+|\\*)
//     ) ---- \\)
// SPACE ---- \\s*
//     . ---- \\.
// SPACE ---- \\s*
//  PROP -02- ([abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]+)
// SPACE ---- \\s*
//     = ---- =
// SPACE ---- \\s*
// VALUE B03- (
//  NEGA -04- (-)?
// VALUE -03- [01234567890]+
//  DECI -05- (\\.[0123456789]+)?
// VALUE E03- )
// SPACE ---- \\s*
+ (NSRegularExpression *)floatPropertyExpression {
    if (!g_floatPropertyExpression) {
        g_floatPropertyExpression = [NSRegularExpression regularExpressionWithPattern:@"\\s*\\$\\(([0123456789]+|\\*)\\)\\s*\\.\\s*([abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]+)\\s*=\\s*((-)?[01234567890]+(\\.[0123456789]+)?)\\s*" options:0 error:nil];
    }
    return g_floatPropertyExpression;
}

- (id)initWithDelegate:(id<BBLSInterpreterDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)feed:(NSString *)script {
    NSArray *lines = [script componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString *line in lines) {
        [self feedLine:line];
    }
}

- (void)feedLine:(NSString *)line {
    NSTextCheckingResult *result = [[BBLSInterpreter floatPropertyExpression] firstMatchInString:line options:0 range:NSMakeRange(0, line.length)];
    if (result.range.location != NSNotFound && result.range.length == line.length) {
        NSString *tagString = [line substringWithRange:[result rangeAtIndex:1]];
        NSInteger tag;
        if ([tagString isEqualToString:@"*"]) {
            tag = LS_ALL;
        } else {
            tag = tagString.integerValue;
        }
        NSString *property = [line substringWithRange:[result rangeAtIndex:2]];
        float value = [line substringWithRange:[result rangeAtIndex:3]].floatValue;
        [self.delegate interpreter:self floatPropertyAssignmentDetectedToProperty:property ofTag:tag withValue:value];
    }
}

@end
