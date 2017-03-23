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

/**
 Get current array data

 @return current array data
 */
- (NSArray<UXSentence *> *)getDataArray;

/**
 Get next page of data

 @param completion action callback
 */
- (void)getNextDataPageWithCompletion:(void (^)(NSArray<UXSentence *> * datas))completion;

/**
 Insert new data as a new page

 @param datas data to insert
 @param completion action callbackk
 */
- (void)insertNewPage:(NSArray<UXSentence *> *)datas withCompletion:(void (^)(NSUInteger fromIndex, NSUInteger toIndex))completion;

@end
