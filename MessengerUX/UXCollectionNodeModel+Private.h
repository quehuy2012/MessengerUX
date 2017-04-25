//
//  UXCollectionNodeModel+Private.h
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#ifndef UXCollectionNodeModel_Private_h
#define UXCollectionNodeModel_Private_h

@interface UXCollectionNodeModel()

@property (nonatomic, strong) NSArray* sections; // Array of NICollectionViewModelSection
@property (nonatomic, strong) NSArray* sectionIndexTitles;
@property (nonatomic, strong) NSDictionary* sectionPrefixToSectionIndex;

- (void)_resetCompiledData;
- (void)_compileDataWithListArray:(NSArray *)listArray;
- (void)_compileDataWithSectionedArray:(NSArray *)sectionedArray;
- (void)_setSectionsWithArray:(NSArray *)sectionsArray;

@end

@interface UXCollectionNodeModelSection : NSObject

+ (id)section;

@property (nonatomic, copy) NSString* headerTitle;
@property (nonatomic, copy) NSString* footerTitle;
@property (nonatomic, strong) NSArray* rows;

@end

#endif /* UXCollectionNodeModel_Private_h */
