//
//  UXLimitRangeData.h
//  MessengerUX
//
//  Created by CPU11815 on 4/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UXLimitRangeData : NSObject

@property (atomic) NSUInteger tailShift;
@property (atomic) NSUInteger headShift;
@property (atomic) NSUInteger currentAmount;
@property (atomic) NSUInteger maxRangeItem;
@property (atomic) NSUInteger maxAvaiableItem;
@property (nonatomic) NSUInteger fetchNumber;

- (instancetype)initWithMaxRangeItem:(NSUInteger)maxRangeItem fetchNumber:(NSUInteger)fetchNumber;

- (BOOL)needUnshiftTail;

- (BOOL)needUnshiftHead;

- (void)insertToTail:(NSInteger)itemNumber;

- (void)insertToHead:(NSInteger)itemNumber;

@end
