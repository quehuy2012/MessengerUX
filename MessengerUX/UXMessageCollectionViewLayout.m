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
    if (self = [super init]) {
        self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        self.visibleIndexPathsSet = [NSMutableSet set];
        self.scrollResistanceConstant = 1500;
    }
    return self;
}

- (id)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        self.scrollResistanceConstant = 1500;
    }
    return self;
}

- (void)resetLayout {
//    [self.dynamicAnimator removeAllBehaviors];
//    [self prepareLayout];
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.dynamicAnimator itemsInRect:rect];
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
        springBehaviour.damping = 1;
        springBehaviour.frequency = 5.0f;
        
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
    
    return NO;
}

@end
