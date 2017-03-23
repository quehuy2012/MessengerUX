//
//  Sentence.h
//  MessengerUX
//
//  Created by CPU11815 on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UXSpeaker.h"

@interface UXSentence : NSObject

@property (nonatomic) NSString * ID;
@property (nonatomic) UXSpeaker * owner;
@property (nonatomic) NSString * content;
@property (nonatomic) NSTimeInterval time;
@property (nonatomic) BOOL commingMessage;

+ (instancetype)sentenceFromString:(NSString *)string;

@end
