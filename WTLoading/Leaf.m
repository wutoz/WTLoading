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

    return leaf;
}

@end
