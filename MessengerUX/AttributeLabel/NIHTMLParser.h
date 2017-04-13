//
// Copyright 2011 Roger Chapman
//
// Forked from Objective-C-HMTL-Parser October 19, 2011 - Copyright 2010 Ben Reeves
//    https://github.com/zootreeves/Objective-C-HMTL-Parser
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

#define EMOTICON_WIDTH 21
#define EMOTICON_HEIGHT 16
#define EMOTICON_DESCENT 5
#define URL_MORETEXT_LINK @"zapp://url_zalochat_messenger_moretextbutton"

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "NSAttributedString+NimbusAttributedLabel.h"
//#import <Nimbus/NSMutableAttributedString+NimbusAttributedLabel.h>
#import "NIImageAttachment.h"

@interface NIHTMLParser : NSObject {
    NSMutableArray *_aLinks;
    BOOL _linksHaveBeenDetected;
    BOOL _highlighHaveBeenApplied;
    NSMutableArray* _detectedlinkLocations;
    UIColor* _linkColor;
    UIColor* _linkHighlightColor;
    NSMutableAttributedString *_attributedString;
}

+(int)getPrefixTreeCounter;

-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lineLimit:(int)lineLimit lineLimitTo:(int)lineLimitTo lengthLimit:(int)lengthLimit lengthLimitTo:(int)lengthLimitTo;
-(id)initWithStringWithLimit:(NSString*)string options:(NSArray*)options viewMoreText:(NSString*)viewMoreText lineLimit:(int)lineLimit lineLimitTo:(int)lineLimitTo lengthLimit:(int)lengthLimit lengthLimitTo:(int)lengthLimitTo;
-(id)initWithStringWithLimit:(NSString*)string options:(NSArray*)options viewMoreText:(NSString*)viewMoreText lineLimit:(int)lineLimit lineLimitTo:(int)lineLimitTo lengthLimit:(int)lengthLimit lengthLimitTo:(int)lengthLimitTo parseEmoticon:(BOOL)isParse;
-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lengthLimit:(int)lengthLimit lengthLimitTo:(int)lengthLimitTo;
-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lineLimit:(int)lineLimit lineLimitTo:(int)lineLimitTo;
-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lengthLimit:(int)lengthLimit;
-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lineLimit:(int)lineLimit;
-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lengthLimit:(int)lengthLimit parseEmoticon:(BOOL)isParse;
-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lengthLimit:(int)lengthLimit lengthLimitTo:(int)lengthLimitTo parseEmoticon:(BOOL)isParse;
-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lineLimit:(int)lineLimit  parseEmoticon:(BOOL)isParse;
-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lineLimit:(int)lineLimit lineLimitTo:(int)lineLimitTo  parseEmoticon:(BOOL)isParse;
-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lineLimit:(int)lineLimit lineLimitTo:(int)lineLimitTo lengthLimit:(int)lengthLimit lengthLimitTo:(int)lengthLimitTo parseEmoticon:(BOOL)isParse;

- (id)initWithString:(NSString*)string;
- (id)initWithString:(NSString *)string withNumberOfLines:(NSInteger)lines parseEmoticon:(BOOL)isParse;
- (id)initWithString:(NSString *)string withNumberOfLines:(NSInteger)lines moreText:(NSString*)moreText parseEmoticon:(BOOL)isParse;
- (id)initWithString:(NSString *)string options:(NSArray*)options;
- (id)initWithString:(NSString *)string parseEmoticon:(BOOL)isParse;
- (id)initWithString:(NSString *)string parseEmoticon:(BOOL)isParse options:(NSArray*)options;
- (id)initWithString:(NSString *)string options:(NSArray*)options withNumberOfLines:(NSInteger)lines;
- (id)initWithString:(NSString *)string options:(NSArray*)options withNumberOfLines:(NSInteger)lines moreText:(NSString*)moreText;

@property (nonatomic) BOOL hasEmoticon;

/* Custom color for each link */
@property (nonatomic, strong) UIColor* linkColor;

/* Custom font for each link */
@property (nonatomic, strong) UIFont *linkFont;

/* Custom color for each tag (user tag, or something else) */
@property (nonatomic, strong) UIColor* tagColor;

/* Custom font for each tag (user tag, or something else) */
@property (nonatomic, strong) UIFont* tagFont;

/* Custom color for the "View More" button */
@property (nonatomic, strong) UIColor* moreButtonColor;

/* Custom font for the "View More" button  */
@property (nonatomic, strong) UIFont* moreButtonFont;

@property (nonatomic, strong) NSMutableArray *aLinks;
@property (nonatomic, strong) UIFont *fontText;
@property (nonatomic, strong) NSMutableAttributedString *attributedString;
@property (nonatomic) CGSize fitSize;

@property (nonatomic, strong) NSMutableArray* detectedlinkLocations;
@property (nonatomic) BOOL linksHaveBeenDetected;
@property (nonatomic) BOOL highlighHaveBeenApplied;

/** The prefix string that will be appended for all the links */
@property (nonatomic, strong) NSMutableString *prefix;

/** if YES then the text will be align at top, need to set to YES in case the string is limited. Default value is NO */
@property (nonatomic) BOOL isTop;//default is center

/**
 * Sets the text alignment for the text.
 *
 * TextAlignment Values:
 *
 * - kCTLeftTextAlignment
 *
 * - kCTCenterTextAlignment
 *
 * - kCTRightTextAlignment
 *
 * - kCTJustifiedTextAlignment
 *
 * - kCTNaturalTextAlignment
 */
@property (nonatomic) CTTextAlignment textAlignment;

@property (nonatomic, strong) UIColor *defaultTextColor;

/** Number of lines will be limited on the label */
@property (nonatomic) NSInteger numberOfLines;

/** The text that will be appear on the "More Text" button */
@property (nonatomic, strong) NSString *moreText;

/** Auto detect and highligh links or not */
@property (nonatomic, assign) BOOL autoDetectLinks;

/** Store the original inputed string - the full text data, used for copy method */
@property (nonatomic, strong) NSString *originString;

@property (nonatomic, strong) NSMutableDictionary *storeHeightWithLines;

@property (nonatomic) BOOL parseBoldTag;
@property (nonatomic) BOOL parseUnderlineTag;
@property (nonatomic) BOOL parseItalicTag;
@property (nonatomic) BOOL parseFontTag;
@property (nonatomic) BOOL parseImageTag;
@property (nonatomic) BOOL parseLinkTag;
@property (nonatomic) BOOL parseLinkSeeMoreChatMessage;

/** Lock all the tag for parsing on chat */
- (void)lockTagsInChat;

- (CGSize)getTextSize:(NSString*)text;


@property (nonatomic) CTFrameRef textFrame;
@property (nonatomic, strong) NSMutableArray *origins;

/** Get Bounding size with a specific with for the label for showing the string inputed in this parser
 *
 * The function also store the calculated size to the variable 'fitSize' for using later
 */
- (CGSize)getBoundsSizeByWidth:(NSInteger)maxWidth;

/** Get the height of the label for showing the limited number of lines and the width */
- (CGFloat)getHeightWithNumberOfLines:(NSInteger)lines maxW:(CGFloat)maxW;

/** Create text frame for the corresponding text */
- (void)createTextFrame:(CGRect)bounds;
/** Create the lines forthe corresponding lines */
- (void)createLines:(CGRect)bounds;

/** Clear the text frame */
- (void)resetTextFrame;

/** Expand to the original string. In case we use the init function: initWithStringWithLimit, the string will be cut off by our limitation.
 * If we want to show the full string, we must call this function to tell the parser get the original string first
 */
- (void)expandOriginalString;

@end
