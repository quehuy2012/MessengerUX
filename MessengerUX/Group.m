//
//  Group.m
//  MessengerUX
//
//  Created by CPU11808 on 3/14/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "Group.h"
#import "GroupCell.h"

@implementation Group

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self.image = image;
    }
    return self;
}

- (Class)collectionViewCellClass {
    return [GroupCell class];
}


@end
