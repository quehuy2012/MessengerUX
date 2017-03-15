//
//  Call.m
//  MessengerUX
//
//  Created by CPU11808 on 3/14/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "Call.h"
#import "CallCell.h"

@implementation Call

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self.image = image;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage*)image name:(NSString *)name profileID:(NSString *)profileID {
    if ([self initWithImage:image]) {
        self.name = name;
        self.profileID = profileID;
    }
    return self;
}

- (Class)cellClass {
    return [CallCell class];
}

@end
