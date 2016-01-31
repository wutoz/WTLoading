//
//  Leaf.h
//  WTLoading
//
//  Created by Yorke on 16/1/30.
//  Copyright © 2016年 WuTong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LeafStartType) {
    LeafStartTypeLittle,
    LeafStartTypeMiddle,
    LeafStartTypeBig
};

@interface Leaf : NSObject

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) LeafStartType type;
@property (nonatomic) CGFloat rotateAngle;
@property (nonatomic) int rotateDirection;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSTimeInterval endTime;

+ (Leaf *)generateLeaf;

@end
