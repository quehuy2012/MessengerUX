//
//  Sentence.m
//  MessengerUX
//
//  Created by CPU11815 on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXSentence.h"

#define COMPONENTS_NUM 8
#define CONTENT_MAX_LENGTH 50

@implementation UXSentence

+ (instancetype)sentenceFromString:(NSString *)string {
    UXSentence * ret = nil;
    if (string && string.length > 0) {
        NSArray<NSString *> * splited = [string componentsSeparatedByString:@" +++$+++ "];
        if (splited.count == COMPONENTS_NUM) {
            NSString * ID = splited[1];
            NSString * speakerName = splited[3];
            NSString * content = splited[7];
            
            ret = [[UXSentence alloc] init];
            
            ret.owner = [[UXSpeaker alloc] init];
            ret.owner.name = speakerName;
            ret.owner.avatar = [UIImage imageNamed:@"cameraThumb"]; // TODO edit this dummy thing
            
            ret.content = [content stringByReplacingOccurrencesOfString:@" -- " withString:@"\n"];
            ret.content = [ret.content stringByReplacingOccurrencesOfString:@"--" withString:@"👽"];
            ret.content = [ret.content stringByReplacingOccurrencesOfString:@"not" withString:@"👎"];
            ret.ID = ID;
            ret.time = [NSDate timeIntervalSinceReferenceDate];
            ret.commingMessage = YES;
        }
    }
    return ret;
}

@end
