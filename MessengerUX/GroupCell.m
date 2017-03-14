//
//  GroupCell.m
//  MessengerUX
//
//  Created by CPU11808 on 3/14/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "GroupCell.h"
#import "Group.h"

@implementation GroupCell

- (BOOL)shouldUpdateCellWithObject:(id)object {
    
    Group *group = (Group *)object;
    
    self.imageView.image = group.image;
    
    return YES;
}

@end
