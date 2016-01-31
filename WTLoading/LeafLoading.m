//
//  LeafLoading.m
//  WTLoading
//
//  Created by Yorke on 16/1/30.
//  Copyright © 2016年 WuTong. All rights reserved.
//

#import "LeafLoading.h"
#import "Leaf.h"

#define mArcRadius 14.0f
#define mBorderWidth 6.0f

@interface LeafLoading ()

@property (nonatomic, strong) UIImageView *fengshan;
@property (nonatomic, strong) UILabel *completionLabel;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) NSArray *leafs;

@end

@implementation LeafLoading

- (instancetype)init{
    if(self = [super initWithFrame:CGRectMake(0, 0, 200, 40)]){
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *bgColorView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        bgColorView.image = [UIImage imageNamed:@"leaf_bg"];
        [self addSubview:bgColorView];
        
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        bgImageView.image = [UIImage imageNamed:@"leaf_kuang"];
        [self addSubview:bgImageView];
        
        _fengshan = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
        _fengshan.image = [UIImage imageNamed:@"fengshan"];
        _fengshan.center = CGPointMake(200 - 20, 20);
        [self addSubview:_fengshan];
        
        _completionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
        _completionLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:18];
        _completionLabel.text = @"100%";
        _completionLabel.textColor = [UIColor whiteColor];
        _completionLabel.adjustsFontSizeToFitWidth = YES;
        _completionLabel.alpha = 0;
        _completionLabel.center = CGPointMake(200 - 20, 20);
        [self addSubview:_completionLabel];
        
        _leafs = [self generateLeafs];
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(fengshanEvent:)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}
                        
- (void)fengshanEvent:(id)sender{
    if(_progress >= 1.0f) {
        [_displayLink invalidate];
        _fengshan.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.5 animations:^{
            CGFloat radius = 8;
            _fengshan.frame = CGRectMake(200 - 20 - radius, 20 - radius, radius * 2, radius * 2);
            _fengshan.alpha = 0;
            
            _completionLabel.frame = CGRectMake(200 - 20 - 16, 20 - 16, 16 * 2, 16 * 2);
            _completionLabel.alpha = 1;
        }];
    }else{
        _fengshan.transform = CGAffineTransformRotate(_fengshan.transform, -M_PI_2 / 20);
        
        if(_progress <= 0.000001){
            
        }else if (_progress < 0.4){
            _progress += 0.003;
        }else{
            _progress += 0.005;
        }
        
        [self setNeedsDisplay];
    }
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    if(_progress >= 1.0f) {
        [_displayLink invalidate];
    }else{
        _leafs = [self generateLeafs];
        CGFloat radius = 16;
        _fengshan.frame = CGRectMake(200 - 20 - radius, 20 - radius, radius * 2, radius * 2);
        _fengshan.alpha = 1;
        
        _completionLabel.frame = CGRectMake(200 - 20 - 8, 20 - 8, 8 * 2, 8 * 2);
        _completionLabel.alpha = 0;
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(fengshanEvent:)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)drawRect:(CGRect)rect{
    //大白背景
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetRGBFillColor(context, 0.99, 0.88, 0.58, 1.0f);
    CGContextMoveToPoint(context, mArcRadius + mBorderWidth, mBorderWidth);
    CGContextAddArc(context, mArcRadius + mBorderWidth, mBorderWidth + mArcRadius, mArcRadius, -M_PI_2, M_PI_2, 1);
    CGContextAddLineToPoint(context, (200 - 10) - mArcRadius - mBorderWidth, mArcRadius * 2 + mBorderWidth);
    CGContextAddLineToPoint(context, (200 - 10) - mArcRadius - mBorderWidth, mBorderWidth);
    CGContextClosePath(context);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    //进度背景
    CGContextSaveGState(context);
    CGFloat currentProcessPosition = (200 - 10) * _progress + mBorderWidth;
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
        CGContextSaveGState(context);
        if(currentTime > leaf.startTime && leaf.startTime != 0){
            if((currentTime - leaf.startTime) / LEAF_FLOAT_TIME > 0.95) {
                if(leaf.endTime <= 0.000001){
                    leaf.endTime = currentTime;
                    _progress += 0.005;
                }
            }else{
                leaf.x = (1 - (currentTime - leaf.startTime) / LEAF_FLOAT_TIME) * (200 - 10);
                leaf.y = [self getLocationY:leaf];
                CGFloat angle = (currentTime - leaf.startTime) * 2 * M_PI / LEAF_ROTATE_TIME;
                CGFloat rotateFraction = leaf.rotateDirection == 0 ? angle + leaf.rotateAngle / 180.0 * M_PI : -angle + leaf.rotateAngle / 180.0 * M_PI;
                CGContextRotateCTM(context, rotateFraction);
                CGContextDrawImage(context, CGRectMake(leaf.x * cos(rotateFraction) + leaf.y * sin(rotateFraction), -leaf.x * sin(rotateFraction) + leaf.y * cos(rotateFraction), 16, 8), [UIImage imageNamed:@"leaf"].CGImage);
            };
        }
        CGContextRestoreGState(context);
    }
}

- (NSArray *)generateLeafs{
    NSMutableArray *temp = [NSMutableArray array];
    for(int i = 0; i < MAX_LEAFS; i++){
        [temp addObject:[Leaf generateLeaf]];
    }
    return temp;
}

- (CGFloat)getLocationY:(Leaf *)leaf{
    // y = A(wx + Q) + h
    CGFloat w = 2 * M_PI / (200 - 10);
    CGFloat a = MIDDLE_AMPLITUDE;
    switch (leaf.type) {
        case StartTypeLittle:
            a = MIDDLE_AMPLITUDE - AMPLITUDE_DISPARITY;
            break;
        case StartTypeMiddle:
            a = MIDDLE_AMPLITUDE;
            break;
        case StartTypeBig:
            a = MIDDLE_AMPLITUDE + AMPLITUDE_DISPARITY;
            break;
    }
    return a * sin(w * leaf.x) + mArcRadius + mBorderWidth;
}

@end
