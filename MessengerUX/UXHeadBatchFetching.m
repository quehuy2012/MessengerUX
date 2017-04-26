//
//  UXHeadBatchFetching.m
//  MessengerUX
//
//  Created by CPU11815 on 4/26/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXHeadBatchFetching.h"
#import <AsyncDisplayKit/ASBatchContext.h>

BOOL UXDisplayShouldHeadFetchBatchForScrollView(UIScrollView<ASBatchFetchingScrollView> *scrollView, ASScrollDirection scrollDirection, ASScrollDirection scrollableDirections, CGPoint contentOffset)
{
    // Don't fetch if the scroll view does not allow
    if (![scrollView canBatchFetch]) {
        return NO;
    }
    
    // Check if we should batch fetch
    ASBatchContext *context = scrollView.batchContext;
    CGRect bounds = scrollView.bounds;
    CGSize contentSize = scrollView.contentSize;
    CGFloat leadingScreens = scrollView.leadingScreensForBatching;
    BOOL visible = (scrollView.window != nil);
    return UXDisplayShouldHeadFetchBatchForContext(context, scrollDirection, scrollableDirections, bounds, contentSize, contentOffset, leadingScreens, visible);
}

BOOL UXDisplayShouldHeadFetchBatchForContext(ASBatchContext *context,
                                         ASScrollDirection scrollDirection,
                                         ASScrollDirection scrollableDirections,
                                         CGRect bounds,
                                         CGSize contentSize,
                                         CGPoint targetOffset,
                                         CGFloat leadingScreens,
                                         BOOL visible)
{
    // Do not allow fetching if a batch is already in-flight and hasn't been completed or cancelled
    if ([context isFetching]) {
        return NO;
    }
    
    // No fetching for null states
    if (leadingScreens <= 0.0 || CGRectIsEmpty(bounds)) {
        return NO;
    }
    
    CGFloat viewLength, offset, contentLength;
    
    if (ASScrollDirectionContainsVerticalDirection(scrollableDirections)) {
        viewLength = bounds.size.height;
        offset = targetOffset.y;
        contentLength = contentSize.height;
    } else { // horizontal / right
        viewLength = bounds.size.width;
        offset = targetOffset.x;
        contentLength = contentSize.width;
    }
    
    // Piority for tail batch fetching
    BOOL hasSmallContent = contentLength < viewLength;
    if (hasSmallContent) {
        return NO;
    }
    
    // If we are not visible, but we do have enough content to fill visible area,
    // don't batch fetch.
    if (visible == NO) {
        return NO;
    }
    
    // If they are scrolling toward the tail of content, don't batch fetch.
    BOOL isScrollingTowardHead = (ASScrollDirectionContainsDown(scrollDirection) || ASScrollDirectionContainsRight(scrollDirection));
    if (isScrollingTowardHead) {
        return NO;
    }
    
    CGFloat triggerDistance = viewLength * leadingScreens;
    CGFloat remainingDistance = offset - viewLength;
    
    return remainingDistance <= triggerDistance;
}

