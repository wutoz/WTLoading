//
//  LeafLoading.m
//  WTLoading
//
//  Created by Yorke on 16/1/30.
//  Copyright © 2016年 WuTong. All rights reserved.
//

#import "LeafLoading.h"
#import "Leaf.h"
#import "LeafFan.h"

#define mArcRadius 14.0f
#define mBorderWidth 6.0f
#define mLoadingH 40.0f
#define mLoadingW 200.0f
#define mFanW 32.0f

#define mSepPos 0.4f
#define mSpeed1 0.002f
#define mSpeed2 0.003f
#define mSpeed3 0.004f

@interface LeafLoading ()

@property (nonatomic, strong) LeafFan *fan;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) NSArray *leafs;

@end

@implementation LeafLoading

- (instancetype)init{
    if(self = [super initWithFrame:CGRectMake(0, 0, mLoadingW, mLoadingH)]){
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *bgColorView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mLoadingW, mLoadingH)];
        bgColorView.image = [UIImage imageNamed:@"leaf_bg"];
        [self addSubview:bgColorView];
        
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mLoadingW, mLoadingH)];
        bgImageView.image = [UIImage imageNamed:@"leaf_kuang"];
        [self addSubview:bgImageView];
        
        _fan = [[LeafFan alloc]initWithFrame:CGRectMake(0, 0, mFanW, mFanW)];
        _fan.center = CGPointMake(mLoadingW - mLoadingH / 2, mLoadingH / 2);
        [self addSubview:_fan];
        
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [_fan setCompletion:NO];
    _leafs = [self generateLeafs];
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(fengshanEvent:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    if (_progress >= 1.0f) {
        [_displayLink invalidate];
    } else {
        [self setUp];
    }
}

- (void)fengshanEvent:(id)sender{
    if(_progress >= 1.0f) {
        [_displayLink invalidate];
        [_fan setCompletion:YES];
    }else{
        _fan.transform = CGAffineTransformRotate(_fan.transform, -M_PI_2 / 20);
        [self setNeedsDisplay];
        
        if(_progress <= 0.000001) return;
        
        if (_progress < mSepPos) {
            _progress += mSpeed1;
        }else{
            _progress += mSpeed3;
        }
    }
}

- (void)drawRect:(CGRect)rect{
    //大白背景
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetRGBFillColor(context, 0.99, 0.88, 0.58, 1.0f);
    CGContextMoveToPoint(context, mArcRadius + mBorderWidth, mBorderWidth);
    CGContextAddArc(context, mArcRadius + mBorderWidth, mArcRadius + mBorderWidth, mArcRadius, -M_PI_2, M_PI_2, 1);
    CGContextAddLineToPoint(context, mLoadingW - mArcRadius - mBorderWidth, mArcRadius * 2 + mBorderWidth);
    CGContextAddLineToPoint(context, mLoadingW - mArcRadius - mBorderWidth, mBorderWidth);
    CGContextClosePath(context);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    //进度背景
    CGContextSaveGState(context);
    CGFloat currentProcessPosition = (mLoadingW - mBorderWidth) * _progress + mBorderWidth;
    if(currentProcessPosition < mBorderWidth){
        
    }else if (currentProcessPosition < mArcRadius + mBorderWidth){
        CGFloat angle = acos((mArcRadius - (currentProcessPosition - mBorderWidth)) / mArcRadius);
        CGContextSetRGBFillColor(context, 0.95, 0.64, 0.19, 1.0f);
        CGContextMoveToPoint(context, currentProcessPosition, mBorderWidth + mArcRadius - angle);
        CGContextAddArc(context, mArcRadius + mBorderWidth, mBorderWidth + mArcRadius, mArcRadius, -angle + M_PI, angle + M_PI, 0);
        CGContextAddLineToPoint(context, currentProcessPosition, mBorderWidth + mArcRadius + angle);
        CGContextClosePath(context);
        CGContextFillPath(context);
    }else{
        CGContextSetRGBFillColor(context, 0.95, 0.64, 0.19, 1.0f);
        CGContextMoveToPoint(context, mArcRadius + mBorderWidth, mBorderWidth);
        CGContextAddArc(context, mArcRadius + mBorderWidth, mBorderWidth + mArcRadius, mArcRadius, -M_PI_2, M_PI_2, 1);
        CGContextAddLineToPoint(context, currentProcessPosition, mArcRadius * 2 + mBorderWidth);
        CGContextAddLineToPoint(context, currentProcessPosition, mBorderWidth);
        CGContextClosePath(context);
        CGContextFillPath(context);
    }
    CGContextRestoreGState(context);
    //绘制树叶
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970] * 1000;
    for(Leaf *leaf in self.leafs){
        if(leaf.startTime <= 0.000001){
            leaf.startTime = [[NSDate date] timeIntervalSince1970] * 1000 + arc4random() % (int)(LEAF_FLOAT_TIME * 3);
        }
        CGContextSaveGState(context);
        if(currentTime > leaf.startTime && leaf.startTime != 0){
            if((currentTime - leaf.startTime) / LEAF_FLOAT_TIME <= 0.98) {
                leaf.x = (1 - (currentTime - leaf.startTime) / LEAF_FLOAT_TIME) * mLoadingW;
                leaf.y = [self getLocationY:leaf];
                CGFloat angle = (currentTime - leaf.startTime) * 2 * M_PI / LEAF_ROTATE_TIME;
                CGFloat rotateFraction = leaf.rotateDirection == 0 ? angle + leaf.rotateAngle / 180.0 * M_PI : -angle + leaf.rotateAngle / 180.0 * M_PI;
                CGContextRotateCTM(context, rotateFraction);
                CGContextDrawImage(context, CGRectMake(leaf.x * cos(rotateFraction) + leaf.y * sin(rotateFraction), -leaf.x * sin(rotateFraction) + leaf.y * cos(rotateFraction), 15, 7), [UIImage imageNamed:@"leaf"].CGImage);
            }else{
                if(leaf.endTime <= 0.000001){
                    leaf.endTime = currentTime;
                    _progress += mSpeed2;
                }
            };
        }
        CGContextRestoreGState(context);
    }
}

- (NSArray *)generateLeafs{
    NSMutableArray *temp = [NSMutableArray array];
    for(int i = 0; i < MAX_LEAFS; i++){
        Leaf *leaf = [Leaf generateLeaf];
        [temp addObject:leaf];
    }
    return temp;
}

- (CGFloat)getLocationY:(Leaf *)leaf{
    // y = A(wx + Q) + h
    CGFloat w = 2 * M_PI / mLoadingW;
    CGFloat a = MIDDLE_AMPLITUDE;
    switch (leaf.type) {
        case LeafStartTypeLittle:
            a = MIDDLE_AMPLITUDE - AMPLITUDE_DISPARITY;
            break;
        case LeafStartTypeMiddle:
            a = MIDDLE_AMPLITUDE;
            break;
        case LeafStartTypeBig:
            a = MIDDLE_AMPLITUDE + AMPLITUDE_DISPARITY;
            break;
    }
    return a * sin(w * leaf.x) + mArcRadius + mBorderWidth;
}

@end
