//
//  UXMutableTableNodeModel+Private.h
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#ifndef UXMutableTableNodeModel_Private_h
#define UXMutableTableNodeModel_Private_h

#import <Foundation/Foundation.h>

@interface UXMutableTableNodeModel (Private)

@property (nonatomic, strong) NSMutableArray* sections; // Array of NITableViewModelSection
@property (nonatomic, strong) NSMutableArray* sectionIndexTitles;
@property (nonatomic, strong) NSMutableDictionary* sectionPrefixToSectionIndex;

@end

@interface UXTableNodeModelSection (Mutable)

- (NSMutableArray *)mutableRows;

@end

#endif /* UXMutableTableNodeModel_Private_h */
