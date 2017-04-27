//
//  UXLimitRangeData.m
//  MessengerUX
//
//  Created by CPU11815 on 4/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXLimitRangeData.h"

@implementation UXLimitRangeData

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tailShift = 0;
        self.headShift = 0;
        self.currentAmount = 0;
        self.maxRangeItem = 0;
        self.maxAvaiableItem = 0;
        self.fetchNumber = 0;
    }
    
    return self;
}

- (instancetype)initWithMaxRangeItem:(NSUInteger)maxRangeItem fetchNumber:(NSUInteger)fetchNumber {
    self = [self init];
    if (self) {
        self.maxRangeItem = maxRangeItem;
        self.fetchNumber = fetchNumber;
    }
    
    return self;
}

- (BOOL)needUnshiftTail {
    return self.tailShift > 0;
}

- (BOOL)needUnshiftHead {
    return self.headShift > 0;
}

- (void)insertToTail:(NSInteger)itemNumber {
    if (self.currentAmount < self.maxRangeItem) {
        if (itemNumber > self.maxRangeItem - self.currentAmount) {
            NSUInteger expandAmount = itemNumber - (self.maxRangeItem - self.currentAmount);
            
            self.tailShift = 0;
            self.headShift = expandAmount;
        } else if (itemNumber <= self.maxRangeItem - self.currentAmount) {
            self.tailShift = 0;
            self.headShift = 0;
        }
    } else if (self.currentAmount == self.maxRangeItem) {
        if (itemNumber > self.tailShift) {
            NSUInteger expandAmount = itemNumber - self.tailShift;
            self.tailShift = 0;
            self.headShift += expandAmount;
        } else {
            self.tailShift -= itemNumber;
            self.headShift += itemNumber;
        }
    }
}

- (void)insertToHead:(NSInteger)itemNumber {
    if (self.currentAmount < self.maxRangeItem) {
        // imposible case
    } else {
        if (itemNumber > self.headShift) {
            // imposible case
        } else {
            self.headShift -= itemNumber;
            self.tailShift += itemNumber;
        }
    }
}

@end
