//
//  UXTableNodeModel+Private.h
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#ifndef UXTableNodeModel_Private_h
#define UXTableNodeModel_Private_h

#import <Foundation/Foundation.h>

@interface UXTableNodeModel()

@property (nonatomic, strong) NSArray* sections; // Array of NITableViewModelSection
@property (nonatomic, strong) NSArray* sectionIndexTitles;
@property (nonatomic, strong) NSDictionary* sectionPrefixToSectionIndex;

- (void)_resetCompiledData;
- (void)_compileDataWithListArray:(NSArray *)listArray;
- (void)_compileDataWithSectionedArray:(NSArray *)sectionedArray;
- (void)_compileSectionIndex;
- (void)_setSectionsWithArray:(NSArray *)sectionsArray;

@end

@interface UXTableNodeModelSection : NSObject

+ (id)section;

@property (nonatomic, copy) NSString* headerTitle;
@property (nonatomic, copy) NSString* footerTitle;
@property (nonatomic, strong) NSArray* rows;

@end

#endif /* UXTableNodeModel_Private_h */
