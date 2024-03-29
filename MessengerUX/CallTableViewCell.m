//
//  CallCell.m
//  MessengerUX
//
//  Created by CPU11808 on 3/14/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CallCellObject.h"
#import "CallTableViewCell.h"

@implementation CallTableViewCell

- (BOOL)shouldUpdateCellWithObject:(id)object {
    CallCellObject *call = (CallCellObject *)object;
    self.thumbView.image = call.image;
    self.name.text = call.name;
    self.profileID.text = call.profileID;
    return YES;
}

@end
