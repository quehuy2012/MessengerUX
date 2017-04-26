//
//  UXHeadBatchFetching.h
//  MessengerUX
//
//  Created by CPU11815 on 4/26/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AsyncDisplayKit/ASScrollDirection.h>

ASDISPLAYNODE_EXTERN_C_BEGIN

@class ASBatchContext;

@protocol ASBatchFetchingScrollView <NSObject>

- (BOOL)canBatchFetch;
- (ASBatchContext *)batchContext;
- (CGFloat)leadingScreensForBatching;

@end

BOOL UXDisplayShouldHeadFetchBatchForScrollView(UIScrollView<ASBatchFetchingScrollView> *scrollView, ASScrollDirection scrollDirection, ASScrollDirection scrollableDirections, CGPoint contentOffset);

extern BOOL UXDisplayShouldHeadFetchBatchForContext(ASBatchContext *context,
                                                ASScrollDirection scrollDirection,
                                                ASScrollDirection scrollableDirections,
                                                CGRect bounds,
                                                CGSize contentSize,
                                                CGPoint targetOffset,
                                                CGFloat leadingScreens,
                                                BOOL visible);

ASDISPLAYNODE_EXTERN_C_END
