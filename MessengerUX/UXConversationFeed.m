//
//  ConversationFeed.m
//  MessengerUX
//
//  Created by CPU11815 on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXConversationFeed.h"

#define PAGE_FETCH_SIZE 20

@interface UXConversationFeed ()

@property (nonatomic) NSMutableArray<UXMessage *> * dataArray;

@property (nonatomic) dispatch_queue_t internalSerialQueue;
@property (nonatomic) dispatch_queue_t internalConcurrentQueue;

@property (nonatomic) BOOL prefetching;

@end

@implementation UXConversationFeed

- (instancetype)init {
    self = [super init];
    if (self) {
        self.prefetching = NO;
        self.dataArray = [[self dummyData] mutableCopy];
        static int count = 0;
        
        NSString * serialId = [NSString stringWithFormat:@"ConversationFeed.internalQueue#%d", count];
        NSString * concurrentId = [NSString stringWithFormat:@"ConversationFeed.internalConcurrentQueue#%d", count++];
        self.internalSerialQueue = dispatch_queue_create([serialId UTF8String], DISPATCH_QUEUE_SERIAL);
        self.internalConcurrentQueue = dispatch_queue_create([concurrentId UTF8String], DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (NSMutableArray<UXMessage *> *)getDataArray {
    return [self.dataArray mutableCopy];
}

- (void)getNextDataPageWithCompletion:(void (^)(NSArray<UXMessage *> * datas))completion {
    
    if (completion && !self.prefetching) {
        self.prefetching = YES;
        __weak typeof(self) weakSelf = self;
        dispatch_async(self.internalConcurrentQueue, ^{
            NSUInteger currentMaxIndex = [weakSelf getDataArray].count;
            NSArray * ret = [weakSelf getDataArrayFromIndex:currentMaxIndex toIndex:currentMaxIndex + PAGE_FETCH_SIZE];
            weakSelf.prefetching = NO;
            completion(ret);
        });
    }
}

- (NSArray<UXMessage *> *)getDataArrayFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    
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
                    
                    UXMessage * message = nil;
                    UXTextMessage * messageT = [[UXTextMessage alloc] initWithSententFromString:lineByLineContents[i]];
                    
                    if (i % 10 == 0) {
                
                        NSArray * imgs = @[];
                        
                        if (i % 4 == 0) {
                            
                            imgs = @[[UIImage imageNamed:@"cameraThumb"], [UIImage imageNamed:@"tempImg"], [UIImage imageNamed:@"drawThumb"]
                                     , [UIImage imageNamed:@"groupImage"], [UIImage imageNamed:@"galleryThumb"], [UIImage imageNamed:@"tempImg"]
                                     , [UIImage imageNamed:@"tempImg"]];
                            
                        } else if (i % 3 == 0){
                            
                            imgs = @[[UIImage imageNamed:@"cameraThumb"], [UIImage imageNamed:@"tempImg"]];
                            
                        } else if (i % 5 == 0) {
                            
                            imgs = @[[UIImage imageNamed:@"cameraThumb"], [UIImage imageNamed:@"tempImg"], [UIImage imageNamed:@"drawThumb"]
                                     , [UIImage imageNamed:@"groupImage"], [UIImage imageNamed:@"galleryThumb"], [UIImage imageNamed:@"tempImg"]
                                     , [UIImage imageNamed:@"tempImg"], [UIImage imageNamed:@"tempImg"], [UIImage imageNamed:@"drawThumb"]
                                     , [UIImage imageNamed:@"groupImage"], [UIImage imageNamed:@"galleryThumb"]];
                        } else {
                            
                            imgs = @[[UIImage imageNamed:@"cameraThumb"], [UIImage imageNamed:@"tempImg"], [UIImage imageNamed:@"drawThumb"]
                                     , [UIImage imageNamed:@"groupImage"], [UIImage imageNamed:@"galleryThumb"], [UIImage imageNamed:@"tempImg"]
                                     , [UIImage imageNamed:@"tempImg"], [UIImage imageNamed:@"tempImg"], [UIImage imageNamed:@"drawThumb"]
                                     , [UIImage imageNamed:@"cameraThumb"], [UIImage imageNamed:@"tempImg"], [UIImage imageNamed:@"drawThumb"]
                                     , [UIImage imageNamed:@"groupImage"], [UIImage imageNamed:@"galleryThumb"], [UIImage imageNamed:@"tempImg"]
                                     , [UIImage imageNamed:@"groupImage"], [UIImage imageNamed:@"galleryThumb"]];
                        }
                        
                        message = [[UXAlbumMessage alloc] initWithImages:imgs
                                                                    date:[NSDate timeIntervalSinceReferenceDate]
                                                               isComming:(i % 3 == 0)
                                                                   owner:messageT.owner];
                
                    } else if (i % 9 == 0) {
                
                        message = [[UXTitleMessage alloc] initWithTitle:@"Section"];
                
                    } else if (i % 6 == 0) {
                
                        message = [[UXImageMessage alloc] initWithImage:[UIImage imageNamed:@"cameraThumb"]
                                                                   date:[NSDate timeIntervalSinceReferenceDate]
                                                              isComming:YES
                                                                  owner:messageT.owner];
                
                    } else if (i % 17 == 0) {
                
                        message = [[UXImageMessage alloc] initWithImage:[UIImage imageNamed:@"tempImg"]
                                                                   date:[NSDate timeIntervalSinceReferenceDate]
                                                              isComming:NO
                                                                  owner:messageT.owner];
                        
                    } else {
                    
                        BOOL dummyIncomming = i % 2 == 0 || i % 13 == 0;
                        
                        message = [[UXTextMessage alloc] initWithContent:messageT.content
                                                                    date:[NSDate timeIntervalSinceReferenceDate]
                                                               isComming:dummyIncomming
                                                                   owner:messageT.owner];
                        
                    }
                    
                    if (message) {
                        [ret addObject:message];
                    }
                }
            }
        }
    });
    
    return ret;
}

- (void)insertNewPage:(NSArray<UXMessage *> *)datas withCompletion:(void (^)(NSUInteger fromIndex, NSUInteger toIndex))completion {
    
    if (datas) {
        NSUInteger fromIndex = [self getDataArray].count;
        NSUInteger toIndex = fromIndex + datas.count - 1;
        
        [self.dataArray addObjectsFromArray:datas];
        
        NSLog(@"Current size %f", [self currentSizeOfData]);
        
        if (completion) {
            completion(fromIndex, toIndex);
        }
    }
}

- (NSArray<UXMessage *> *)dummyData {
    NSMutableArray * ret = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        
        UXOwner * owner = [[UXOwner alloc] init];
        owner.name = [NSString stringWithFormat:@"kuus%dadf", i];
        owner.avatar = [UIImage imageNamed:@"cameraThumb"];
        
        UXMessage * message = [[UXTextMessage alloc] initWithContent:[NSString stringWithFormat:@"sentence %d of hahaha, you know what %d", i, i]
                                                                date:[NSDate timeIntervalSinceReferenceDate]
                                                           isComming:i % 2 == 0
                                                               owner:owner];
        [ret addObject:message];
    }
    
    return ret;
}

- (void)deleteDataAtIndex:(NSUInteger)index {
    if (index < self.dataArray.count) {
        [self.dataArray removeObjectAtIndex:index];
    }
}

- (void)deleteSentent:(UXMessage *)sentence {
    if ([self.dataArray containsObject:sentence]) {
        [self.dataArray removeObject:sentence];
    }
}

- (double) currentSizeOfData {
    double ret = sizeof(self.dataArray) / 1024.0;
    
    for (id item in self.dataArray) {
        ret += sizeof(item) / 1024.0;
    }
    
    return ret;
}

@end
