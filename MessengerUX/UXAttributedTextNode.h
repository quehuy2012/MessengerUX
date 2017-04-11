//
//  UXAttributedTextNode.h
//  MessengerUX
//
//  Created by CPU11808 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface UXAttributedTextNode : ASDisplayNode

-(instancetype)initWithText:(NSString *)text;

@property(nonatomic) NSString *text;

// default system font 16 plain
@property(nonatomic) UIFont *font;

// default text draws black
@property(nonatomic) UIColor *textColor;

// default CTTextAlignmentLeft
@property(nonatomic) CTTextAlignment textAlignment;

@property(nonatomic) UIColor *linkColor;

@property(nonatomic) UIFont *linkFont;

@property(nonatomic) UIColor *tagColor;

@property(nonatomic) UIFont* tagFont;

// default is NSLineBreakByTruncatingTail. used for single and multiple lines of text
//@property(nonatomic) NSLineBreakMode lineBreakMode;

/**
 * The color of the link's background when touched/highlighted.
 *
 * If no color is set, the default is [UIColor colorWithWhite:0.5 alpha:0.2]
 * If you do not want to highlight links when touched, set this to [UIColor clearColor]
 * or set it to the same color as your view's background color (opaque colors will perform
 * better).
 */

@property (nonatomic, strong) UIColor* linkHighlightColor;

@end
