//
//  Leaf.m
//  WTLoading
//
//  Created by Yorke on 16/1/30.
//  Copyright © 2016年 WuTong. All rights reserved.
//

#import "Leaf.h"

@implementation Leaf

+ (Leaf *)generateLeaf{
    Leaf *leaf = [[Leaf alloc]init];
    leaf.type = arc4random() % 3;
    leaf.rotateAngle = arc4random() % 360;
    leaf.rotateDirection = arc4random() % 2;
    leaf.startTime = [[NSDate date] timeIntervalSince1970] * 1000 + arc4random() % (int)(LEAF_FLOAT_TIME * 3);
    
    return leaf;
}

@end
