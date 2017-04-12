//
//  UXAttributeNode.m
//  MessengerUX
//
//  Created by CPU11815 on 4/12/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXAttributeNode.h"
#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>

#import "CommonDefines.h"

static const NSTimeInterval kLongPressTimeInterval = 0.5;

#import "NSAttributedString+NimbusAttributedLabel.h"
#import "NIHTMLParser.h"
#import "NSString+Extend.h"
#import "UIImage+Extend.h"

@implementation UXAttributeNode

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

#pragma mark - Return parameter

// Return ready-to-display image to show (as a placeholder), image is must to be decoded for performent
+ (nullable UIImage *)displayWithParameters:(nullable id<NSObject>)parameters
                                isCancelled:(AS_NOESCAPE asdisplaynode_iscancelled_block_t)isCancelledBlock {
    return nil;
}

// Return parameter for drawRect:withParameters:isConcelled:isRasterizing method to draw things...
- (nullable id<NSObject>)drawParametersForAsyncLayer:(_ASDisplayLayer *)layer {
    
    NSDictionary * dic = @{
                           @"bounds" : [NSValue valueWithCGRect:self.bounds],
                           @"backgroundColor" : self.backgroundColor,
                           @"_touchedLink" : _touchedLink,
                           @"_linkColor" : _linkColor,
                           @"_linkHighlightColor" : _linkHighlightColor,
                           @"_htmlParser" : _htmlParser
                           };
    return dic;
}

#pragma mark - Drawing

// Draw things within this method, this method need to draw layer content into CGBitmapContext.
// The current UIGraphics context will be set to an appropriate context
+ (void)drawRect:(CGRect)bounds withParameters:(nullable id <NSObject>)parameters
     isCancelled:(AS_NOESCAPE asdisplaynode_iscancelled_block_t)isCancelledBlock
   isRasterizing:(BOOL)isRasterizing {
    
    NSDictionary * params = (NSDictionary *)parameters;
    CGRect drawParameterBounds = [(NSValue *)params[@"bounds"] CGRectValue];
    UIColor * backgroundColor = isRasterizing ? nil : params[@"backgroundColor"];
    NSTextCheckingResult* _touchedLink = params[@"_touchedLink"];
//    UIColor* _linkColor = params[@"_linkColor"];
    UIColor* _linkHighlightColor = params[@"_linkHighlightColor"];
    NIHTMLParser *_htmlParser = params[@"_htmlParser"];
    
    CGRect rect = bounds;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    NSAssert(ctx != nil, @"This is no good without a context.");

    CGContextSaveGState(ctx);
    
    // Fill background
    if (backgroundColor != nil) {
        [backgroundColor setFill];
        UIRectFillUsingBlendMode(CGContextGetClipBoundingBox(ctx), kCGBlendModeCopy);
    }
    
    // Draw text
    
    if (CGSizeEqualToSize(CGSizeZero, _htmlParser.fitSize)) {
        [_htmlParser getBoundsSizeByWidth:rect.size.width];
    }
    
    if (_htmlParser != nil && nil != _htmlParser.attributedString) {
        
        if (!_htmlParser.isTop) {
            int y = _htmlParser.fitSize.height/2 - rect.size.height/2;
            rect.origin.y = y;
        }
        
        //[parser detectLinks];
        //[parser mutableAttributedStringWithLinkStylesApplied];
        
        // CoreText context coordinates are the opposite to UIKit so we flip the bounds
        CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, drawParameterBounds.size.height), 1.f, -1.f));
        CGContextTranslateCTM( ctx, rect.origin.x, rect.origin.y );
        
        //Create text frame if needed
        [_htmlParser createTextFrame:drawParameterBounds];
        //Create lines if needed
        [_htmlParser createLines:drawParameterBounds];
        
        //Get number of lines and check if it is bigger than the limit? Need to 'cut' it or not?
        CFArrayRef textLines = CTFrameGetLines(_htmlParser.textFrame);
        
        CFIndex count = CFArrayGetCount(textLines);
        
        NSInteger numberOfLines = _htmlParser.numberOfLines;
        
        if (numberOfLines > 0) {
            if (_htmlParser.fitSize.height <= rect.size.height) {
                numberOfLines = 0;
            }
            else {
                count = numberOfLines = MIN(count, numberOfLines);
            }
        }
        
        //if numberOfLines = 0, no need to 'cut' the label, draw all things at once
        if (numberOfLines == 0) {
            if (_htmlParser.textFrame && ctx) {
                CTFrameDraw(_htmlParser.textFrame, ctx);
            }
        }
        
        //draw emoticon and runs
        CGSize sizeLastRun = CGSizeZero;
        if (_htmlParser.hasEmoticon || numberOfLines > 0) {
            CGRect imgBounds  = CGRectZero;
            
            CFIndex lineCount = CFArrayGetCount(textLines);
            if (lineCount >= count) {
                NSUInteger lineIndex = 0;
                for (int i = 0; i < count; i ++) {
                    
                    CTLineRef line = CFArrayGetValueAtIndex(textLines, i);
                    NSArray *runs = (NSArray *)CTLineGetGlyphRuns(line);
                    NSInteger numRuns = runs.count;
                    BOOL hadMoreText = NO;
                    for (NSInteger j = numRuns - 1; j >= 0; j --) {
                        CTRunRef run = (__bridge CTRunRef)[runs objectAtIndex:j];
                        NSDictionary *runAttributes = (__bridge NSDictionary *)CTRunGetAttributes(run);
                        CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(__bridge id)kCTRunDelegateAttributeName];
                        
                        //Draw lines one by ones and try to cut it.
                        if (numberOfLines > 0) {
                            CGFloat ascent;
                            CGFloat descent;
                            
                            CFRange runRange = CTRunGetStringRange(run);
                            CTRunGetTypographicBounds(run, runRange, &ascent, &descent, 0);
                            float top = 0;
                            CGPoint mOrigin = [[_htmlParser.origins objectAtIndex:i] CGPointValue];
                            CGFloat yLine = rect.size.height - mOrigin.y + top;
                            
                            if ((i == count - 1) && ((j == numRuns - 1) || !hadMoreText)) {
                                NSString *moreString = @"See more";
                                NSString *prefixString = @"... ";
                                if (_htmlParser.moreText) {
                                    moreString = _htmlParser.moreText;
                                }
                                NSString *prefixMoreString = [NSString stringWithFormat:@"%@%@", prefixString, moreString];
                                prefixMoreString = [prefixMoreString trimStringSpaces];
                                
                                NSRange range = NSMakeRange(runRange.location, runRange.length);
                                CGRect endRunRect = [self getRect:drawParameterBounds withParser:_htmlParser fromIndex:range.location attstring:_htmlParser.attributedString];
                                NSAttributedString *endAttrString = [_htmlParser.attributedString attributedSubstringFromRange:range];
                                NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@""];
                                
                                NSString *space = nil;
                                NSString *endString = [[endAttrString.string stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                                endString = [self subStringRemoveSpaceSuffixString:endString];
                                NSInteger index = endString.length;
                                while (index >= 0) {
                                    if (index < endString.length) {
                                        space = [endString substringWithRange:NSMakeRange(index, 1)];
                                    }
                                    if ([space isEqualToString:@" "] || index == endString.length) {
                                        NSAttributedString *temp = [endAttrString attributedSubstringFromRange:NSMakeRange(0, index)];
                                        
                                        CGSize sizePrefixString = [_htmlParser getTextSize:temp.string];
                                        if (delegate) {
                                            sizePrefixString.width = EMOTICON_WIDTH;
                                        }
                                        
                                        CGSize sizePrefixMoreString = [_htmlParser getTextSize:prefixMoreString];
                                        sizeLastRun = CGSizeMake(endRunRect.origin.x + sizePrefixString.width + sizePrefixMoreString.width, sizePrefixMoreString.height);
                                        if (sizeLastRun.width >= rect.size.width) {
                                            index--;
                                            continue;
                                        }
                                        
                                        [result appendAttributedString: temp];
                                        break;
                                    }
                                    index--;
                                }
                                if (index < 0 && j > 0) {
                                    continue;
                                }
                                else {
                                    hadMoreText = YES;
                                }
                                
                                if (moreString.length == 0) {
                                    prefixString = [prefixString trimStringSpaces];
                                }
                                
                                if (prefixString.length > 0) {
                                    NSMutableAttributedString *attributedPrefix = [[NSMutableAttributedString alloc] initWithString:prefixString];
                                    [attributedPrefix setTextColor:_htmlParser.defaultTextColor];
                                    [result appendAttributedString:attributedPrefix];
                                }
                                
                                //                                CGSize myStringSize = [parser getTextSize:result.string];
                                
                                if (moreString.length > 0) {
                                    NSDictionary *mattrs = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                            (id)_htmlParser.linkColor.CGColor, kCTForegroundColorAttributeName,
                                                            nil];
                                    NSMutableAttributedString *attributedViewMore = [[NSMutableAttributedString alloc] initWithString:moreString attributes:mattrs];
                                    [attributedViewMore setFont:_htmlParser.fontText];
                                    [result appendAttributedString:attributedViewMore];
                                }
                                
                                if (i > 0) {
                                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                                    paragraphStyle.firstLineHeadIndent = 0;
                                    [result addAttributes: @{NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, result.length)];
                                }
                                
                                CGFloat x = endRunRect.origin.x;
                                CGFloat y = rect.size.height - (endRunRect.origin.y + endRunRect.size.height);
                                CGMutablePathRef path = CGPathCreateMutable();
                                CGFloat h = ceilf(endRunRect.size.height);
                                CGPathAddRect(path, NULL, CGRectMake(x, y, rect.size.width, h));
                                NSInteger length = [result length];
                                CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)result);
                                CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, length), path, NULL);
                                CTFrameDraw(frame, ctx);
                                CFRelease(frame);
                                CFRelease(path);
                                CFRelease(framesetter);
                                
                                //                                CGSize moreSize = [parser getTextSize:moreString];
                                //                                UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                //                                UIImage *highlightImage = [UIImage imageWithColor:[UIColor colorWithRed:51.0f/255 green:51.0f/255 blue:51.0f/255 alpha:0.5]];
                                //                                //custom font and color for the button, which is set in the parser of this label
                                //                                [moreButton setTitleColor:parser.moreButtonColor forState:UIControlStateNormal];
                                //
                                //                                //==============
                                //                                [moreButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
                                //                                [self addSubview:moreButton];
                                //                                [moreButton addTarget:self action:@selector(moreTextButtonPress:) forControlEvents:UIControlEventTouchUpInside];
                                //
                                //                                CGRect boundsMoreButton = CGRectMake(x + myStringSize.width - 5, (endRunRect.origin.y + endRunRect.size.height - moreSize.height) - 2, moreSize.width + 7, moreSize.height + 4);
                                //                                [moreButton setFrame:boundsMoreButton];
                                
                                if (delegate) {
                                    [self addEmoticon:delegate withParser:_htmlParser run:run imgBounds:imgBounds line:line lineIndex:lineIndex rect:rect ctx:ctx];
                                }
                                
                                continue;//break;
                            }
                            
                            if (nil == delegate) {
                                CGContextSetTextPosition(ctx, mOrigin.x, yLine);
                                CTRunDraw(run, ctx, CFRangeMake(0, 0));
                                
                                continue;
                            }
                        }
                        
                        //add emoticons
                        [self addEmoticon:delegate withParser:_htmlParser run:run imgBounds:imgBounds line:line lineIndex:lineIndex rect:rect ctx:ctx];
                    }
                    
                    lineIndex++;
                }
            }
        }
        
        if (nil != _touchedLink) {
            //NSLog(@"Draw touched link");
            // Draw the link's background first.
            [_linkHighlightColor setFill];
            
            NSRange linkRange = _touchedLink.range;
            
            /***** Do a binary search here to quickly find the intersection *****/
            
            int firstLineIndex = 0;
            {
                int left, right, mid;
                left = 0; right = (int)count-1;
                while(left <= right){
                    mid = (left + right)/2;
                    CTLineRef line = CFArrayGetValueAtIndex(textLines, mid);
                    CFRange lineRange = CTLineGetStringRange(line);
                    if(lineRange.location + lineRange.length - 1 >= linkRange.location){
                        right = mid - 1;
                        firstLineIndex = mid;
                    }else{
                        left = mid + 1;
                    }
                }
            }
            
            /*****************************************************************/
            
            for (CFIndex i = firstLineIndex; i < count; i++) {
                CTLineRef line = CFArrayGetValueAtIndex(textLines, i);
                
                CFRange stringRange = CTLineGetStringRange(line);
                // If the line's range is bigger than the link's range, then we can stop now
                if(stringRange.location > linkRange.location + linkRange.length - 1)
                    break;
                
                // Iterate through each of the "runs" (i.e. a chunk of text) and find the runs that
                // intersect with the link's range. For each of these runs, draw the highlight frame
                // around the part of the run that intersects with the link.
                CGRect highlightRect = CGRectZero;
                CFArrayRef runs = CTLineGetGlyphRuns(line);
                CFIndex runCount = CFArrayGetCount(runs);
                for (CFIndex k = 0; k < runCount; k++) {
                    
                    CTRunRef run = CFArrayGetValueAtIndex(runs, k);
                    
                    CFRange stringRunRange = CTRunGetStringRange(run);
                    NSRange lineRunRange = NSMakeRange(stringRunRange.location, stringRunRange.length);
                    NSRange intersectedRunRange = NSIntersectionRange(lineRunRange, linkRange);
                    if (intersectedRunRange.length == 0) {
                        continue;
                    }
                    
                    CGFloat ascent = 0.0f;
                    CGFloat descent = 0.0f;
                    CGFloat leading = 0.0f;
                    CGFloat width = (CGFloat)CTRunGetTypographicBounds(run,
                                                                       CFRangeMake(0, 0),
                                                                       &ascent,
                                                                       &descent,
                                                                       &leading);
                    CGFloat height = ascent + descent;
                    
                    CGFloat xOffset = CTLineGetOffsetForStringIndex(line,
                                                                    CTRunGetStringRange(run).location,
                                                                    nil);
                    
                    CGPoint mOrigin = [[_htmlParser.origins objectAtIndex:i] CGPointValue];
                    //need to turn the origin's up side down
                    mOrigin.y = drawParameterBounds.size.height - mOrigin.y;
                    
                    CGRect linkRect = CGRectMake(mOrigin.x + xOffset - leading,
                                                 mOrigin.y - descent,
                                                 width + leading + rect.origin.y,//alignment
                                                 height);
                    
                    linkRect = CGRectIntegral(linkRect);
                    
                    if (CGRectIsEmpty(highlightRect)) {
                        highlightRect = linkRect;
                        
                    } else {
                        highlightRect = CGRectUnion(highlightRect, linkRect);
                    }
                    
                    if (numberOfLines > 0 && (i == count - 1) && (k == runCount - 1)) {
                        if (!CGSizeEqualToSize(CGSizeZero, sizeLastRun)) {
                            highlightRect.size.width = sizeLastRun.width;
                        }
                    }
                }
                
                if (!CGRectIsEmpty(highlightRect)) {
                    
                    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:highlightRect cornerRadius:3.0f];
                    [path fill];
                }
            }
        }
    }
    
    CGContextRestoreGState(ctx);
}

+ (void)addEmoticon:(CTRunDelegateRef)delegate withParser:(NIHTMLParser *)parser run:(CTRunRef)run imgBounds:(CGRect)imgBounds line:(CTLineRef)line lineIndex:(NSUInteger)lineIndex rect:(CGRect)rect ctx:(CGContextRef)ctx {
    if (parser.origins && parser.origins.count > lineIndex) {
        NIImageAttachment* attachment = (__bridge NIImageAttachment *)CTRunDelegateGetRefCon(delegate);
        if(!attachment) return;
        
        CGFloat ascent;
        CGFloat descent;
        imgBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
        imgBounds.size.height = ascent + descent;
        CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
        CGPoint mOrigin = [[parser.origins objectAtIndex:lineIndex] CGPointValue];
        imgBounds.origin.x = mOrigin.x + 0 + xOffset;
        imgBounds.origin.y = rect.size.height - (mOrigin.y + descent);
        
        NSString* imgString = attachment.imageURL;
        
        
        NSString *prefix = @"bundle://";
        if ([imgString hasPrefix:prefix]) {
            imgString = [imgString substringFromIndex:prefix.length];
        }
        else {
            imgString = [NSString stringWithFormat:@"%@", imgString];
        }
        
        UIImage *img = [UIImage imageNamed:imgString];
        
        CGContextDrawImage(ctx, imgBounds, img.CGImage);
    }
}

+ (NSString*)subStringRemoveSpaceSuffixString:(NSString*)string {
    while (string.length > 0) {
        NSString *indexString = [string substringFromIndex:string.length-1];
        if ([indexString isEqualToString:@" "]) {
            string = [string substringToIndex:string.length-1];
        }
        else {
            return string;
        }
    }
    return string;
}

//MinhQ
+ (CGRect)getRect:(CGRect)frame withParser:(NIHTMLParser *)parser fromIndex:(NSInteger)index attstring:(NSAttributedString*)attributedString {
    
    CGRect imgBounds  = CGRectZero;
    
    [parser createLines:frame];
    
    NSUInteger lineIndex = 0;
    CFArrayRef textLines = CTFrameGetLines(parser.textFrame);
    CFIndex count = CFArrayGetCount(textLines);
    for (int i=0; i<count; ++i) { //5
        CTLineRef line = CFArrayGetValueAtIndex(textLines, i);
        NSArray *runs = (NSArray *)CTLineGetGlyphRuns(line);
        
        for (id runObj in runs) { //6
            CTRunRef run = (__bridge CTRunRef)runObj;
            
            CFRange runRange = CTRunGetStringRange(run);
            NSRange range = NSMakeRange(runRange.location, runRange.length);
            
            int indexRun = (int)range.location;
            
            if (index == indexRun) {
                CGFloat ascent;
                CGFloat descent;
                imgBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
                imgBounds.size.height = ascent + descent;
                
                CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //9
                CGPoint mOrigin = [[parser.origins objectAtIndex:lineIndex] CGPointValue];
                
                imgBounds.origin.x = mOrigin.x + 0 + xOffset;// + self.frame.origin.x;
                imgBounds.origin.y = mOrigin.y - descent - ascent + imgBounds.size.height/6;// + self.frame.origin.y;
                
                if (imgBounds.size.width == 0) {
                    //NSLog(@"getRectFromIndex width = %f", imgBounds.size.width);
                }
                return imgBounds;
            }
            
        }
        lineIndex++;
    }
    
    return imgBounds;
}

@end
