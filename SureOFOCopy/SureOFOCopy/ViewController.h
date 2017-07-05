//
//  ViewController.h
//  SureOFOCopy
//
//  Created by 刘硕 on 2017/7/3.
//  Copyright © 2017年 刘硕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIAccelerometerDelegate>
{
    //我们用一个label来表示随加速度方向运动的小方块
    UIImageView *_label;
    //x轴方向的速度
    UIAccelerationValue _speedX;
    //y轴方向的速度
    UIAccelerationValue _speedY;
    
    UIView *_bgView;
}

@end

