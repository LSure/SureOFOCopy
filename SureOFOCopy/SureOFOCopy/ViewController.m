//
//  ViewController.m
//  SureOFOCopy
//
//  Created by 刘硕 on 2017/7/3.
//  Copyright © 2017年 刘硕. All rights reserved.
//

#import "ViewController.h"
#import "SureMinionsView.h"
@interface ViewController ()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    SureMinionsView *minionsView = [[SureMinionsView alloc]initWithFrame:CGRectMake(0, 0, 190, 190)];
    minionsView.center = self.view.center;
    [self.view addSubview:minionsView];
}
@end
