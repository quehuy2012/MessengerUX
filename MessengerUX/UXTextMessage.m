//
//  Sentence.m
//  MessengerUX
//
//  Created by CPU11815 on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXTextMessage.h"
#import "UXTextMessageCell.h"
#define COMPONENTS_NUM 8
#define CONTENT_MAX_LENGTH 50

@implementation UXTextMessage

- (instancetype)initWithSententFromString:(NSString *)string {
    self = [super initWithCellNodeClass:[UXTextMessageCell class] userInfo:nil];
    if (self) {
        [self sentenceFromString:string];
    }
    
    return self;
}

- (instancetype)initWithContent:(NSString *)string date:(NSTimeInterval)time isComming:(BOOL)isComming owner:(UXOwner *)owner {
    self = [super initWithCellNodeClass:[UXTextMessageCell class] userInfo:nil];
    if (self) {
        self.ID = [[NSProcessInfo processInfo] globallyUniqueString];
        self.content = string;
        self.time = time;
        self.commingMessage = isComming;
        self.owner = owner;
    }
    
    return self;
}

- (void)sentenceFromString:(NSString *)string {
    if (string && string.length > 0) {
        NSArray<NSString *> * splited = [string componentsSeparatedByString:@" +++$+++ "];
        if (splited.count == COMPONENTS_NUM) {
            NSString * ID = splited[1];
            NSString * speakerName = splited[3];
            NSString * content = splited[7];
            
            self.owner = [[UXOwner alloc] init];
            self.owner.name = speakerName;
            self.owner.avatar = [UIImage imageNamed:@"cameraThumb"]; // TODO edit this dummy thing
            
            self.content = [content stringByReplacingOccurrencesOfString:@" -- " withString:@"\n"];
            self.content = [self.content stringByReplacingOccurrencesOfString:@"--" withString:@"👽"];
            self.content = [self.content stringByReplacingOccurrencesOfString:@"not" withString:@"👎"];
            self.ID = ID;
            self.time = [NSDate timeIntervalSinceReferenceDate];
            self.commingMessage = YES;
        }
    }
}

@end
