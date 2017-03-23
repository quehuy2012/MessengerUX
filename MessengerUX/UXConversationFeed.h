//
//  ConversationFeed.h
//  MessengerUX
//
//  Created by CPU11815 on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UXSentence.h"

@interface UXConversationFeed : NSObject

- (NSArray<UXSentence *> *)getDataArray;

- (void)getNextDataPageWithCompletion:(void (^)(NSArray<UXSentence *> * datas))completion;

- (void)insertNewPage:(NSArray<UXSentence *> *)datas withCompletion:(void (^)(NSUInteger fromIndex, NSUInteger toIndex))completion;

@end
