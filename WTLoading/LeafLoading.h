//
//  LeafLoading.h
//  WTLoading
//
//  Created by Yorke on 16/1/30.
//  Copyright © 2016年 WuTong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAX_LEAFS 30
#define LEAF_ROTATE_TIME 2000
#define LEAF_FLOAT_TIME 3000
#define MIDDLE_AMPLITUDE 10
#define AMPLITUDE_DISPARITY 5

@interface LeafLoading : UIView

@property (nonatomic) CGFloat progress;

@end
