//
//  SureMinionsView.m
//  SureOFOCopy
//
//  Created by 刘硕 on 2017/7/3.
//  Copyright © 2017年 刘硕. All rights reserved.
//

#import "SureMinionsView.h"
#import "SureMinionsEyesView.h"
@interface SureMinionsView ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *grassImageView;
@property (nonatomic, strong) UIImageView *eyesImageView;
@property (nonatomic, strong) SureMinionsEyesView *leftEyeView;
@property (nonatomic, strong) SureMinionsEyesView *rightEyeView;
@end
@implementation SureMinionsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.grassImageView];
        [self addSubview:self.leftEyeView];
        [self addSubview:self.rightEyeView];
    }
    return self;
}

- (UIImageView*)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"minions_background"]];
    }
    return _backgroundImageView;
}

- (UIImageView*)grassImageView {
    if (!_grassImageView) {
        _grassImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"minions_grass"]];
    }
    return _grassImageView;
}

- (UIImageView*)eyesImageView {
    if (!_eyesImageView) {
        _eyesImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"minions_eyes"]];
    }
    return _eyesImageView;
}

- (SureMinionsEyesView*)leftEyeView {
    if (!_leftEyeView) {
        _leftEyeView = [[SureMinionsEyesView alloc]initWithFrame:CGRectZero];
    }
    return _leftEyeView;
}

- (SureMinionsEyesView*)rightEyeView {
    if (!_rightEyeView) {
        _rightEyeView = [[SureMinionsEyesView alloc]initWithFrame:CGRectZero];
    }
    return _rightEyeView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _backgroundImageView.frame = self.bounds;
    _grassImageView.frame = self.bounds;
    _leftEyeView.frame = CGRectMake(50, 50, 40, 40);
    _rightEyeView.frame = CGRectMake(100, 50, 40, 40);
}

@end
