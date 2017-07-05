# SureOFOCopy
######前言
最近升级小黄车到最新版本，发现ofo与小黄人合作，生产了一批小黄人版小黄车，甚是可爱啊～，并且App的界面也进行了相应的效果改变，用车按钮变成了小黄人的头像，小黄人的眼睛还可以跟随设备的倾斜进行转动。很是灵动啊！为小黄车的PM点个赞！
![ofo效果](http://upload-images.jianshu.io/upload_images/1767950-a458853c7171f2aa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

作为一只程序猿，心心念念的当然是如何实现这个效果！刚好最近工作不太忙，遂决定手动仿照下～纯属娱乐，大神勿喷。若有更好的实现方式请联系我。

######正文
首先在iTunes上下载了ofo的ipa，解压拿到了素材文件。
![素材](http://upload-images.jianshu.io/upload_images/1767950-c88d66cd8e42a138.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
本以为还要为背景做个模糊的阴影效果，没想到素材中背景已经添加好阴影，那这部就可以略掉啦。看来ofo的设计大大们对于程序猿们还是很贴心的。

首先我们自定义View，添加上小黄人的脸并给他戴上眼镜。
```
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.grassImageView];
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
- (void)layoutSubviews {
    [super layoutSubviews];
    _backgroundImageView.frame = self.bounds;
    _grassImageView.frame = self.bounds;
}
```
这部分代码很基础，没什么要说的，懒加载声明控件，在**layoutSubviews**中调解对应坐标即可。
通过如上代码我们目前可以实现如下效果

![效果图](http://upload-images.jianshu.io/upload_images/1767950-3d60cba76fd7b5a8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

接下来就到最重要的部分啦，就是为小黄人添加眼睛，并且使眼球可以跟随设备倾斜而转动。

我们公开类**SureMinionsEyesView**用于书写眼睛视图。对于眼睛跟随设备倾斜而转动的效果，我们需要通过重力感应来实现。对于重力感应，我们需要使用**iOS**中的**CoreMotion**框架。其中包括加速计、陀螺仪、磁力计等。代码中我们需要使用**CMMotionManager**对象进行响应功能的实现。

**CMMotionManager**的基本使用步骤为实例化->判断功能是否可用->设置更新频率->开启更新监测。代码如下，已添加必要注释
```
@property (nonatomic, strong) CMMotionManager *motionManager;

_motionManager = [[CMMotionManager alloc] init];
//判断加速计是否可用
if ([_motionManager isAccelerometerAvailable]){
    //设置更新频率0.01为100HZ
    _motionManager.accelerometerUpdateInterval = 0.01;
    //开启更新监测
    [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        if (!error) {
    
        } else {
             NSLog(@"%@",error);
        }
    }];
}
```
**withHandler**这个**Block**中的**accelerometerData**参数可获得当前设备x，y，z轴的加速度。因此我们可以根据当前加速度动态的更新眼球的位置，并且需要保证眼球不会超出眼眶的范围。
```
//眼球将要移动到的x轴坐标
CGFloat pointX = _eyesImageView.center.x + accelerometerData.acceleration.x * _velocity;
//眼球将要移动到的y轴坐标
CGFloat pointY = _eyesImageView.center.y - accelerometerData.acceleration.y * _velocity;
//限制眼球不能超出眼眶范围
if (pointX < _eyesImageView.bounds.size.width / 2) {
    pointX = _eyesImageView.bounds.size.width / 2;
} else if(pointX > self.bounds.size.width - _eyesImageView.bounds.size.width / 2){
    pointX = self.bounds.size.width - _eyesImageView.bounds.size.width / 2;
}
if (pointY < _eyesImageView .bounds.size.height / 2) {
    pointY = _eyesImageView.bounds.size.height / 2;
}else if (pointY > self.bounds.size.height - _eyesImageView.bounds.size.height / 2){
    pointY = self.bounds.size.height - _eyesImageView.bounds.size.height / 2;
}
//更新眼睛位置
_eyesImageView.center = CGPointMake(pointX, pointY);
```
通过如上代码我们即可让眼球跟随设备倾斜而移动，并且将其限制在眼眶范围内，但是存在的问题是，当前眼眶也就是self为正方形，因此当眼球移动到边角位置时就会出现如下效果，明显效果很不美观。

![眼球处于眼眶边角位置](http://upload-images.jianshu.io/upload_images/1767950-1a6d091e8e0974c1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

因此我们需要将眼球的移动范围再加以限制，使得其移动在圆形的范围中。具体的实现为通过**UIBezierPath**绘制圆，判断当前眼球的中心点是否在圆内，若在圆外获取当前眼球中心点和圆点之间的直线，得到直线与当前圆的交点坐标。这一部分耗费了一些时间，毕竟一些数学知识早已还给老师们了。。。这里大家可以仔细想想，思路如图：

![思路图](http://upload-images.jianshu.io/upload_images/1767950-cfe3d3f1a03c6bbb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

代码如下
```
//半径
CGFloat r = self.bounds.size.width / 2 - self.eyesImageView.bounds.size.width / 2;
//圆点
CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.width / 2);
//当前眼睛中心点
CGPoint currentPoint = _eyesImageView.center;

UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.eyesImageView.bounds.size.width / 2, self.eyesImageView.bounds.size.width / 2, self.bounds.size.width  - self.eyesImageView.bounds.size.width , self.bounds.size.width - self.eyesImageView.bounds.size.width)];
//判断眼睛是否在圆内
if (CGPathContainsPoint(path.CGPath, NULL, self.eyesImageView.center, NO)) {
    //在圆内
}else{//在圆外
    CGFloat distance = sqrt(pow(center.x - currentPoint.x, 2) + pow(currentPoint.y - center.y, 2));
    
    CGFloat x = center.x - r / distance * (center.x - currentPoint.x);
    CGFloat y = center.y + r / distance * (currentPoint.y - center.y);
    
    self.eyesImageView.center = CGPointMake(x, y);
}
```
通过如上代码的再次限制，我们即可实现眼球在圆形范围内移动的效果了。最终效果图如下。
![最终效果图.gif](http://upload-images.jianshu.io/upload_images/1767950-de41c870c6e6ee7b.gif?imageMogr2/auto-orient/strip)

另外ofo客户端中眼球自身还可进行旋转，初步猜测是使用了重力感应中的陀螺仪，可监测当前设备x，y，z轴的角度变化，从而更新眼球的旋转角度，时间和精力有限就没有进行实现，有兴趣的童鞋可以进行尝试哦～demo中获取角度变化代码已添加，可打开注释进行测试。
```
_motionManager.gyroUpdateInterval = 0.01;
[_motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
    NSLog(@"%f%f%f",gyroData.rotationRate.x,gyroData.rotationRate.y,gyroData.rotationRate.z);
}];
```
暂时写到这里，demo已上传GitHub，需要的童鞋可进行下载
[https://github.com/LSure/SureOFOCopy](https://github.com/LSure/SureOFOCopy)
**⚠️注意：demo需真机运行～纯属娱乐～**
简书地址：http://www.jianshu.com/u/57d9688d4e1f
