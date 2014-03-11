//
//  BBViewController.m
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/11/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

#import "BBViewController.h"

@implementation BBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    BBLayoutView *view = [[BBLayoutView alloc] initWithNibNamed:@"TestLayout"];
    view.dataSource = self;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:view];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    // Method 1
    UIView *subview = [[UIView alloc] init];
    subview.backgroundColor = [UIColor redColor];
    [view replacePositionTagged:0 withView:subview];
    
    // Method 2
    [view reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)layoutView:(BBLayoutView *)layoutView viewForPositionTagged:(NSInteger)tag {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor greenColor];
    return view;
}

@end
