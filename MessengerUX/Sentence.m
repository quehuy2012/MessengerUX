//
//  Sentence.m
//  MessengerUX
//
//  Created by CPU11815 on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "Sentence.h"

#define COMPONENTS_NUM 8
#define CONTENT_MAX_LENGTH 50

@implementation Sentence

+ (instancetype)sentenceFromString:(NSString *)string {
    Sentence * ret = nil;
    if (string && string.length > 0) {
        NSArray<NSString *> * splited = [string componentsSeparatedByString:@" +++$+++ "];
        if (splited.count == COMPONENTS_NUM) {
            NSString * ID = splited[1];
            NSString * speakerName = splited[3];
            NSString * content = splited[7];
//            if (content.length <= CONTENT_MAX_LENGTH) {
                ret = [[Sentence alloc] init];
                ret.owner = [[Speaker alloc] init];
                
                ret.owner.name = speakerName;
                ret.content = content;
                ret.ID = ID;
                ret.time = [NSDate timeIntervalSinceReferenceDate];
//            }
        }
    }
    return ret;
}

@end
