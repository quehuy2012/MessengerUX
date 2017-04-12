//
// Copyright 2011 Roger Chapman
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

// In standard UI text alignment we do not have justify, however we can justify in CoreText
#ifndef UITextAlignmentJustify
#define UITextAlignmentJustify ((UITextAlignment)kCTJustifiedTextAlignment)
#endif

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@class NIHTMLParser;
@protocol NIAttributedLabelDelegate;

/**
 * A UILabel that utilizes NSAttributedString to format its text.
 *
 *      @ingroup NimbusAttributedLabel
 */

@interface NIAttributedLabel : UILabel {
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
@property (nonatomic, weak) id<NIAttributedLabelDelegate> delegate;

/**
 * This refer to an object of class NIHTMLParser, the object must be parse before attach to the label.
 */
@property (nonatomic, strong) NIHTMLParser *htmlParser;

/**
 * Disable opening the action sheet when we have a long press on a link, email address or phone number.
 */
@property (nonatomic, assign) BOOL disableOpenActionSheetWhenHoldOnLink;
@end

/**
 * The attributed label delegate used to inform of user interactions.
 *
 * @ingroup NimbusAttributedLabel-Protocol
 */
@protocol NIAttributedLabelDelegate <NSObject>
@optional

/**
 * Called when the user taps and releases a detected link.
 */
-(void)attributedLabel:(NIAttributedLabel*)attributedLabel
         didSelectLink:(NSURL*)url
               atPoint:(CGPoint)point;
-(void)attributedLabel:(NIAttributedLabel*)attributedLabel
        didSelectPhone:(NSString*)phoneNumber
               atPoint:(CGPoint)point;
- (void)menuLabel:(NIAttributedLabel *)menu didCopy:(BOOL)copy;
- (BOOL)touchedGoToFeedDetail:(NIAttributedLabel*)attributedLabel;
@end
