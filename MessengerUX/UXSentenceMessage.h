//
//  Sentence.h
//  MessengerUX
//
//  Created by CPU11815 on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UXMessage.h"

@interface UXSentenceMessage: UXMessage

@property (nonatomic) NSString * content;

+ (instancetype)sentenceFromString:(NSString *)string;

@end
