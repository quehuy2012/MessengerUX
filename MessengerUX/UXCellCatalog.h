//
//  UXCellCatalog.h
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "UXNodeModel.h"

@interface UXTitleCellNode : ASCellNode <UXCellNode>

@end

@interface UXTitleWithImageCellNode : UXTitleCellNode

@end

@interface UXLoadingCellNode : ASCellNode <UXCellNode>

@end
