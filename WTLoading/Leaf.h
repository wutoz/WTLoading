//
//  Leaf.h
//  WTLoading
//
//  Created by Yorke on 16/1/30.
//  Copyright © 2016年 WuTong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define MIDDLE_AMPLITUDE 9
#define AMPLITUDE_DISPARITY 5
#define LEAF_ROTATE_TIME 2000
#define LEAF_FLOAT_TIME 3000

typedef NS_ENUM(NSInteger, StartType) {
    StartTypeLittle,
    StartTypeMiddle,
    StartTypeBig
};

@interface Leaf : NSObject

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) StartType type;
@property (nonatomic) CGFloat rotateAngle;
@property (nonatomic) int rotateDirection;
@property (nonatomic) NSTimeInterval startTime;

+ (Leaf *)generateLeaf;

@end
