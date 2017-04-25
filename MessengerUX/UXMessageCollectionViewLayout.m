//
//  UXMessageCollectionViewLayout.m
//  MessengerUX
//
//  Created by CPU11815 on 3/29/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessageCollectionViewLayout.h"

@interface UXMessageCollectionViewLayout ()

@property (nonatomic) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic) NSMutableSet *visibleIndexPathsSet;
@property (nonatomic) CGFloat scrollResistanceConstant; // the bigger the slower decelerating scroll
@property (nonatomic, assign) CGFloat latestDelta;

@end

@implementation UXMessageCollectionViewLayout

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(nonnull NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    self.visibleIndexPathsSet = [NSMutableSet set];
    self.scrollResistanceConstant = 2000;
}

//- (void)resetLayout {
//    [self.dynamicAnimator removeAllBehaviors];
//    [self prepareLayout];
//}
//
- (void)deleteLayoutAttributeAtIndexPath:(NSIndexPath *)indexPath {
    
    __block UIDynamicBehavior * needDeleteBehavior = nil;
    
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(__kindof UIDynamicBehavior * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UICollectionViewLayoutAttributes *item= (UICollectionViewLayoutAttributes*)[[obj items] firstObject];
        
        if ([indexPath compare:item.indexPath] == NSOrderedSame) {
            needDeleteBehavior = obj;
        }
        
    }];
    
//    if (needDeleteBehavior) {
//        [self.dynamicAnimator removeBehavior:needDeleteBehavior];
//    }
    
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.dynamicAnimator itemsInRect:rect];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *dynamicLayoutAttributes = [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
    // Check if dynamic animator has layout attributes for a layout, otherwise use the flow layouts properties. This will prevent crashing when you add items later in a performBatchUpdates block (e.g. triggered by NSFetchedResultsController update)
    return (dynamicLayoutAttributes) ? dynamicLayoutAttributes : [super layoutAttributesForItemAtIndexPath:indexPath];
}

-(void)prepareLayout {
    [super prepareLayout];
    
    // Need to enlarge visible rect slightly to avoid flickering.
    CGRect visibleRect = CGRectInset((CGRect){.origin = self.collectionView.bounds.origin, .size = self.collectionView.frame.size}, -100, -100);
    
    NSArray *itemsInVisibleRectArray = [super layoutAttributesForElementsInRect:visibleRect];
    
    NSArray *cells = [itemsInVisibleRectArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *item, NSDictionary *bindings) {
        return !item.representedElementKind;
    }]];
    
    NSSet *itemsIndexPathsInVisibleRectSet = [NSSet setWithArray:[cells valueForKey:@"indexPath"]];
    
    // Remove any behaviours that are no longer visible.
    NSArray *noLongerVisibleBehavioursCells = [self.dynamicAnimator.behaviors filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIAttachmentBehavior *behaviour, NSDictionary *bindings) {
        
        UICollectionViewLayoutAttributes *item= (UICollectionViewLayoutAttributes*)[[behaviour items] firstObject];
        if (!item.representedElementKind) {
            BOOL currentlyVisible = [itemsIndexPathsInVisibleRectSet member:[item indexPath]] != nil;
            return !currentlyVisible;
        }
        else {
            return NO;
        }
    }]];
    
    [noLongerVisibleBehavioursCells enumerateObjectsUsingBlock:^(UIAttachmentBehavior *behaviour, NSUInteger index, BOOL *stop) {
        UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes*)[[behaviour items] firstObject];
        [self.dynamicAnimator removeBehavior:behaviour];
        [self.visibleIndexPathsSet removeObject:[item indexPath]];
    }];
    
    // Add any newly visible behaviours.
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    // A "newly visible" item is one that is in the itemsInVisibleRect(Set|Array) but not in the visibleIndexPathsSet
    NSArray *newlyVisibleItems = [cells filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *item, NSDictionary *bindings) {
        BOOL currentlyVisible = [self.visibleIndexPathsSet member:item.indexPath] != nil;
        return !currentlyVisible;
    }]];
    
    [newlyVisibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
        CGPoint center = item.center;
        
        UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];
        
        springBehaviour.length = 1.0f;
        springBehaviour.damping = 1.0f;
        springBehaviour.frequency = 3.0f;
        
        // If our touchLocation is not (0,0), we'll need to adjust our item's center "in flight"
        if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
            CGFloat yDistanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y);
            CGFloat scrollResistance = (yDistanceFromTouch) / self.scrollResistanceConstant;
            
            if (self.latestDelta < 0) {
                center.y += MAX(self.latestDelta, self.latestDelta*scrollResistance);
            }
            else {
                center.y += MIN(self.latestDelta, self.latestDelta*scrollResistance);
            }
            item.center = center;
        }
        
        [self.dynamicAnimator addBehavior:springBehaviour];
        [self.visibleIndexPathsSet addObject:item.indexPath];
    }];
    
//    NSLog(@"Prepare layout");
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    
    self.latestDelta = delta;
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    __block UIDynamicAnimator *weakDynamicAnimator = self.dynamicAnimator;
    
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
        
        CGFloat yDistanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y);
        CGFloat scrollResistance = (yDistanceFromTouch) / self.scrollResistanceConstant;
        
        UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes*)[springBehaviour.items firstObject];
        CGPoint center = item.center;
        
        if (delta < 0) {
            center.y += MAX(delta, delta*scrollResistance);
        }
        else {
            center.y += MIN(delta, delta*scrollResistance);
        }
        item.center = center;
        
        [weakDynamicAnimator updateItemUsingCurrentState:item];
    }];
    
//    NSLog(@"Invalidate layout");
    
    return NO;
}

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        if(updateItem.updateAction == UICollectionUpdateActionDelete) {
            
//            NSIndexPath * indexBefore = updateItem.indexPathBeforeUpdate;
            
//            [self resetDynamicKitForIndexPath:indexBefore];
            
            // Where would the flow layout like to place the new cell?
            
//            UICollectionViewLayoutAttributes * attr = [super finalLayoutAttributesForDisappearingItemAtIndexPath:indexBefore];
//            
//            NSIndexPath * ahihi = [indexBefore indexPathByAddingIndex:1];
//            
//            CGPoint center = attr.center;
//
//            CGSize contentSize = [self collectionViewContentSize];
//            center.y += contentSize.height - CGRectGetHeight(attr.bounds);
            
            
            // Now reset the center of insertion point for the animator
//            UICollectionViewLayoutAttributes *insertionPointAttr = [self layoutAttributesForItemAtIndexPath:indexBefore];
//            insertionPointAttr.alpha = attr.alpha;
//            
//            [self.dynamicAnimator updateItemUsingCurrentState:insertionPointAttr];
        }
    }
}

- (void)resetDynamicKitForIndexPath:(NSIndexPath *)indexPath {
    
}

@end
