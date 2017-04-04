//
//  UXMutableCollectionNodeModel+Private.h
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#ifndef UXMutableCollectionNodeModel_Private_h
#define UXMutableCollectionNodeModel_Private_h

@interface UXMutableCollectionNodeModel (Private)

@property (nonatomic, strong) NSMutableArray* sections; // Array of NICollectionViewModelSection

@end

@interface UXCollectionNodeModelSection (Mutable)

- (NSMutableArray *)mutableRows;

@end

#endif /* UXMutableCollectionNodeModel_Private_h */
