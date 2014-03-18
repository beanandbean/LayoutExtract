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
    
    [self initializeLayoutViewForLayout:@"Layout18"];
    self.segmentedControl.selectedSegmentIndex = 0;
}

- (void)initializeLayoutViewForLayout:(NSString *)layout {
    if (layout) {
        if ([layout isEqualToString:@"LayoutLS"]) {
            self.layoutView = [[BBLayoutView alloc] initWithLSNamed:layout atPosition:BBLayoutDataPositionBundle];
        } else {
            self.layoutView = [[BBLayoutView alloc] initWithNibNamed:layout atPosition:BBLayoutDataPositionBundle];
        }
    } else {
        self.layoutView = [[BBLayoutView alloc] init];
        NSMutableArray *positions = [NSMutableArray arrayWithCapacity:8];
        for (int i = 0; i < 8; i++) {
            [positions addObject:[[UIView alloc] init]];
            [self.layoutView addPositionSubview:[positions objectAtIndex:i] withTag:i];
        }
        for (int i = 0; i < 7; i++) {
            [self.layoutView addConstraint:[NSLayoutConstraint constraintWithItem:[positions objectAtIndex:i] attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:[positions objectAtIndex:i + 1] attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-8.0]];
            [self.layoutView addConstraint:[NSLayoutConstraint constraintWithItem:[positions objectAtIndex:i] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[positions objectAtIndex:i + 1] attribute:NSLayoutAttributeTop multiplier:1.0 constant:-8.0]];
            [self.layoutView addConstraint:[NSLayoutConstraint constraintWithItem:[positions objectAtIndex:i] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:[positions objectAtIndex:i + 1] attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
            [self.layoutView addConstraint:[NSLayoutConstraint constraintWithItem:[positions objectAtIndex:i] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:[positions objectAtIndex:i + 1] attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
        }
        [self.layoutView addConstraint:[NSLayoutConstraint constraintWithItem:positions.firstObject attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.layoutView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:21.0]];
        [self.layoutView addConstraint:[NSLayoutConstraint constraintWithItem:positions.firstObject attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.layoutView attribute:NSLayoutAttributeTop multiplier:1.0 constant:21.0]];
        [self.layoutView addConstraint:[NSLayoutConstraint constraintWithItem:positions.lastObject attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.layoutView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-21.0]];
        [self.layoutView addConstraint:[NSLayoutConstraint constraintWithItem:positions.lastObject attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.layoutView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-21.0]];
        [self.layoutView feedLayoutScript:@"$(*).cornerRadius = 5"];
    }
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
}

- (UIView *)layoutView:(BBLayoutView *)layoutView viewForPositionTagged:(NSInteger)tag {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHue:1.0 / 8 * tag saturation:1.0 brightness:1.0 alpha:1.0];
    return view;
}

- (IBAction)segmentedControlValueChanged:(id)sender {
    [self.layoutView removeFromSuperview];
    NSString *nib;
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            nib = @"Layout18";
            break;
            
        case 1:
            nib = @"Layout24";
            break;
            
        case 2:
            nib = @"Layout33";
            break;
            
        case 4:
            nib = @"LayoutLS";
            break;
            
        default:
            nib = nil;
            break;
    }
    [self initializeLayoutViewForLayout:nib];
}

@end
