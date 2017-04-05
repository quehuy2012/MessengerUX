//
//  UXAlbumMessage.h
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessage.h"

@interface UXAlbumMessage : UXMessage

@property (nonatomic) NSArray<NSURL *> * imageURLs;
@property (nonatomic) NSArray<UIImage *> * images;

- (instancetype)initWithImages:(NSArray<UIImage *> *)images date:(NSTimeInterval)time isComming:(BOOL)isComming owner:(UXOwner *)owner;

- (instancetype)initWithImageURLs:(NSArray<NSURL *> *)imageURLs date:(NSTimeInterval)time isComming:(BOOL)isComming owner:(UXOwner *)owner;

@end
