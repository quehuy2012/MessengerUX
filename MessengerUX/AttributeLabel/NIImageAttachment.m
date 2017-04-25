/* Copyright (c) 2015-present, Zalo Group.
 * All rights reserved.
 */

#import "NIImageAttachment.h"

static void RunDelegateDeallocateCallback(void *refCon)
{
    
}

static CGFloat RunDelegateGetAscentCallback(void *refCon)
{
    NIImageAttachment *object = (__bridge NIImageAttachment *)refCon;
    return object.height;
}

static CGFloat RunDelegateGetDescentCallback(void *refCon)
{
    NIImageAttachment *object = (__bridge NIImageAttachment *)refCon;
    return object.descent;
}

static CGFloat RunDelegateGetWidthCallback(void *refCon)
{
    NIImageAttachment *object = (__bridge NIImageAttachment *)refCon;
    return object.width;
}


@implementation NIImageAttachment

- (CTRunDelegateCallbacks)callbacks
{
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.dealloc = RunDelegateDeallocateCallback;
    callbacks.getAscent = RunDelegateGetAscentCallback;
    callbacks.getDescent = RunDelegateGetDescentCallback;
    callbacks.getWidth = RunDelegateGetWidthCallback;
    
    return callbacks;
}

@end
