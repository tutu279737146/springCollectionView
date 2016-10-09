//
//  MyCollectionViewFlowLayout.m
//  tanhuang
//
//  Created by 涂世展 on 16/10/9.
//  Copyright © 2016年 涂世展. All rights reserved.
//

#import "MyCollectionViewFlowLayout.h"

@interface MyCollectionViewFlowLayout ()

//设置动画者
@property (nonatomic, strong) UIDynamicAnimator *animator;

@end
/*
   对于弹性效果，我们需要的是连接一个item和一个锚点间弹性连接的UIAttachmentBehavior，并能在滚动时设置新的锚点位置。我们在scroll的时候，只要使用UIKit Dynamics的计算结果，替代掉原来的位置更新计算（其实就是简单的scrollView的contentOffset的改变），就可以模拟出弹性的效果了。
 */

@implementation MyCollectionViewFlowLayout


-(id)init {
    if ([super init]) {
        _springDamping = 0.8;
        _springFrequency = 0.8;
        _resistanceFactor = 500;
    }
    return self;
}

-(void)setSpringDamping:(CGFloat)springDamping {
    if (springDamping >= 0 && _springDamping != springDamping) {
        _springDamping = springDamping;
        for (UIAttachmentBehavior *spring in _animator.behaviors) {
            spring.damping = _springDamping;
        }
    }
}

-(void)setSpringFrequency:(CGFloat)springFrequency {
    if (springFrequency >= 0 && _springFrequency != springFrequency) {
        _springFrequency = springFrequency;
        for (UIAttachmentBehavior *spring in _animator.behaviors) {
            spring.frequency = _springFrequency;
        }
    }
}

- (void)prepareLayout{
    
    [super prepareLayout];
    
    if (!_animator) {
        
        _animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        
        CGSize contentSize = [self collectionViewContentSize];
        
        NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];
        
        for (UICollectionViewLayoutAttributes *item in items) {
            
            UIAttachmentBehavior *spring = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:item.center];
            
            
            
//            spring.length = 0;
            spring.damping = self.springDamping;
            spring.frequency = self.springFrequency;
            
            [_animator addBehavior:spring];
        }
    }
    
}

//ios7SDK 中有与collectionView绑定的方法

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return [_animator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_animator layoutAttributesForCellAtIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    UIScrollView *scrollView = self.collectionView;
    
    CGFloat scrollDelta = newBounds.origin.y - scrollView.bounds.origin.y;
    
    CGPoint touchLocation = [scrollView.panGestureRecognizer locationInView:scrollView];
    
    for (UIAttachmentBehavior *spring in _animator.behaviors) {
        
        CGPoint anchorPoint = spring.anchorPoint;
        
        CGFloat distanceFromTouch = fabsf(touchLocation.y - anchorPoint.y);
        
        CGFloat scrollResistance = distanceFromTouch / self.resistanceFactor;
        
        UICollectionViewLayoutAttributes *item = [spring.items firstObject];
        
        CGPoint center = item.center;
        
        center.y += (scrollDelta > 0) ? MIN(scrollDelta, scrollDelta * scrollResistance)
                                       :MAX(scrollDelta, scrollDelta * scrollResistance);
        
        item.center = center;
        
        [_animator updateItemUsingCurrentState:item];
        
    }
    
    return NO;
}
@end
