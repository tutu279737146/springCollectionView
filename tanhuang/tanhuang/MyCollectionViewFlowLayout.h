//
//  MyCollectionViewFlowLayout.h
//  tanhuang
//
//  Created by 涂世展 on 16/10/9.
//  Copyright © 2016年 涂世展. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewFlowLayout : UICollectionViewFlowLayout

//阻尼(阻力大小)
@property (nonatomic, assign) CGFloat springDamping;
//震荡频率
@property (nonatomic, assign) CGFloat springFrequency;
//线性阻力
@property (nonatomic, assign) CGFloat resistanceFactor;

@end
