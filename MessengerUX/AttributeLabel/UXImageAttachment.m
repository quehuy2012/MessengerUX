/* Copyright (c) 2015-present, Zalo Group.
 * All rights reserved.
 */

#import "UXImageAttachment.h"

static void RunDelegateDeallocateCallback(void *refCon)
{
    
}

static CGFloat RunDelegateGetAscentCallback(void *refCon)
{
    UXImageAttachment *object = (__bridge UXImageAttachment *)refCon;
    return object.height;
}

static CGFloat RunDelegateGetDescentCallback(void *refCon)
{
    UXImageAttachment *object = (__bridge UXImageAttachment *)refCon;
    return object.descent;
}

static CGFloat RunDelegateGetWidthCallback(void *refCon)
{
    UXImageAttachment *object = (__bridge UXImageAttachment *)refCon;
    return object.width;
}


@implementation UXImageAttachment

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
