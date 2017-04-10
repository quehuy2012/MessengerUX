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

#import <Foundation/Foundation.h>

#import "CommonDefines.h"

static const NSTimeInterval kLongPressTimeInterval = 0.5;

#import "UXAttributedLabel.h"
#import "NSAttributedString+NimbusAttributedLabel.h"
#import "UXHTMLParser.h"
#import "NSString+Extend.h"
#import "UIImage+Extend.h"



@interface UXAttributedLabel () <UIActionSheetDelegate>
{
    NSTextCheckingResult* _actionSheetLink;
}
@property (nonatomic, strong) NSTimer* longPressTimer;
@property (nonatomic, strong) NSTextCheckingResult* actionSheetLink;
@property (nonatomic) BOOL doingLongGesture;
@property (nonatomic, strong) NSMutableAttributedString *tempAttributedString;
@end
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UXAttributedLabel


@synthesize linkHighlightColor = _linkHighlightColor;
@synthesize delegate = _delegate;



/////////////
//MinhQ
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
-(id)init{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.userInteractionEnabled = YES;
    [self setBackgroundColor:self.backgroundColor];
}

-(void)dealloc {
    self.htmlParser = nil;
    self.longPressTimer = nil;
    NSLog(@"Label Control dealloc");
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setNeedsDisplay {
    [super setNeedsDisplay];
}

#pragma mark - Public Methods

- (void)setHtmlParser:(UXHTMLParser *)htmlParser{
    _htmlParser = htmlParser;
    [self setNeedsDisplay];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor *)linkHighlightColor {
    if (!_linkHighlightColor) {
        _linkHighlightColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
    }
    return _linkHighlightColor;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLinkHighlightColor:(UIColor *)linkHighlightColor {
    if (_linkHighlightColor != linkHighlightColor) {
        _linkHighlightColor = linkHighlightColor;
        
        [self setNeedsDisplay];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint) point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    
    return CGRectMake(point.x, point.y - descent, width, height);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSTextCheckingResult *)linkAtIndex:(CFIndex)idx {
    NSTextCheckingResult* foundResult = nil;
    
    if (self.htmlParser.autoDetectLinks) {
        
        /** Do a binary search here */
        NSMutableArray *arr = self.htmlParser.detectedlinkLocations;
        int left = 0, right = (int)arr.count-1, mid;
        while(left<=right){
            mid = (left + right) / 2;
            NSTextCheckingResult *result = [arr objectAtIndex:mid];
            //small notice here, extend the link range by 1 for better accuracy
            NSRange linkRange = result.range;
            ++linkRange.length;
            if (NSLocationInRange(idx, linkRange)) {
                foundResult = result;
                break;
            }
            if(idx < result.range.location)
                right = mid - 1;
            else if(idx >= result.range.location + result.range.length)
                left = mid + 1;
            else
                break;
        }
        
    }
    
    return foundResult;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSTextCheckingResult *)linkAtPoint:(CGPoint)point {
    static const CGFloat kVMargin = 5.0f;
    if (!CGRectContainsPoint(CGRectInset(self.bounds, 0, -kVMargin), point)) {
        return nil;
    }
    
    CFArrayRef lines = CTFrameGetLines(self.htmlParser.textFrame);
    if (!lines) return nil;
    CFIndex count = CFArrayGetCount(lines);
    
    NSTextCheckingResult* foundLink = nil;
    
    CGPoint origins[count];
    CTFrameGetLineOrigins(self.htmlParser.textFrame, CFRangeMake(0,0), origins);
    
    /** Do a binary search here for better performance */
    int left = 0, right = (int)count-1, mid;
    while(left <= right){
        mid = (left + right)/2;
        
        CGPoint linePoint = origins[mid];
        CTLineRef line = CFArrayGetValueAtIndex(lines, mid);
        
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        CGRect bounds = CGRectMake(CGRectGetMinX(self.bounds) ,
                                   CGRectGetMaxY(self.bounds)-CGRectGetMaxY(self.bounds),
                                   CGRectGetWidth(self.bounds),
                                   CGRectGetHeight(self.bounds));
        CGRect rect = CGRectMake(CGRectGetMinX(flippedRect),
                                 CGRectGetMaxY(bounds)-CGRectGetMaxY(flippedRect),
                                 CGRectGetWidth(flippedRect),
                                 CGRectGetHeight(flippedRect));
        
        //rect = CGRectInset(rect, 0, -kVMargin);
        if (CGRectContainsPoint(rect, point)) {
            
            CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(rect),
                                                point.y-CGRectGetMinY(rect));
            CFIndex idx = CTLineGetStringIndexForPosition(line, relativePoint);
            foundLink = ([self linkAtIndex:idx]);
            if (foundLink) return foundLink;
        }
        
        if(CGRectGetMaxY(rect) < point.y)
            left = mid + 1;
        else if(CGRectGetMinY(rect) > point.y)
            right = mid - 1;
        else
            return nil;
        
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView* view = [super hitTest:point withEvent:event];
    if (view != self) {
        return view;
    }
    if ([self linkAtPoint:point] != nil) {
        return view;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuLabel:didCopy:)]){
        return view;
    }
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    _touchedLink = [self linkAtPoint:point];
    
    self.longPressTimer = [NSTimer scheduledTimerWithTimeInterval:kLongPressTimeInterval target:self selector:@selector(_longPressTimerDidFire:) userInfo:[NSValue valueWithCGPoint:point] repeats:NO];
    
    _doingLongGesture = YES;
    
    //set gray background
    if (_touchedLink == nil) {
        self.tempAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.htmlParser.attributedString];
        [self.htmlParser.attributedString setTextColor:[UIColor grayColor]];
        [self.htmlParser resetTextFrame];
    }
    [self setNeedsDisplay];
}

- (void)forwardToCaller:(NSString*)phoneNumber {
    if (phoneNumber && phoneNumber.length > 0) {
        
        NSString* deviceType = [UIDevice currentDevice].model;
        if (deviceType && ([deviceType containsString:@"iPhone"] ||
                           [deviceType containsString:@"iphone"] ||
                           [deviceType containsString:@"IPHONE"]))
        {
            
            phoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"+0123456789"] invertedSet]] componentsJoinedByString:@""];
            
            BOOL callSuccessful = NO;
            if (phoneNumber) {
                callSuccessful = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", phoneNumber]]];
            }
            
            if (!callSuccessful) {
                // Invalid phone number
            }
            
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    NSTextCheckingResult* linkTouched = [self linkAtPoint:point];
    if (linkTouched.resultType == NSTextCheckingTypeLink) {
        if (_touchedLink.URL && [_touchedLink.URL isEqual:linkTouched.URL]) {
            if([linkTouched.URL.absoluteString isEqualToString:URL_MORETEXT_LINK]){
                [self moreTextButtonPress:nil];
            }
            else if (self.delegate && [self.delegate respondsToSelector:@selector(attributedLabel:didSelectLink:atPoint:)]) {
                [self.delegate attributedLabel:self didSelectLink:linkTouched.URL atPoint:point];
            }
            else{
                NSURL *url = linkTouched.URL;
                if ([url.absoluteString hasPrefix:@"zm://"]) {
                    // Open URL
                }
                else{
                }
            }
        }
    }
    else{
        if (linkTouched.resultType == NSTextCheckingTypePhoneNumber) {
            [self forwardToCaller:linkTouched.phoneNumber];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(attributedLabel:didSelectPhone:atPoint:)]) {
                [self.delegate attributedLabel:self didSelectPhone:linkTouched.phoneNumber atPoint:point];
            }
        }
    }
    
    _touchedLink = nil;
    
    if (_touchedLink == nil) {
        if (self.tempAttributedString) {
            self.htmlParser.attributedString = self.tempAttributedString;
            self.tempAttributedString = nil;
            [self setBackgroundColor:self.backgroundColor];
            
            [self.htmlParser resetTextFrame];
        }
    }
    
    
    _doingLongGesture = NO;
    
    [self setNeedsDisplay];
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    _touchedLink = nil;
    
    if (_touchedLink == nil) {
        if (self.tempAttributedString) {
            self.htmlParser.attributedString = self.tempAttributedString;
            self.tempAttributedString = nil;
            
            [self.htmlParser resetTextFrame];
        }
    }
    
    
    _doingLongGesture = NO;
    
    if (_touchedLink == nil) {
        if (self.tempAttributedString) {
            self.htmlParser.attributedString = self.tempAttributedString;
            self.tempAttributedString = nil;
            [self.htmlParser resetTextFrame];
        }
    }
    
    [self setBackgroundColor:self.backgroundColor];
    
    [self setNeedsDisplay];
}
- (void)_longPressTimerDidFire:(NSTimer *)timer {
    self.longPressTimer = nil;
    
    if (nil != _touchedLink) {
        
        if ([_touchedLink.URL.absoluteString hasPrefix:@"zm://"] || [_touchedLink.URL.absoluteString hasPrefix:@"zapp://"]) {
            return;
        }
        
        if(!self.disableOpenActionSheetWhenHoldOnLink){
            self.actionSheetLink = _touchedLink;
            UIActionSheet* actionSheet = [self actionSheetForResult:self.actionSheetLink];
            [actionSheet showInView:self];
        }
    }
    
    if (_doingLongGesture) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(menuLabel:didCopy:)]) {
            UIMenuController* menuController = [UIMenuController sharedMenuController];
            UIMenuItem* copyItem = [[UIMenuItem alloc] initWithTitle:@"Sao chép"
                                                              action:@selector(menuItemCopy:)];
            [menuController setMenuItems:[NSArray arrayWithObjects:copyItem, nil]];
            [self becomeFirstResponder];
            CGPoint point = [[timer userInfo] CGPointValue];
            [menuController setTargetRect:CGRectMake(point.x, point.y - 30, 0.f, 0.f) inView:self];
            [menuController setMenuVisible:YES animated:YES];
        }
        
        if (_touchedLink == nil) {
            if (self.tempAttributedString) {
                if (self.tempAttributedString) {
                    self.htmlParser.attributedString = self.tempAttributedString;
                    self.tempAttributedString = nil;
                    [self setBackgroundColor:self.backgroundColor];
                    
                    [self.htmlParser resetTextFrame];
                }
                [self setNeedsDisplay];
            }
        }
    }
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)menuItemCopy:(id)menuItem {
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuLabel:didCopy:)]) {
        [self.delegate menuLabel:self didCopy:YES];
    }
}
- (UIActionSheet *)actionSheetForResult:(NSTextCheckingResult *)result {
    UIActionSheet* actionSheet =
    [[UIActionSheet alloc] initWithTitle:nil
                                delegate:self
                       cancelButtonTitle:nil
                  destructiveButtonTitle:nil
                       otherButtonTitles:nil];
    
    NSString* title = nil;
    if (NSTextCheckingTypeLink == result.resultType) {
        if ([result.URL.scheme isEqualToString:@"mailto"]) {
            title = result.URL.resourceSpecifier;
            [actionSheet addButtonWithTitle:@"Mở hộp thư"];
            [actionSheet addButtonWithTitle:@"Sao chép địa chỉ Email"];
            
        } else {
            title = result.URL.absoluteString;
            [actionSheet addButtonWithTitle:@"Mở bằng trình duyệt Safari"];
            [actionSheet addButtonWithTitle:@"Sao chép link"];
        }
        
    } else if (NSTextCheckingTypePhoneNumber == result.resultType) {
        title = result.phoneNumber;
        [actionSheet addButtonWithTitle:@"Gọi điện"];
        [actionSheet addButtonWithTitle:@"Sao chép số điện thoại"];
    }
    else {
        [actionSheet addButtonWithTitle:@"Sao chép"];
    }
    actionSheet.title = title;
    
    [actionSheet setCancelButtonIndex:[actionSheet addButtonWithTitle:@"Huỷ"]];
    
    return actionSheet;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (NSTextCheckingTypeLink == self.actionSheetLink.resultType) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:self.actionSheetLink.URL];
            
        } else if (buttonIndex == 1) {
            if ([self.actionSheetLink.URL.scheme isEqualToString:@"mailto"]) {
                [[UIPasteboard generalPasteboard] setString:self.actionSheetLink.URL.resourceSpecifier];
                
            } else {
                [[UIPasteboard generalPasteboard] setURL:self.actionSheetLink.URL];
            }
        }
        
    } else if (NSTextCheckingTypePhoneNumber == self.actionSheetLink.resultType) {
        if (buttonIndex == 0) {
            
            [self forwardToCaller:self.actionSheetLink.phoneNumber];
            
        } else if (buttonIndex == 1) {
            [[UIPasteboard generalPasteboard] setString:self.actionSheetLink.phoneNumber];
        }
        
    } else {
        // Unsupported data type only allows the user to copy.
        if (buttonIndex == 0) {
            NSString* text = [self.htmlParser.attributedString.string substringWithRange:self.actionSheetLink.range];
            [[UIPasteboard generalPasteboard] setString:text];
        }
    }
    
    self.actionSheetLink = nil;
    [self setNeedsDisplay];
}


- (void)addEmoticon:(CTRunDelegateRef)delegate run:(CTRunRef)run imgBounds:(CGRect)imgBounds line:(CTLineRef)line lineIndex:(NSUInteger)lineIndex rect:(CGRect)rect ctx:(CGContextRef)ctx {
    if (self.htmlParser.origins && self.htmlParser.origins.count > lineIndex) {
        UXImageAttachment* attachment = (__bridge UXImageAttachment *)CTRunDelegateGetRefCon(delegate);
        if(!attachment) return;
        
        CGFloat ascent;
        CGFloat descent;
        imgBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
        imgBounds.size.height = ascent + descent;
        CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
        CGPoint mOrigin = [[self.htmlParser.origins objectAtIndex:lineIndex] CGPointValue];
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


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawTextInRect:(CGRect)rect {
    
    if (CGSizeEqualToSize(CGSizeZero, self.htmlParser.fitSize)) {
        [self.htmlParser getBoundsSizeByWidth:rect.size.width];
    }
    
    if (self.htmlParser != nil && nil != self.htmlParser.attributedString) {
        
        if (!self.htmlParser.isTop) {
            
            int y = self.htmlParser.fitSize.height/2 - rect.size.height/2;
            rect.origin.y = y;
        }
        
        //[self.htmlParser detectLinks];
        //[self.htmlParser mutableAttributedStringWithLinkStylesApplied];
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        
        // CoreText context coordinates are the opposite to UIKit so we flip the bounds
        CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f));
        CGContextTranslateCTM( ctx, rect.origin.x, rect.origin.y );
        
        //Create text frame if needed
        [self.htmlParser createTextFrame:self.bounds];
        //Create lines if needed
        [self.htmlParser createLines:self.bounds];
        
        //Get number of lines and check if it is bigger than the limit? Need to 'cut' it or not?
        CFArrayRef textLines = CTFrameGetLines(self.htmlParser.textFrame);
        
        CFIndex count = CFArrayGetCount(textLines);
        
        NSInteger numberOfLines = self.htmlParser.numberOfLines;
        
        if (numberOfLines > 0) {
            if (self.htmlParser.fitSize.height <= rect.size.height) {
                numberOfLines = 0;
            }
            else {
                count = numberOfLines = MIN(count, numberOfLines);
            }
        }
        
        //if numberOfLines = 0, no need to 'cut' the label, draw all things at once
        if (numberOfLines == 0) {
            if (self.htmlParser.textFrame && ctx) {
                CTFrameDraw(self.htmlParser.textFrame, ctx);
            }
        }
        
        //draw emoticon and runs
        CGSize sizeLastRun = CGSizeZero;
        if (self.htmlParser.hasEmoticon || numberOfLines > 0) {
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
                            CGPoint mOrigin = [[self.htmlParser.origins objectAtIndex:i] CGPointValue];
                            CGFloat yLine = rect.size.height - mOrigin.y + top;
                            
                            if ((i == count - 1) && ((j == numRuns - 1) || !hadMoreText)) {
                                NSString *moreString = @"See more";
                                NSString *prefixString = @"... ";
                                if (self.htmlParser.moreText) {
                                    moreString = self.htmlParser.moreText;
                                }
                                NSString *prefixMoreString = [NSString stringWithFormat:@"%@%@", prefixString, moreString];
                                prefixMoreString = [prefixMoreString trimStringSpaces];
                                
                                NSRange range = NSMakeRange(runRange.location, runRange.length);
                                CGRect endRunRect = [self getRectFromIndex:range.location attstring:self.htmlParser.attributedString];
                                NSAttributedString *endAttrString = [self.htmlParser.attributedString attributedSubstringFromRange:range];
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
                                        
                                        CGSize sizePrefixString = [self.htmlParser getTextSize:temp.string];
                                        if (delegate) {
                                            sizePrefixString.width = EMOTICON_WIDTH;
                                        }
                                        
                                        CGSize sizePrefixMoreString = [self.htmlParser getTextSize:prefixMoreString];
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
                                    [attributedPrefix setTextColor:self.htmlParser.defaultTextColor];
                                    [result appendAttributedString:attributedPrefix];
                                }
                                
                                CGSize myStringSize = [self.htmlParser getTextSize:result.string];
                                
                                if (moreString.length > 0) {
                                    NSDictionary *mattrs = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                            (id)self.htmlParser.linkColor.CGColor, kCTForegroundColorAttributeName,
                                                            nil];
                                    NSMutableAttributedString *attributedViewMore = [[NSMutableAttributedString alloc] initWithString:moreString attributes:mattrs];
                                    [attributedViewMore setFont:self.htmlParser.fontText];
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
                                
                                CGSize moreSize = [self.htmlParser getTextSize:moreString];
                                UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                UIImage *highlightImage = [UIImage imageWithColor:[UIColor colorWithRed:51.0f/255 green:51.0f/255 blue:51.0f/255 alpha:0.5]];
                                //custom font and color for the button, which is set in the parser of this label
                                [moreButton setTitleColor:self.htmlParser.moreButtonColor forState:UIControlStateNormal];
                                
                                //==============
                                [moreButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
                                [self addSubview:moreButton];
                                [moreButton addTarget:self action:@selector(moreTextButtonPress:) forControlEvents:UIControlEventTouchUpInside];
                                
                                CGRect boundsMoreButton = CGRectMake(x + myStringSize.width - 5, (endRunRect.origin.y + endRunRect.size.height - moreSize.height) - 2, moreSize.width + 7, moreSize.height + 4);
                                [moreButton setFrame:boundsMoreButton];
                                
                                if (delegate) {
                                    [self addEmoticon:delegate run:run imgBounds:imgBounds line:line lineIndex:lineIndex rect:rect ctx:ctx];
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
                        [self addEmoticon:delegate run:run imgBounds:imgBounds line:line lineIndex:lineIndex rect:rect ctx:ctx];
                    }
                    
                    lineIndex++;
                }
            }
        }
        
        if (nil != _touchedLink) {
            //NSLog(@"Draw touched link");
            // Draw the link's background first.
            [self.linkHighlightColor setFill];
            
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
                    
                    CGPoint mOrigin = [[self.htmlParser.origins objectAtIndex:i] CGPointValue];
                    //need to turn the origin's up side down
                    mOrigin.y = self.frame.size.height - mOrigin.y;
                    
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
        
        CGContextRestoreGState(ctx);
        
    } else {
        [super drawTextInRect:rect];
    }
}

- (NSString*)subStringRemoveSpaceSuffixString:(NSString*)string {
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

- (void)moreTextButtonPress:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchedGoToFeedDetail:)]) {
        BOOL res = [self.delegate touchedGoToFeedDetail:self];
        if(res){
            [self setNeedsDisplay];
        }
    }
}

//MinhQ
#pragma mark - getRect
- (CGRect)getRectFromIndex:(NSInteger)index attstring:(NSAttributedString*)attributedString{
    
    CGRect imgBounds  = CGRectZero;
    
    [self.htmlParser createLines:self.frame];
    
    NSUInteger lineIndex = 0;
    CFArrayRef textLines = CTFrameGetLines(self.htmlParser.textFrame);
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
                CGPoint mOrigin = [[self.htmlParser.origins objectAtIndex:lineIndex] CGPointValue];
                
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
