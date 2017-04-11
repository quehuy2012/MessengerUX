//
//  UXAttributedTextNode.m
//  MessengerUX
//
//  Created by CPU11808 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXAttributedTextNode.h"
#import "UXAttributedLabel.h"
#import "UXHTMLParser.h"

@interface UXAttributedTextNode()

@property(nonatomic, weak) UXAttributedLabel *label;
@property(nonatomic) UXHTMLParser *parser;
@property(nonatomic) BOOL isParsed;

@end

@implementation UXAttributedTextNode

-(instancetype)initWithText:(NSString *)text {
    
    UXAttributedLabel *label = [[UXAttributedLabel alloc] initWithFrame:CGRectZero];
    self = [super initWithViewBlock:^UIView * _Nonnull{
        return label;
    }];
    
    if (self) {
        self.label = label;
        self.text = text;
        self.isParsed = NO;
        self.textAlignment = kCTTextAlignmentLeft;
//        self.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    
    return self;
}

-(instancetype)init {
    UXAttributedLabel *label = [[UXAttributedLabel alloc] initWithFrame:CGRectZero];
    self = [super initWithViewBlock:^UIView * _Nonnull{
        return label;
    }];
    
    if (self) {
        self.label = label;
        self.isParsed = NO;
        self.font = [UIFont systemFontOfSize:15];
        self.textColor = [UIColor blackColor];
        self.textAlignment = kCTTextAlignmentLeft;
//        self.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    
    return self;
}

#pragma mark Getters/Setters

- (void)setText:(NSString *)text {
    _text = text;
    
    self.isParsed = NO;
    [self setNeedsLayout];
}

-(void)setFont:(UIFont *)font {
    if (font) {
        _font = font;
        if (_parser) {
            [_parser setFontText:font];
        }
    }
}

-(void)setTextColor:(UIColor *)color {
    if (color) {
        _textColor = color;
        [self invalidateCalculatedLayout];
    }
}

-(void)setTextAlignment:(CTTextAlignment)alignment {
    _textAlignment = alignment;
    [self invalidateCalculatedLayout];
}

//-(void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
//    _lineBreakMode = lineBreakMode;
//    [self invalidateCalculatedLayout];
//}

-(void)setLinkHighlightColor:(UIColor *)linkHighlightColor {
    if (linkHighlightColor != _linkHighlightColor) {
        _linkHighlightColor = linkHighlightColor;
        self.label.linkHighlightColor = linkHighlightColor;
    }
}

-(void)setAttributesForParser {
    if (_parser) {
        if (_font) {
            self.parser.fontText = _font;
        }
        
        if (_textColor) {
            self.parser.defaultTextColor = _textColor;
        }
        
        self.parser.textAlignment = _textAlignment;
        
        if (_linkColor) {
            self.parser.linkColor = _linkColor;
        }
        
        if (_linkFont) {
            self.parser.linkFont = _linkFont;
        }
        
        if (_tagColor) {
            self.parser.tagColor = _tagColor;
        }
        
        if (_tagFont) {
            self.parser.tagFont = _tagFont;
        }
    }
}

-(CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    
    if (_parser == nil || !_isParsed) {
        self.parser = [[UXHTMLParser alloc] initWithString:_text parseEmoticon:YES];
        [self setAttributesForParser];
        self.isParsed = YES;
    }
    
    int maxWidth = constrainedSize.width == INFINITY ? self.style.maxWidth.value : constrainedSize.width;
    
    CGSize textSize = [_parser getBoundsSizeByWidth:maxWidth];
    
    self.label.htmlParser = _parser;
    self.label.frame = CGRectMake(0, 0, textSize.width, textSize.height);
    
    return textSize;
}

@end
