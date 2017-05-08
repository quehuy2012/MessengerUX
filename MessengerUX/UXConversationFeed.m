//
//  ConversationFeed.m
//  MessengerUX
//
//  Created by CPU11815 on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXConversationFeed.h"
#import "LoremIpsum.h"

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

- (void)getNextDataPageSize:(NSUInteger)size withCompletion:(void (^)(NSArray<UXMessage *> * datas))completion; {
    
    if (completion && !self.prefetching) {
        self.prefetching = YES;
        __weak typeof(self) weakSelf = self;
        dispatch_async(self.internalConcurrentQueue, ^{
            NSUInteger currentMaxIndex = [weakSelf getDataArray].count;
            NSArray * ret = [weakSelf getDataArrayFromIndex:currentMaxIndex toIndex:currentMaxIndex + size];
            weakSelf.prefetching = NO;
            completion(ret);
        });
    }
}

- (NSArray<UXMessage *> *)getDataArrayFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    
    __block NSMutableArray * ret = [NSMutableArray array];
    dispatch_sync(self.internalSerialQueue, ^{
        
//        for (int i = (int)fromIndex; i < toIndex; i++) {
//            
//            UXOwner * owner = [[UXOwner alloc] init];
//            owner.name = [NSString stringWithFormat:@"kuus%dadf", i];
//            owner.avatar = [UIImage imageNamed:@"cameraThumb"];
//            
//            UXMessage * message = [[UXTextMessage alloc] initWithContent:[NSString stringWithFormat:@"%d", i]
//                                                                    date:[NSDate timeIntervalSinceReferenceDate]
//                                                               isComming:NO
//                                                                   owner:owner];
//            [ret addObject:message];
//        }
        
        
        NSError * error;
        
        NSString * dataset = [[NSBundle mainBundle] pathForResource:@"conversations" ofType:@"txt"];
        NSString * datasetContent = [NSString stringWithContentsOfFile:dataset encoding:NSUTF8StringEncoding error:&error];
        
        // Simulate network delay when fetching data
//        [NSThread sleepForTimeInterval:1];
        
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
                        
                        NSURL * img1 = [NSURL URLWithString:@"http://static.boredpanda.com/blog/wp-content/uploads/2016/02/big-cute-eyes-cat-black-scottish-fold-gimo-1room1cat-331.jpg"];
                        NSURL * img2 = [NSURL URLWithString:@"https://kittybloger.files.wordpress.com/2013/03/15-really-cute-kittens-9.jpg"];
                        NSURL * img3 = [NSURL URLWithString:@"http://addolo.com/wp-content/uploads/2016/12/super-cute-dog-pics-with-captions-picturesescute-to-color-dogs.jpg"];
                        NSURL * img4 = [NSURL URLWithString:@"http://cdn4.dualshockers.com/wp-content/uploads/2016/07/pokemon-4-1200x0.jpg"];
                        NSURL * img5 = [NSURL URLWithString:@"http://www.pokemonxy.com/_ui/img/_en/art/Manectric-Pokemon-X-and-Y.jpg"];
                        
                        if (i % 4 == 0) {
                            
                            imgs = @[img1, img2, img3
                                     , img4, img5, img2
                                     , img3];
                            
                        } else if (i % 3 == 0){
                            
                            imgs = @[img1];
                            
                        } else if (i % 5 == 0) {
                            
                            imgs = @[img1, img2, img3
                                     , img4, img5, img2
                                     , img3, img4, img5
                                     , img3, img4, img5
                                     , img4, img5, img2
                                     , img3, img4, img5
                                     , img4, img5, img2
                                     , img3, img4, img5
                                     , img2];
                        } else {
                            
                            imgs = @[img1, img2, img3
                                     , img4, img5, img2
                                     , img3, img4, img5
                                     , img4, img5, img2
                                     , img3, img4, img5
                                     , img4, img5, img2
                                     , img3, img4, img5
                                     , img4, img5, img2
                                     , img3, img4, img5
                                     , img4, img5, img2
                                     , img3, img4, img5
                                     , img4, img5, img2
                                     , img3, img4, img5
                                     , img4, img5, img2
                                     , img4, img5, img2
                                     , img3, img4, img5
                                     , img4, img5, img2
                                     , img4, img5, img2
                                     , img3, img4, img5
                                     , img4, img5, img2
                                     , img4, img5, img2
                                     , img3, img4, img5
                                     , img4, img5, img2
                                     , img4, img5, img2
                                     , img3, img4, img5
                                     , img4, img5, img2
                                     , img3, img4, img5
                                     , img4, img5, img2
                                     , img3, img4, img5
                                     , img4, img5, img2
                                     , img3, img4, img5
                                     , img4, img5, img2
                                     , img2];
                        }
                        
                        message = [[UXAlbumMessage alloc] initWithImageURLs:imgs
                                                                    date:[NSDate timeIntervalSinceReferenceDate]
                                                               isComming:(i % 3 == 0)
                                                                   owner:messageT.owner];
                
                    } else if (i % 9 == 0) {

                        message = [[UXTitleMessage alloc] initWithTitle:@"Section"];
                
                    } else if (i % 6 == 0) {
                
                        NSURL * imageURL;
                        
                        long rand = arc4random_uniform(100);;
                        
                        if (rand % 13 == 0) {
                            imageURL = [NSURL URLWithString:@"http://graphicsheat.com/wp-content/uploads/2013/06/cute-wallpaper-flowerdrop.jpg"];
                        } else if (rand % 7 == 0) {
                            imageURL = [NSURL URLWithString:@"http://graphicsheat.com/wp-content/uploads/2013/06/cute-wallpaper-flowerdrop.jpg"];
                        } else if (rand % 5 == 0) {
                            imageURL = [NSURL URLWithString:@"http://kingofwallpapers.com/cute/cute-010.jpg"];
                        } else if (rand % 3 == 0) {
                            imageURL = [NSURL URLWithString:@"https://i.ytimg.com/vi/Ikw5HhxC5UM/hqdefault.jpg"];
                        } else {
                            imageURL = [NSURL URLWithString:@"https://s-media-cache-ak0.pinimg.com/originals/6b/45/5d/6b455d864ecce4270da03f9ff008736b.jpg"];
                        }
                        
                        message = [[UXImageMessage alloc] initWithImageURL:imageURL
                                                                 withRatio:1
                                                                      date:[NSDate timeIntervalSinceReferenceDate]
                                                                 isComming:i % 3 == 0
                                                                     owner:messageT.owner];

                    } else if (i % 17 == 0) {
                        
                        NSURL * imageURL;
                        
                        
                        long rand = arc4random_uniform(100);;
                        
                        if (rand % 13 == 0) {
                            imageURL = [NSURL URLWithString:@"http://graphicsheat.com/wp-content/uploads/2013/06/cute-wallpaper-flowerdrop.jpg"];
                        } else if (rand % 7 == 0) {
                            imageURL = [NSURL URLWithString:@"http://graphicsheat.com/wp-content/uploads/2013/06/cute-wallpaper-flowerdrop.jpg"];
                        } else if (rand % 5 == 0) {
                            imageURL = [NSURL URLWithString:@"http://kingofwallpapers.com/cute/cute-010.jpg"];
                        } else if (rand % 3 == 0) {
                            imageURL = [NSURL URLWithString:@"https://i.ytimg.com/vi/Ikw5HhxC5UM/hqdefault.jpg"];
                        } else {
                            imageURL = [NSURL URLWithString:@"https://s-media-cache-ak0.pinimg.com/originals/6b/45/5d/6b455d864ecce4270da03f9ff008736b.jpg"];
                        }
                        
                        message = [[UXImageMessage alloc] initWithImageURL:imageURL
                                                                 withRatio:1
                                                                      date:[NSDate timeIntervalSinceReferenceDate]
                                                                 isComming:NO
                                                                     owner:messageT.owner];
                        
//                    } else if (i % 7 == 0) {
//                        
//                        NSURL *fileUrl = [NSURL URLWithString:@"https://www.w3schools.com/html/mov_bbb.mp4"];
//                        message = [[UXVideoMessage alloc] initWithVideoURL:fileUrl
//                                                                 withRatio:9.0/16.4
//                                                                      date:[NSDate timeIntervalSinceReferenceDate]
//                                                                 isComming:YES
//                                                                     owner:messageT.owner];
                        
                        
                    } else if (i % 13 == 0) {
                        
                        NSString *textDemo3 = @"link: :Dbaomoi.com/abc:)/de:Df/-punch/-punchh xyz\nlink: <a href=\"facebook.com/theme\">Theme's facebook</a>\nemail: themnd@vng.com.vn\ncall me: 0987071077\n<b>List of emotions:</b>\n:), :~, :B, :|, The quick brown fox jumps over the lazy dog \n8-), :-((";
                        
                        message = [[UXAttributeMessage alloc] initWithContent:textDemo3
                                                                         date:[NSDate timeIntervalSinceReferenceDate]
                                                                    isComming:i % 2 == 0
                                                                        owner:messageT.owner];
                        
                    } else {
                        
                        BOOL dummyIncomming = i % 2 == 0 || i % 13 == 0;
                        
                        message = [[UXAttributeMessage alloc] initWithContent:messageT.content
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
        
        //NSLog(@"Current size %f", [self currentSizeOfData]);
        
        if (completion) {
            completion(fromIndex, toIndex);
        }
    }
}

- (void)insertData:(UXMessage *)data atIndex:(NSUInteger)index {
    if (data) {
        [self.dataArray insertObject:data atIndex:index];
    }
}

- (void)replaceIndex:(NSUInteger)index withData:(UXMessage *)data {
    if (data && (index < self.dataArray.count)) {
        [self.dataArray replaceObjectAtIndex:index withObject:data];
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

- (NSArray *)messagesFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    return [self.dataArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(fromIndex, toIndex - fromIndex)]];
}

@end
