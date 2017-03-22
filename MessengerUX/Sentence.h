//
//  Sentence.h
//  MessengerUX
//
//  Created by CPU11815 on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Speaker.h"

@interface Sentence : NSObject

@property (nonatomic) NSString * ID;
@property (nonatomic) Speaker * owner;
@property (nonatomic) NSString * content;
@property (nonatomic) NSTimeInterval time;

+ (instancetype)sentenceFromString:(NSString *)string;

@end
