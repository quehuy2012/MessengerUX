//
//  ConversationFeed.m
//  MessengerUX
//
//  Created by CPU11815 on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXConversationFeed.h"

#define PAGE_SIZE 20

@interface UXConversationFeed ()

@property (nonatomic) NSMutableArray<UXSentence *> * dataArray;

@property (nonatomic) dispatch_queue_t internalSerialQueue;
@property (nonatomic) dispatch_queue_t internalConcurrentQueue;

@end

@implementation UXConversationFeed

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataArray = [[self dummyData] mutableCopy];
        static int count = 0;
        
        NSString * serialId = [NSString stringWithFormat:@"ConversationFeed.internalQueue#%d", count];
        NSString * concurrentId = [NSString stringWithFormat:@"ConversationFeed.internalConcurrentQueue#%d", count++];
        self.internalSerialQueue = dispatch_queue_create([serialId UTF8String], DISPATCH_QUEUE_SERIAL);
        self.internalConcurrentQueue = dispatch_queue_create([concurrentId UTF8String], DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (NSArray<UXSentence *> *)getDataArray {
    return [self.dataArray copy];
}

- (void)getNextDataPageWithCompletion:(void (^)(NSArray<UXSentence *> * datas))completion {
    if (completion) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(self.internalConcurrentQueue, ^{
            NSUInteger currentMaxIndex = [weakSelf getDataArray].count;
            NSArray * ret = [weakSelf getDataArrayFromIndex:currentMaxIndex toIndex:currentMaxIndex + PAGE_SIZE];
            completion(ret);
        });
    }
}

- (NSArray<UXSentence *> *)getDataArrayFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    __block NSMutableArray * ret = [NSMutableArray array];
    
    dispatch_sync(self.internalSerialQueue, ^{
        NSError * error;
        
        NSString * dataset = [[NSBundle mainBundle] pathForResource:@"conversations" ofType:@"txt"];
        NSString * datasetContent = [NSString stringWithContentsOfFile:dataset encoding:NSUTF8StringEncoding error:&error];
        
        if (error) {
            // Just print out
            NSLog(@"%@", error.localizedDescription);
        } else if (datasetContent && datasetContent.length > 0){
            
            NSArray * lineByLineContents = [datasetContent componentsSeparatedByString:@"\n"];
            if (lineByLineContents.count > 0 && lineByLineContents.count > fromIndex) {
                
                int maxIndex = lineByLineContents.count < toIndex ? (int)lineByLineContents.count : (int)toIndex;
                for (int i = (int)fromIndex; i < maxIndex; i++) {
                    
                    UXSentence * sentence = [UXSentence sentenceFromString:lineByLineContents[i]];
                    if (sentence) {
                        [ret addObject:sentence];
                    }
                }
            }
        }
    });
    
    return ret;
}

- (void)insertNewPage:(NSArray<UXSentence *> *)datas withCompletion:(void (^)(NSUInteger fromIndex, NSUInteger toIndex))completion {
    NSUInteger fromIndex = [self getDataArray].count;
    NSUInteger toIndex = fromIndex + datas.count - 1;
    
    [self.dataArray addObjectsFromArray:datas];
    
    if (completion) {
        completion(fromIndex, toIndex);
    }
}

- (NSArray<UXSentence *> *)dummyData {
    NSMutableArray * ret = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        UXSentence * sentence = [[UXSentence alloc] init];
        sentence.ID = [NSString stringWithFormat:@"sentence#%d", i];
        sentence.content = [NSString stringWithFormat:@"sentence %d of hahaha, you know what %d", i, i];
        sentence.owner = [[UXSpeaker alloc] init];
        sentence.owner.name = [NSString stringWithFormat:@"kuus%dadf", i];
        [ret addObject:sentence];
    }
    
    return ret;
}

@end
