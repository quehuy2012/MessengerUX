//
//  CallCell.m
//  MessengerUX
//
//  Created by CPU11808 on 3/14/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CallCell.h"
#import "Call.h"

@implementation CallCell

- (BOOL)shouldUpdateCellWithObject:(id)object {
    Call *call = (Call *)object;
    self.thumbView.image = call.image;
    return YES;
}

@end
