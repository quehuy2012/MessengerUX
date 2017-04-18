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
                    
                        static UIImage * img1;
                        static UIImage * img2;
                        static UIImage * img3;
                        static UIImage * img4;
                        static UIImage * img5;
                    
                        static dispatch_once_t onceToken;
                        dispatch_once(&onceToken, ^{
                            img1 = [UIImage imageNamed:@"groupImage"];
                            img2 = img1;
                            img3 = img1;
                            img4 = img1;
                            img5 = img1;
                        });
                    
                    
                        if (i % 4 == 0) {
                            
//                            UIImage * img1 = [UIImage imageNamed:@"cameraThumb"];
//                            UIImage * img2 = [UIImage imageNamed:@"tempImg"];
//                            UIImage * img3 = [UIImage imageNamed:@"drawThumb"];
//                            UIImage * img4 = [UIImage imageNamed:@"groupImage"];
//                            UIImage * img5 = [UIImage imageNamed:@"galleryThumb"];
                            
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
                        
                        message = [[UXAlbumMessage alloc] initWithImages:imgs
                                                                    date:[NSDate timeIntervalSinceReferenceDate]
                                                               isComming:(i % 3 == 0)
                                                                   owner:messageT.owner];
                    
//                    NSArray * urls = @[[NSURL URLWithString:@"https://petapixel.com/assets/uploads/2012/02/sample1_mini.jpg"]
//                                       , [NSURL URLWithString:@"http://www.brooks.com/applications-by-industry/life-science/~/media/Images/Life%20Sciences/biological_sample_460w.jpg"]
//                                       , [NSURL URLWithString:@"https://www.nature.org/cs/groups/webcontent/@web/@giftplanning/documents/media/sample-cga-rates-splash-1.jpg"]
//                                       , [NSURL URLWithString:@"http://truesample.com/wp-content/themes/truesample/img/icon-Respondent020716v2.png"]
//                                       , [NSURL URLWithString:@"https://petapixel.com/assets/uploads/2012/02/sample1_mini.jpg"]
//                                       , [NSURL URLWithString:@"http://cdn-jpg.allyou.com/sites/default/files/image/2014/01/300x300/i/2010/09/freesample-m.jpg"]
//                                       , [NSURL URLWithString:@"https://petapixel.com/assets/uploads/2012/02/sample1_mini.jpg"]
//                                       , [NSURL URLWithString:@"http://www.naceweb.org/uploadedImages/images/2017/feature/sample-faculty-reference-letter.jpgg"]
//                                       , [NSURL URLWithString:@"https://fthmb.tqn.com/eg-jRwCZaVYY6FGjr4r0qeyCt2I=/400x250/filters:no_upscale()/about/GettyImages-161545902-58ee47233df78cd3fc20cf31.jpg"]
//                                       , [NSURL URLWithString:@"https://petapixel.com/assets/uploads/2012/02/sample1_mini.jpg"]
//                                       , [NSURL URLWithString:@"https://www.surreynanosystems.com/assets/media/sample-foil_Medium%20Image.jpg"]
//                                       , [NSURL URLWithString:@"https://petapixel.com/assets/uploads/2012/02/sample1_mini.jpg"]
//                                       , [NSURL URLWithString:@"https://cdn5.kicksonfire.com/wp-content/uploads/2017/04/KAWS-Air-Jordan-4-Black-Suede-Sample-681x443.jpg?x77385"]
//                                       , [NSURL URLWithString:@"https://cdn0.vox-cdn.com/thumbor/4OG6sHIuiqNPbyKazJl7rKJBnBc=/0x0:2000x1145/1200x800/filters:focal(840x413:1160x733)/cdn0.vox-cdn.com/uploads/chorus_image/image/53585733/racked-sample-sales.0.0.jpg"]];
//                    
//                    
//                    message = [[UXAlbumMessage alloc] initWithImageURLs:urls
//                                                                date:[NSDate timeIntervalSinceReferenceDate]
//                                                           isComming:(i % 3 == 0)
//                                                               owner:messageT.owner];
                    
                    } else if (i % 9 == 0) {
                
                        message = [[UXTitleMessage alloc] initWithTitle:@"Section"];
                
                    } else if (i % 6 == 0) {
                
                        message = [[UXImageMessage alloc] initWithImage:[UIImage imageNamed:@"cameraThumb"]
                                                                   date:[NSDate timeIntervalSinceReferenceDate]
                                                              isComming:YES
                                                                  owner:messageT.owner];
                
                    } else if (i % 17 == 0) {
                        
                        NSURL * imageURL = [NSURL URLWithString:@"https://media.giphy.com/media/EJIFaXV55556M/giphy.gif"];
                        
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
//
                        NSString *textDemo3 = @"link: :Dbaomoi.com/abc:)/de:Df/-punch/-punchh xyz\nlink: <a href=\"facebook.com/theme\">Theme's facebook</a>\nemail: themnd@vng.com.vn\ncall me: 0987071077\n<b>List of emotions:</b>\n:), :~, :B, :|, The quick brown fox jumps over the lazy dog \n8-), :-((";
                        
                        message = [[UXAttributeMessage alloc] initWithContent:textDemo3
                                                                         date:[NSDate timeIntervalSinceReferenceDate]
                                                                    isComming:i % 2 == 0
                                                                        owner:messageT.owner];
                        
//                        message = [[UXLocationMessage alloc] initWithLatitude:37.7749
//                                                                  andLongtide:-122.4194
//                                                                         date:[NSDate timeIntervalSinceReferenceDate]
//                                                                    isComming:i % 2 == 0
//                                                                        owner:messageT.owner];
                        
                    } else {
                    
                        BOOL dummyIncomming = i % 2 == 0 || i % 13 == 0;
                        
                        message = [[UXAttributeMessage alloc] initWithContent:messageT.content
                                                                         date:[NSDate timeIntervalSinceReferenceDate]
                                                                    isComming:dummyIncomming
                                                                        owner:messageT.owner];
                        
//                        message = [[UXTextMessage alloc] initWithContent:messageT.content
//                                                                    date:[NSDate timeIntervalSinceReferenceDate]
//                                                               isComming:dummyIncomming
//                                                                   owner:messageT.owner];
                        
                    }
                
                    if (message) {
                        [ret addObject:message];
                    }
                }
            }
            
            dataset = nil;
            lineByLineContents = nil;
            datasetContent = nil;
        }
    });
    
    return ret;
}

- (void)insertNewPage:(NSArray<UXMessage *> *)datas withCompletion:(void (^)(NSUInteger fromIndex, NSUInteger toIndex))completion {
    
    if (datas) {
        NSUInteger fromIndex = [self getDataArray].count;
        NSUInteger toIndex = fromIndex + datas.count - 1;
        
        [self.dataArray addObjectsFromArray:datas];
        
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

- (void)dealloc {
    
    NSLog(@"Dealloc feed");
    
    if (self.dataArray) [self.dataArray removeAllObjects];
}

@end
