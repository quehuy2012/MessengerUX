//
//  ConversationFeed.h
//  MessengerUX
//
//  Created by CPU11815 on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sentence.h"

@interface ConversationFeed : NSObject

- (NSArray<Sentence *> *)getDataArray;

- (void)getNextDataPageWithCompletion:(void (^)(NSArray<Sentence *> * datas))completion;

//- (void)

@end
