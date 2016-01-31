//
//  LeafFan.m
//  WTLoading
//
//  Created by Yorke on 16/1/31.
//  Copyright © 2016年 WuTong. All rights reserved.
//

#import "LeafFan.h"

@implementation LeafFan

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        CGFloat radius = frame.size.width / 2;
        _fengshan = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, radius * 2, radius * 2)];
        _fengshan.image = [UIImage imageNamed:@"fengshan"];
        [self addSubview:_fengshan];
        
        _completionLabel = [[UILabel alloc]initWithFrame:CGRectMake(radius / 2, radius / 2, radius, radius)];
        _completionLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:18];
        _completionLabel.text = @"100%";
        _completionLabel.textColor = [UIColor whiteColor];
        _completionLabel.adjustsFontSizeToFitWidth = YES;
        _completionLabel.alpha = 0;
        [self addSubview:_completionLabel];
    }
    return self;
}

- (void)setCompletion:(BOOL)completion{
    _completion = completion;
    self.transform = CGAffineTransformIdentity;
    if(_completion){
        [UIView animateWithDuration:0.5 animations:^{
            CGFloat radius = self.frame.size.width / 2;
            _fengshan.frame = CGRectMake(radius / 2, radius / 2, radius, radius);
            _fengshan.alpha = 0;
            
            _completionLabel.frame = CGRectMake(0, 0, radius * 2, radius * 2);
            _completionLabel.alpha = 1;
        }];
    }else{
        CGFloat radius = self.frame.size.width / 2;
        _fengshan.frame = CGRectMake(0, 0, radius * 2, radius * 2);
        _fengshan.alpha = 1;
        
        _completionLabel.frame = CGRectMake(radius / 2, radius / 2, radius, radius);
        _completionLabel.alpha = 0;
    }
}

@end
