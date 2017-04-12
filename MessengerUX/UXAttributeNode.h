//
//  UXAttributeNode.h
//  MessengerUX
//
//  Created by CPU11815 on 4/12/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class NIHTMLParser;
@protocol UXAttributeNodeDelegate;

@interface UXAttributeNode : ASControlNode {
    NSTextCheckingResult* _touchedLink;
    UIColor* _linkColor;
    UIColor* _linkHighlightColor;
    NIHTMLParser *_htmlParser;
}

/**
 * The color of the link's background when touched/highlighted.
 *
 * If no color is set, the default is [UIColor colorWithWhite:0.5 alpha:0.2]
 * If you do not want to highlight links when touched, set this to [UIColor clearColor]
 * or set it to the same color as your view's background color (opaque colors will perform
 * better).
 */
@property (nonatomic, strong) UIColor* linkHighlightColor;

/**
 * The attributed label notifies the delegate of any user interactions.
 */
@property (nonatomic, weak) id<UXAttributeNodeDelegate> delegate;

/**
 * This refer to an object of class NIHTMLParser, the object must be parse before attach to the label.
 */
@property (nonatomic, strong) NIHTMLParser *htmlParser;

/**
 * Disable opening the action sheet when we have a long press on a link, email address or phone number.
 */
@property (nonatomic, assign) BOOL disableOpenActionSheetWhenHoldOnLink;

@end

@protocol UXAttributeNodeDelegate <NSObject>
@optional

/**
 * Called when the user taps and releases a detected link.
 */
-(void)attributeNode:(UXAttributeNode *)attributeNode
         didSelectLink:(NSURL*)url
               atPoint:(CGPoint)point;

-(void)attributeNode:(UXAttributeNode *)attributeNode
        didSelectPhone:(NSString*)phoneNumber
               atPoint:(CGPoint)point;

- (void)menuLabel:(UXAttributeNode *)menu
          didCopy:(BOOL)copy;

- (BOOL)touchedGoToFeedDetail:(UXAttributeNode *)attributedNode;

@end
