//
//  ConversationFeed.h
//  MessengerUX
//
//  Created by CPU11815 on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UXNodeModel.h"
#import "UXMessageTimeLine.h"

@interface UXConversationFeed : NSObject

/**
 Get current array data

 @return current array data
 */
- (NSMutableArray<UXMessage *> *)getDataArray;

/**
 Get next page of data

 @param completion action callback
 */
- (void)getNextDataPageWithCompletion:(void (^)(NSArray<UXMessage *> * datas))completion;

/**
 Insert new data as a new page

 @param datas data to insert
 @param completion action callbackk
 */
- (void)insertNewPage:(NSArray<UXMessage *> *)datas withCompletion:(void (^)(NSUInteger fromIndex, NSUInteger toIndex))completion;

- (void)insertData:(UXMessage *)data atIndex:(NSUInteger)index;

- (void)replaceIndex:(NSUInteger)index withData:(UXMessage *)data;

/**
 Delete data at index

 @param index index to delete
 */
- (void)deleteDataAtIndex:(NSUInteger)index;

/**
 Delete sentence

 @param sentence sentence to delete
 */
- (void)deleteSentent:(UXMessage *)sentence;

@end
