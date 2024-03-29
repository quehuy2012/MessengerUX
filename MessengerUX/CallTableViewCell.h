//
//  CallCell.h
//  MessengerUX
//
//  Created by CPU11808 on 3/14/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NICellFactory.h>

@interface CallTableViewCell : UITableViewCell  <NICell>

@property (weak, nonatomic) IBOutlet UIImageView *thumbView;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *profileID;

@end
