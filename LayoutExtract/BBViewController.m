//
//  BBViewController.m
//  LayoutExtract
//
//  Created by Wang Shuwei on 3/11/14.
//  Copyright (c) 2014 Bean & Bean. All rights reserved.
//

#import "BBViewController.h"

@interface BBViewController ()

@property (strong, nonatomic) BBLayoutView *layoutView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation BBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self initializeLayoutViewForLayout:@"Layout24"];
    self.segmentedControl.selectedSegmentIndex = 1;
}

- (void)initializeLayoutViewForLayout:(NSString *)layout {
    self.layoutView = [[BBLayoutView alloc] initWithNibNamed:layout];
    self.layoutView.dataSource = self;
    self.layoutView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.layoutView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.layoutView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.segmentedControl attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.layoutView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.layoutView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.layoutView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
   
    [self.layoutView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)layoutView:(BBLayoutView *)layoutView viewForPositionTagged:(NSInteger)tag {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHue:1.0 / 8 * tag saturation:1.0 brightness:1.0 alpha:1.0];
    return view;
}

- (IBAction)segmentedControlValueChanged:(id)sender {
    [self.layoutView removeFromSuperview];
    [self initializeLayoutViewForLayout:self.segmentedControl.selectedSegmentIndex ? @"Layout24" : @"Layout18"];
}

@end
