//
//  ViewController.m
//  tanhuang
//
//  Created by 涂世展 on 16/10/9.
//  Copyright © 2016年 涂世展. All rights reserved.
//

#import "ViewController.h"
#import "MyCollectionViewFlowLayout.h"

//遵循协议和代理
@interface ViewController ()<UICollectionViewDelegate ,UICollectionViewDataSource>

//创建自动布局的流
@property (nonatomic, strong) MyCollectionViewFlowLayout *layout;

@end

//设置重用标识
static NSString *reuseID = @"collectionViewCellReuseID";

@implementation ViewController
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置当前的布局流
    self.layout = [[MyCollectionViewFlowLayout alloc] init];
    //设置itemsize
    self.layout.itemSize = CGSizeMake(self.view.frame.size.width, 80);
    //设置collectionView的位置和大小
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.layout];
    //设置背景颜色
    collectionView.backgroundColor = [UIColor clearColor];
    //注册
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseID];
    //设置数据源
    collectionView.dataSource = self;
    //添加
    [self.view insertSubview:collectionView atIndex:0];
    
}

//数据源协议
#pragma mark  UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return  50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    
    cell.contentView.backgroundColor =  [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];;
    
    return cell;
}

@end
