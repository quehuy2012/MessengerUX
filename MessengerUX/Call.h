//
//  Call.h
//  MessengerUX
//
//  Created by CPU11808 on 3/14/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <NICellFactory.h>

@interface Call : NICellObject

@property (strong, nonatomic) UIImage* image;

- (instancetype)initWithImage:(UIImage*) image;

@end
