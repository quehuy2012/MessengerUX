//
//  ConversationFeed.m
//  MessengerUX
//
//  Created by CPU11815 on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "ConversationFeed.h"

#define PAGE_SIZE 20

@interface ConversationFeed ()

@property (nonatomic) NSMutableArray<Sentence *> * dataArray;

@property (nonatomic) dispatch_queue_t internalSerialQueue;
@property (nonatomic) dispatch_queue_t internalConcurrentQueue;

@end

@implementation ConversationFeed

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
        static int count = 0;
        
        NSString * serialId = [NSString stringWithFormat:@"ConversationFeed.internalQueue#%d", count];
        NSString * concurrentId = [NSString stringWithFormat:@"ConversationFeed.internalConcurrentQueue#%d", count++];
        self.internalSerialQueue = dispatch_queue_create([serialId UTF8String], DISPATCH_QUEUE_SERIAL);
        self.internalConcurrentQueue = dispatch_queue_create([concurrentId UTF8String], DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (NSArray<Sentence *> *)getDataArray {
    return [self.dataArray copy];
}

- (void)getNextDataPageWithCompletion:(void (^)(NSArray<Sentence *> * datas))completion {
    if (completion) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(self.internalConcurrentQueue, ^{
            NSUInteger currentMaxIndex = [weakSelf getDataArray].count;
            NSArray * ret = [weakSelf getDataArrayFromIndex:currentMaxIndex toIndex:currentMaxIndex + PAGE_SIZE];
            completion(ret);
        });
    }
}

- (NSArray<Sentence *> *)getDataArrayFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
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
                    
                    Sentence * sentence = [Sentence sentenceFromString:lineByLineContents[i]];
                    if (sentence) {
                        [ret addObject:sentence];
                    }
                }
            }
        }
    });
    
    return ret;
}

@end
