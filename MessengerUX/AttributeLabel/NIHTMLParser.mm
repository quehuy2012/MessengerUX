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
#define ALPHABET_SIZE 94
#define ALPHABET_BEGIN '!'
#define ZALO_TAG_PREFIX @"ztag://"

#import "NIHTMLParser.h"
#import "CommonDefines.h"
#import "NSString+Extend.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
static NSString * const OBJECT_REPLACEMENT_CHARACTER = @"\uFFFC";






@interface NIHTMLParser()

//For storing the image attachment list to prevent it from being deleted in ARC system
@property (nonatomic) NSMutableSet *savedImageAttachment;

/** For storing the string which is showed on the UI, the string with text cut by limit */
@property (nonatomic) NSString *uiString;

/** For storing the string after emotion parsing, this string is different from the originString,
 * used for the case when user expand the string without parsing it again */
@property (nonatomic) NSString *parsedString;

/** Check if the label is initialized with initWithStringWithLimit functions */
@property (nonatomic) BOOL hasInitWithLimit;

/** Last max width used to calculate the height for the label */
@property (nonatomic) NSInteger lastMaxWidth;
@end


@implementation NIHTMLParser

- (NSString*) moreTextLinkByText:(NSString*)moreText{
    return [NSString stringWithFormat:@" <a_zaloseemore_chatmessage href=\"%@\">%@</a_zaloseemore_chatmessage>", URL_MORETEXT_LINK, moreText];
}

//Default init function, we load the PrefixTree here, load once for each Label
-(id)init {
    self = [super init];
    if (self) {
        self.fitSize = CGSizeZero;
        self.textAlignment = kCTNaturalTextAlignment;
        [self loadPrefixTrie];
    }
    return self;
}

#pragma mark - Initialization with Limit
-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lengthLimit:(int)lengthLimit {
    return [self initWithStringWithLimit:string viewMoreText:viewMoreText lineLimit:MAXFLOAT lineLimitTo:MAXFLOAT lengthLimit:lengthLimit lengthLimitTo:lengthLimit];
}
-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lengthLimit:(int)lengthLimit parseEmoticon:(BOOL)isParse {
    return [self initWithStringWithLimit:string viewMoreText:viewMoreText lineLimit:MAXFLOAT lineLimitTo:MAXFLOAT lengthLimit:lengthLimit lengthLimitTo:lengthLimit parseEmoticon:(BOOL)isParse];
}

-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lengthLimit:(int)lengthLimit lengthLimitTo:(int)lengthLimitTo {
    return [self initWithStringWithLimit:string viewMoreText:viewMoreText lineLimit:MAXFLOAT lineLimitTo:MAXFLOAT lengthLimit:lengthLimit lengthLimitTo:lengthLimitTo];
}
-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lengthLimit:(int)lengthLimit lengthLimitTo:(int)lengthLimitTo parseEmoticon:(BOOL)isParse {
    return [self initWithStringWithLimit:string viewMoreText:viewMoreText lineLimit:MAXFLOAT lineLimitTo:MAXFLOAT lengthLimit:lengthLimit lengthLimitTo:lengthLimitTo parseEmoticon:(BOOL)isParse];
}

-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lineLimit:(int)lineLimit {
    return [self initWithStringWithLimit:string viewMoreText:viewMoreText lineLimit:lineLimit lineLimitTo:lineLimit lengthLimit:MAXFLOAT lengthLimitTo:MAXFLOAT];
}
-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lineLimit:(int)lineLimit  parseEmoticon:(BOOL)isParse {
    return [self initWithStringWithLimit:string viewMoreText:viewMoreText lineLimit:lineLimit lineLimitTo:lineLimit lengthLimit:MAXFLOAT lengthLimitTo:MAXFLOAT  parseEmoticon:(BOOL)isParse];
}

-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lineLimit:(int)lineLimit lineLimitTo:(int)lineLimitTo {
    return [self initWithStringWithLimit:string viewMoreText:viewMoreText lineLimit:lineLimit lineLimitTo:lineLimitTo lengthLimit:MAXFLOAT lengthLimitTo:MAXFLOAT];
}
-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lineLimit:(int)lineLimit lineLimitTo:(int)lineLimitTo  parseEmoticon:(BOOL)isParse {
    return [self initWithStringWithLimit:string viewMoreText:viewMoreText lineLimit:lineLimit lineLimitTo:lineLimitTo lengthLimit:MAXFLOAT lengthLimitTo:MAXFLOAT parseEmoticon:(BOOL)isParse];
}

-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lineLimit:(int)lineLimit lineLimitTo:(int)lineLimitTo lengthLimit:(int)lengthLimit lengthLimitTo:(int)lengthLimitTo {
    return [self initWithStringWithLimit:string options:nil viewMoreText:viewMoreText lineLimit:lineLimit lineLimitTo:lineLimitTo lengthLimit:lengthLimit lengthLimitTo:lengthLimitTo];
}
-(id)initWithStringWithLimit:(NSString*)string viewMoreText:(NSString*)viewMoreText lineLimit:(int)lineLimit lineLimitTo:(int)lineLimitTo lengthLimit:(int)lengthLimit lengthLimitTo:(int)lengthLimitTo parseEmoticon:(BOOL)isParse {
    return [self initWithStringWithLimit:string options:nil viewMoreText:viewMoreText lineLimit:lineLimit lineLimitTo:lineLimitTo lengthLimit:lengthLimit lengthLimitTo:lengthLimitTo parseEmoticon:(BOOL)isParse];
}

-(id)initWithStringWithLimit:(NSString*)string options:(NSArray*)options viewMoreText:(NSString*)viewMoreText lineLimit:(int)lineLimit lineLimitTo:(int)lineLimitTo lengthLimit:(int)lengthLimit lengthLimitTo:(int)lengthLimitTo {
    return [self initWithStringWithLimit:string options:options viewMoreText:viewMoreText lineLimit:lineLimit lineLimitTo:lineLimitTo lengthLimit:lengthLimit lengthLimitTo:lengthLimitTo parseEmoticon:YES];
}
-(id)initWithStringWithLimit:(NSString*)string options:(NSArray*)options viewMoreText:(NSString*)viewMoreText lineLimit:(int)lineLimit lineLimitTo:(int)lineLimitTo lengthLimit:(int)lengthLimit lengthLimitTo:(int)lengthLimitTo parseEmoticon:(BOOL)isParse {
    
    if (self = [self init]) {
        string = string.copy; //make a copy of the string
        
        NSString *input = [self createInputString:string parseEmoticon:isParse options:options];
        
        if (input && [input length] > 0) {
            [self commonInit:string];
            self.parsedString = input.copy;
            
            if (viewMoreText != nil) {
                NSString *viewMoreLink = [self moreTextLinkByText:viewMoreText];
                input = [self filterStringWithOriginString:input viewMoreLink:viewMoreLink lineLimit:lineLimit lineLimitTo:lineLimitTo lengthLimit:lengthLimit lengthLimitTo:lengthLimitTo];
            }
            
            
            self.uiString = input;
            self.hasInitWithLimit = YES;
        }
    }
    return self;
}

#pragma mark - Initialization

-(id)initWithString:(NSString*)string options:(NSArray*)options {
    return [self initWithString:string parseEmoticon:YES options:options];
}
-(id)initWithString:(NSString*)string parseEmoticon:(BOOL)isParse options:(NSArray*)options {
    if (self = [self init]) {
        string = string.copy; //make a copy of the string
        
        NSString *input = [self createInputString:string parseEmoticon:isParse options:options];
        
        if (input && [input length] > 0) {
            [self commonInit:string];
            self.parsedString = input.copy;
            
            self.uiString = input;
            self.hasInitWithLimit = NO;
        }
    }
    return self;
}

-(id)initWithString:(NSString*)string parseEmoticon:(BOOL)isParse {
    return [self initWithString:string parseEmoticon:isParse options:nil];
}
-(id)initWithString:(NSString*)string{
    return [self initWithString:string options:nil];
}
- (id)initWithString:(NSString *)string options:(NSArray*)options withNumberOfLines:(NSInteger)lines {
    if (self = [self initWithString:string options:options]) {
        self.numberOfLines = lines;
    }
    return self;
}
- (id)initWithString:(NSString *)string withNumberOfLines:(NSInteger)lines parseEmoticon:(BOOL)isParse {
    if (self = [self initWithString:string parseEmoticon:isParse options:nil]) {
        self.numberOfLines = lines;
    }
    return self;
}
- (id)initWithString:(NSString *)string withNumberOfLines:(NSInteger)lines moreText:(NSString*)moreText parseEmoticon:(BOOL)isParse {
    if (self = [self initWithString:string withNumberOfLines:lines parseEmoticon:isParse]) {
        self.moreText = moreText;
    }
    return self;
}
- (id)initWithString:(NSString *)string options:(NSArray*)options withNumberOfLines:(NSInteger)lines moreText:(NSString*)moreText {
    if (self = [self initWithString:string options:options withNumberOfLines:lines]) {
        self.moreText = moreText;
    }
    return self;
}

- (NSString*)createInputString:(NSString*)string parseEmoticon:(BOOL)isParse options:(NSArray*)options {
    NSString *contentString = nil;
    if (isParse){
        contentString = [self formatEmoticon:string];
    }
    else {
        contentString = string;
    }
    NSString *input = @"";
    if (options && [options isKindOfClass:[NSArray class]] && options.count > 0) {
        for (int i = 0; i < options.count; i ++) {
            NSDictionary *info = [options objectAtIndex:i];
            if (info && [info isKindOfClass:[NSDictionary class]]) {
                NSString *content = [info objectForKey:@"content"];
                BOOL hasFormatEmoticon = [[info objectForKey:@"hasFormatEmoticon"] boolValue];
                if (hasFormatEmoticon) {
                    content = [self formatEmoticon:content];
                }
                if (input.length == 0) {
                    input = [NSString stringWithFormat:@"%@", content];
                }
                else {
                    input = [NSString stringWithFormat:@"%@ %@", input, content];
                }
            }
        }
    }
    
    if (input.length == 0) {
        if (contentString && contentString.length > 0) {
            input = [NSString stringWithFormat:@"%@", contentString];
        }
    }
    else {
        NSInteger numberOfSpace = [self getNumberOfSpacePrefix:contentString];
        if (numberOfSpace > 0) {
            contentString = [contentString substringFromIndex:numberOfSpace];
            input = [NSString stringWithFormat:@"%@%@\n%@", [self createSpaceStringWithNumber:numberOfSpace], input, contentString];
        }
        else {
            input = [NSString stringWithFormat:@"%@\n%@", input, contentString];
        }
    }
    NSString *temp = [NSString stringWithString:input];
    if ([temp trimStringSpaces].length == 0) {
        return @"";
    }
    return input;
}

- (NSInteger)getNumberOfSpacePrefix:(NSString*)string {
    NSInteger result = 0;
    for (int i = 0; i < string.length; i ++) {
        NSString *prefix = [string substringWithRange:NSMakeRange(i, 1)];
        if ([prefix isEqualToString:@" "]) {
            result ++;
        }
        else {
            break;
        }
    }
    return result;
}
- (NSString*)createSpaceStringWithNumber:(NSInteger)number {
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < number; i ++) {
        [result appendString:@" "];
    }
    return result;
}

- (void)commonInit:(NSString*)input{
    self.defaultTextColor = [UIColor blackColor];
    self.originString = input;
    self.fontText = [UIFont systemFontOfSize:15];
    self.autoDetectLinks = YES;
    self.hasEmoticon = NO;
    
    self.parseBoldTag = YES;
    self.parseFontTag = YES;
    self.parseImageTag = YES;
    self.parseItalicTag = YES;
    self.parseLinkTag = YES;
    self.parseUnderlineTag = YES;
    self.parseLinkSeeMoreChatMessage = YES;
}

- (void)clearState {
    if(_savedImageAttachment!=nil) [_savedImageAttachment removeAllObjects];
    if(_detectedlinkLocations!=nil) [_detectedlinkLocations removeAllObjects];
    if(_origins!=nil) [_origins removeAllObjects];
    [self resetTextFrame];
    [self releasePrefixTree];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)dealloc {
    [self clearState];
}

///////MinhQ///////
- (NSString*)filterStringWithOriginString:(NSString*)string viewMoreLink:(NSString*)viewMoreLink lineLimit:(int)lineLimit lineLimitTo:(int)lineLimitTo lengthLimit:(int)lengthLimit lengthLimitTo:(int)lengthLimitTo{
    
    //check string length
    if (string.length <= lengthLimitTo && [string componentsSeparatedByString:@"\n"].count < lineLimitTo) {
        return string;
    }
    
    NSMutableString *tempString = nil;
    int maxLength = lengthLimitTo;
    int maxLine = lineLimitTo;
    
    NSInteger currentTextIndex = 0;
    //    NSInteger currentRowIndex = 0; <b>bold</b>    ~~~>   <b  bold</b
    //                                                  ~~~>   b>    bold    /b>
    NSMutableString *mulString = [[NSMutableString alloc] init];
    
    NSRegularExpression* regex = [[NSRegularExpression alloc]
                                  initWithPattern:@"(.*?)(<[^>]+>|\\Z)"
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil] ;
    NSArray* chunks = [regex matchesInString:string options:0
                                       range:NSMakeRange(0, string.length)];
    
    for (NSTextCheckingResult* b in chunks) {
        
        NSArray* parts = [[string substringWithRange:b.range]
                          componentsSeparatedByString:@"<"]; //1
        if (parts.count > 0) {
            NSString *object = [parts objectAtIndex:0];
            
            if (![object isEqualToString:@""]) {
                
                NSArray *lines = [object componentsSeparatedByString:@"\n"];
                NSUInteger nLines = lines.count;
                
                for (int l=0; l<nLines; l++) {
                    NSString *text = [lines objectAtIndex:l];
                    
                    if ((currentTextIndex + text.length) > maxLength) {
                        
                        NSArray *components = [text componentsSeparatedByString:@" "];
                        
                        for (int i=0; i<components.count; i++) {
                            
                            NSString *component = [components objectAtIndex:i];
                            
                            if ((currentTextIndex + component.length + (i==0?0:1)) > maxLength) {
                                
                                if (mulString.length == 0) {
                                    if (string.length <= lengthLimit) {
                                        [mulString appendString:string];
                                    }
                                    else {
                                        [mulString appendString:[string substringToIndex:lengthLimitTo]];
                                        [mulString appendFormat:@"%@", viewMoreLink];
                                    }
                                    return mulString;
                                }
                                
                                if (maxLength == lengthLimitTo) {
                                    tempString = [NSMutableString stringWithString:mulString];
                                    maxLength = lengthLimit;
                                    
                                    if (lengthLimit == lengthLimitTo) {
                                        [tempString appendFormat:@"%@", viewMoreLink];
                                        return tempString;
                                    }
                                }
                                else{
                                    [tempString appendFormat:@"%@", viewMoreLink];
                                    return tempString;
                                }
                                
                            }
                            
                            if (i > 0) {
                                [mulString appendString:@" "];
                                currentTextIndex += 1;
                            }
                            
                            [mulString appendString:component];
                            currentTextIndex += component.length;
                            
                        }
                    }
                    else{
                        currentTextIndex += text.length;
                        [mulString appendString:text];
                    }
                    
                    if ([mulString componentsSeparatedByString:@"\n"].count > maxLine) {
                        
                        if (maxLine == lineLimitTo) {
                            tempString = [NSMutableString stringWithString:mulString];
                            maxLine = lineLimit;
                            
                            if (lineLimit == lineLimitTo) {
                                
                                tempString = [self stringBySubLastString:tempString];
                                [tempString appendFormat:@"%@", viewMoreLink];
                                return tempString;
                            }
                        }
                        else{
                            tempString = [self stringBySubLastString:tempString];
                            [tempString appendFormat:@"%@", viewMoreLink];
                            return tempString;
                        }
                    }
                    
                    if (nLines > 1 && l < nLines-1) {
                        [mulString appendString:@"\n"];
                    }
                }
                
                
            }
            
            int plus = 0;
            for (int i=1; i<parts.count; i++) {
                NSString* tag = (NSString*)[parts objectAtIndex:i];
                if ([tag hasPrefix:@"img src="]){
                    plus=1; //1 emoticon = 1 character
                }
            }
            if(currentTextIndex + plus > maxLength){
                if (maxLength == lengthLimitTo) {
                    tempString = [NSMutableString stringWithString:mulString];
                    maxLength = lengthLimit;
                    
                    if (lengthLimit == lengthLimitTo) {
                        [tempString appendFormat:@"%@", viewMoreLink];
                        return tempString;
                    }
                }
                else{
                    [tempString appendFormat:@"%@", viewMoreLink];
                    return tempString;
                }
            }else{
                currentTextIndex+=plus;
            }
            for (int i=1; i<parts.count; i++) {
                NSString* tag = (NSString*)[parts objectAtIndex:i];
                [mulString appendString:@"<"];
                [mulString appendString:tag];
            }
        }
    }
    
    return mulString;
}
- (NSMutableString*)stringBySubLastString:(NSString*)string{
    NSMutableString *result = [NSMutableString string];
    NSArray *components = [string componentsSeparatedByString:@"\n"];
    for (int i = 0; i < components.count - 1; i ++) {
        [result appendString:[components objectAtIndex:i]];
        [result appendString:@"\n"];
    }
    return result;
}

#pragma mark - Getter/Setter

-(NSMutableAttributedString*)attributedString{
    if (!_attributedString) {
        _attributedString = [self parseString:self.uiString];
        [self detectLinks];
        [self mutableAttributedStringWithLinkStylesApplied];
        
        //set alignment
        [_attributedString setTextAlignment:self.textAlignment lineBreakMode:kCTLineBreakByWordWrapping];
    }
    return _attributedString;
}

- (void)setAttributedString:(NSMutableAttributedString *)attributedString {
    
    [self resetTextFrame];
    _linksHaveBeenDetected = NO;
    _highlighHaveBeenApplied = NO;
    _attributedString = attributedString;
}

//MinhQ
- (NSMutableArray *)aLinks{
    if (_aLinks == nil) {
        _aLinks = [[NSMutableArray alloc] init];
    }
    return _aLinks;
}
-(void)setALinks:(NSMutableArray *)aLinks{
    _aLinks = aLinks;
}


#pragma mark - Emoticons Parser Implementation

/* Prefix Tree management, just 1 prefix tree is shared for all htmlParser,
 a counting variable will be used to decide when the prefix tree is no longer
 used and can be destroy */
struct node{
    NSString* data;
    struct node *link[ALPHABET_SIZE];
} *label_root;

node* create_node() {
    node *q = new node;
    for(int x=0;x<ALPHABET_SIZE;x++)
        q->link[x] = NULL;
    q->data = nil;
    return q;
}

void dfsRemovePrefixTrie(node *node){
    if(node == nil) return;
    for(int i=0; i<ALPHABET_SIZE; ++i) dfsRemovePrefixTrie(node->link[i]);
    delete node;
}

int prefixTreeCounter = 0;
dispatch_semaphore_t prefixTreeMutex = dispatch_semaphore_create(1);

+(int)getPrefixTreeCounter{
    return prefixTreeCounter;
}

/* ************************ */

- (void) releasePrefixTree{
    
    dispatch_semaphore_wait(prefixTreeMutex, DISPATCH_TIME_FOREVER);
    --prefixTreeCounter;
    NSLog(@"Prefix tree release: %d",prefixTreeCounter);
    if(prefixTreeCounter==0){
        if(label_root != NULL){
            NSLog(@"Prefix tree dealloc");
            dfsRemovePrefixTrie(label_root);
            label_root = NULL;
        }
    }
    dispatch_semaphore_signal(prefixTreeMutex);
}

void insert_node(NSString *key, NSString *value) {
    NSUInteger length = key.length;
    int index;
    int level = 0;
    if(label_root == NULL)
        label_root = create_node();
    struct node *q = label_root;  // For insertion of each String key, we will start from the root
    
    for(;level < length;level++) {
        index = [key characterAtIndex:level] - ALPHABET_BEGIN;
        
        if (index < ALPHABET_SIZE) {
            if(q->link[index] == NULL) {
                q->link[index] = create_node();  // which is : struct node *p = create_node(); q->link[index] = p;
            }
            
            q = q->link[index];
        }
    }
    q->data = value;
}

- (void)loadPrefixTrie {
    dispatch_semaphore_wait(prefixTreeMutex, DISPATCH_TIME_FOREVER);
    ++prefixTreeCounter;
    // NSLog(@"Attempt to load tree load: %d",prefixTreeCounter);
    if (label_root == NULL) {
        //NSLog(@"Prefix tree load");
        NSDictionary *map = [self getDictionaryMapEmo];
        for (NSString *key in map)
            insert_node(key,[map objectForKey:key]);
        
    }
    dispatch_semaphore_signal(prefixTreeMutex);
    
}


/**
 *Parse emoticons in string and output string with tag <img> for emoticons.
 *
 *If ignoreEmoticonInLinks==YES then the emoticons in links detected will not be parsed. This may take a bigger cost in time processing.
 */
- (NSString*)formatEmo:(NSString*)string ignoreEmoticonInLinks:(BOOL)ignoreEmoticonInLinks{
    //Pre-parse the link to detect links positions in string
    NSArray *linkLocations = nil;
    if(ignoreEmoticonInLinks){
        linkLocations = [self detectLinksAndPhoneNumbersInString:string];
    }
    
    struct node *p;
    NSMutableString *result = [[NSMutableString alloc] init];
    int lastIndex = 0;
    
    NSTextCheckingResult *link = nil;
    int currentLinkIndex = 0;
    if(linkLocations != nil) //need to ignore emoticon in links
    {
        if(0 < linkLocations.count)
            link = [linkLocations objectAtIndex:0];
        else
            link = nil;
    }
    for(int i=0; i < string.length; ++i){
        
        if(linkLocations != nil) //need to ignore emoticon in links
        {
            while(link!=nil && link.range.location+link.range.length-1 < i){
                ++currentLinkIndex;
                if(currentLinkIndex < linkLocations.count)
                    link = [linkLocations objectAtIndex:currentLinkIndex];
                else
                    link = nil;
            }
        }
        
        p = label_root;
        int j = i;
        int length = (int)string.length;
        while(j < length){
            int index = [string characterAtIndex:j] - ALPHABET_BEGIN;
            if(index<0 || index >= ALPHABET_SIZE || p->link[index] == NULL) break;
            p = p->link[index];
            ++j;
        }
        
        //if the emoticon can be matched
        if(p->data){
            //if the detected emoticon intersect with a link at the end => don't parse it
            if(link!=nil && (link.range.location <= i) && (i < link.range.location + link.range.length)) continue;
            
            NSString *value = p->data;
            if(lastIndex < i) [result appendString:[string substringWithRange:NSMakeRange(lastIndex, i-lastIndex)]];
            [result appendString:value];
            lastIndex = j;
            i = j - 1; //skip unnecessary characters
        }
    }
    if(lastIndex < string.length) [result appendString:[string substringWithRange:NSMakeRange(lastIndex, string.length - lastIndex)]];
    return result;
}

- (NSString*)formatEmoticon:(NSString*)string{
    //NSLog(@"  Start parsing phase... string length = %d", (int)string.length);
    //CFTimeInterval startTime = CACurrentMediaTime();
    
    
    NSString *result = [self formatEmo:string ignoreEmoticonInLinks:YES];
    
    //CFTimeInterval elapsedTime = CACurrentMediaTime() - startTime;
    //NSLog(@"  Parsing time: %0.4f ms", elapsedTime*1000);
    
    return result;
}

static NSDictionary *staticEmoticonCharacters;
- (NSDictionary*)getDictionaryMapEmo{
    
    if (!staticEmoticonCharacters) {
        
        NSDictionary *temoticonCharacters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             @"<img src=\"1.png\"/>" , @":)",
                                             @"<img src=\"2.png\"/>" , @":~",
                                             @"<img src=\"3.png\"/>" , @":B",
                                             @"<img src=\"3.png\"/>" , @":b",
                                             @"<img src=\"4.png\"/>" , @":|",
                                             @"<img src=\"5.png\"/>" , @"8-)",
                                             @"<img src=\"6.png\"/>" , @":-((",
                                             @"<img src=\"7.png\"/>" , @":$",
                                             @"<img src=\"8.png\"/>" , @":X",
                                             @"<img src=\"8.png\"/>" , @":x",
                                             @"<img src=\"9.png\"/>" , @":Z",
                                             @"<img src=\"9.png\"/>" , @":z",
                                             @"<img src=\"10.png\"/>" , @":((",
                                             @"<img src=\"11.png\"/>" , @":-|",
                                             @"<img src=\"12.png\"/>" , @":-H",
                                             @"<img src=\"12.png\"/>" , @":-h",
                                             @"<img src=\"13.png\"/>" , @":P",
                                             @"<img src=\"13.png\"/>" , @":p",
                                             @"<img src=\"14.png\"/>" , @":D",
                                             @"<img src=\"14.png\"/>" , @":d",
                                             @"<img src=\"15.png\"/>" , @":O",
                                             @"<img src=\"15.png\"/>" , @":o",
                                             @"<img src=\"16.png\"/>" , @":(",
                                             @"<img src=\"17.png\"/>" , @":+",
                                             @"<img src=\"18.png\"/>" , @"--B",
                                             @"<img src=\"18.png\"/>" , @"--b",
                                             @"<img src=\"19.png\"/>" , @":Q",
                                             @"<img src=\"19.png\"/>" , @":q",
                                             @"<img src=\"20.png\"/>" , @":T",
                                             @"<img src=\"20.png\"/>" , @":t",
                                             @"<img src=\"21.png\"/>" , @";P",
                                             @"<img src=\"21.png\"/>" , @";p",
                                             @"<img src=\"22.png\"/>" , @";-D",
                                             @"<img src=\"22.png\"/>" , @";-d",
                                             @"<img src=\"23.png\"/>" , @";D",
                                             @"<img src=\"23.png\"/>" , @";d",
                                             @"<img src=\"24.png\"/>" , @";O",
                                             @"<img src=\"24.png\"/>" , @";o",
                                             @"<img src=\"25.png\"/>" , @";G",
                                             @"<img src=\"25.png\"/>" , @";g",
                                             @"<img src=\"26.png\"/>" , @"|-)",
                                             @"<img src=\"27.png\"/>" , @":!",
                                             @"<img src=\"28.png\"/>" , @":L",
                                             @"<img src=\"28.png\"/>" , @":l",
                                             @"<img src=\"29.png\"/>" , @":>",
                                             @"<img src=\"30.png\"/>" , @":;",
                                             @"<img src=\"31.png\"/>" , @";F",
                                             @"<img src=\"31.png\"/>" , @";f",
                                             @"<img src=\"32.png\"/>" , @";-S",
                                             @"<img src=\"32.png\"/>" , @";-s",
                                             @"<img src=\"33.png\"/>" , @";?",
                                             @"<img src=\"34.png\"/>" , @";-X",
                                             @"<img src=\"34.png\"/>" , @";-x",
                                             @"<img src=\"35.png\"/>" , @":-F",
                                             @"<img src=\"35.png\"/>" , @":-f",
                                             @"<img src=\"36.png\"/>" , @";8",
                                             @"<img src=\"37.png\"/>" , @";!",
                                             @"<img src=\"38.png\"/>" , @";-!",
                                             @"<img src=\"39.png\"/>" , @";XX",
                                             @"<img src=\"39.png\"/>" , @";xx",
                                             @"<img src=\"40.png\"/>" , @":-BYE",
                                             @"<img src=\"40.png\"/>" , @":-bye",
                                             @"<img src=\"41.png\"/>" , @":WIPE",
                                             @"<img src=\"41.png\"/>" , @":wipe",
                                             @"<img src=\"42.png\"/>" , @":-DIG",
                                             @"<img src=\"42.png\"/>" , @":-dig",
                                             @"<img src=\"43.png\"/>" , @":handclap",
                                             @"<img src=\"44.png\"/>" , @"&-(",
                                             @"<img src=\"45.png\"/>" , @"B-)",
                                             @"<img src=\"45.png\"/>" , @"b-)",
                                             @"<img src=\"46.png\"/>" , @":-L",
                                             @"<img src=\"46.png\"/>" , @":-l",
                                             @"<img src=\"47.png\"/>" , @":-R",
                                             @"<img src=\"47.png\"/>" , @":-r",
                                             @"<img src=\"48.png\"/>" , @":-O",
                                             @"<img src=\"48.png\"/>" , @":-o",
                                             @"<img src=\"49.png\"/>" , @">-|",
                                             @"<img src=\"50.png\"/>" , @"P-(",
                                             @"<img src=\"50.png\"/>" , @"p-(",
                                             @"<img src=\"51.png\"/>" , @":--|",
                                             @"<img src=\"52.png\"/>" , @"X-)",
                                             @"<img src=\"52.png\"/>" , @"x-)",
                                             @"<img src=\"53.png\"/>" , @":*",
                                             @"<img src=\"54.png\"/>" , @";-A",
                                             @"<img src=\"54.png\"/>" , @";-a",
                                             @"<img src=\"55.png\"/>" , @"8*",
                                             @"<img src=\"56.png\"/>" , @"/-showlove",
                                             @"<img src=\"57.png\"/>" , @"/-rose",
                                             @"<img src=\"58.png\"/>" , @"/-fade",
                                             @"<img src=\"59.png\"/>" , @"/-heart",
                                             @"<img src=\"60.png\"/>" , @"/-break",
                                             @"<img src=\"61.png\"/>" , @"/-coffee",
                                             @"<img src=\"62.png\"/>" , @"/-cake",
                                             @"<img src=\"63.png\"/>" , @"/-li",
                                             @"<img src=\"64.png\"/>" , @"/-bome",
                                             @"<img src=\"65.png\"/>" , @"/-bd",
                                             @"<img src=\"66.png\"/>" , @"/-shit",
                                             @"<img src=\"67.png\"/>" , @"/-strong",
                                             @"<img src=\"68.png\"/>" , @"/-weak",
                                             @"<img src=\"69.png\"/>" , @"/-share",
                                             @"<img src=\"70.png\"/>" , @"/-v",
                                             @"<img src=\"71.png\"/>" , @"/-thanks",
                                             @"<img src=\"72.png\"/>" , @"/-jj",
                                             @"<img src=\"73.png\"/>" , @"/-punch",
                                             @"<img src=\"74.png\"/>" , @"/-bad",
                                             @"<img src=\"75.png\"/>" , @"/-loveu",
                                             @"<img src=\"76.png\"/>" , @"/-no",
                                             @"<img src=\"77.png\"/>" , @"/-ok",
                                             @"<img src=\"78.png\"/>" , @"/-flag",
                                             nil] ;
        staticEmoticonCharacters = temoticonCharacters;
    }
    
    return staticEmoticonCharacters;
}

#pragma mark - String boundings and size

- (CGSize)getBoundsSizeByWidth:(NSInteger)maxWidth{
    if (!self.attributedString || self.attributedString.length == 0 || maxWidth == 0) {
        self.fitSize = CGSizeZero;
        return CGSizeZero;
    }
    
    if((self.fitSize.height > 0 || self.fitSize.width > 0) && maxWidth == _lastMaxWidth) return self.fitSize;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedString);
    if (framesetter == nil) {
        return CGSizeZero;
    }
    CGSize targetSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [self.attributedString length]), NULL, targetSize, NULL);
    CFRelease(framesetter);
    
    self.fitSize = CGSizeMake(fitSize.width, ceilf(fitSize.height));//fitSize;
    self.lastMaxWidth = maxWidth;
    return self.fitSize;
}

- (CGSize)getTextSize:(NSString*)text {
    CGSize labelSize = CGSizeZero;
    
    if (SYSTEM_VERSION_GREATER_THAN(@"7")) {
        labelSize = [text sizeWithAttributes:@{NSFontAttributeName: self.fontText}];
    }
    else {
        labelSize = [text sizeWithFont:self.fontText
                     constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, CGFLOAT_MAX)
                         lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return labelSize;
}

- (CGFloat)getHeightInStoreDictionary:(NSInteger)lines {
    if (!_storeHeightWithLines) {
        self.storeHeightWithLines = [NSMutableDictionary dictionary];
    }
    NSNumber *height = [self.storeHeightWithLines objectForKey:[NSString stringWithFormatNumber:lines]];
    if (height) {
        return [height floatValue];
    }
    return -1;
}
- (void)storeHeightInStoreDictionary:(NSInteger)lines height:(CGFloat)height {
    if (!_storeHeightWithLines) {
        self.storeHeightWithLines = [NSMutableDictionary dictionary];
    }
    [self.storeHeightWithLines setObject:[NSNumber numberWithFloat:height] forKey:[NSString stringWithFormatNumber:lines]];
}

- (CGFloat)getHeightWithNumberOfLines:(NSInteger)lines maxW:(CGFloat)maxW {
    if (lines <= 0) {
        return 0;
    }
    
    if(self.lastMaxWidth != maxW){
        self.storeHeightWithLines = nil;
    }
    self.lastMaxWidth = maxW;
    
    CGFloat height = [self getHeightInStoreDictionary:lines];
    if (height >= 0) {
        return height;
    }
    
    if (self.attributedString) {
        CTLineRef line = nil;
        NSInteger count = 0;
        
        NSAttributedString *attributedString = self.attributedString;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, maxW, 1000));
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
        CTFrameRef ctfFrameRef = nil;
        if (framesetter) {
            ctfFrameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
            CFRelease(framesetter);
        }
        CFRelease(path);
        
        if (ctfFrameRef) {
            CFArrayRef arrayRef = CTFrameGetLines(ctfFrameRef);
            if (arrayRef) {
                NSArray *arraylines = (__bridge NSArray *)arrayRef ;
                if (arraylines) {
                    CGPoint mOrigins[arraylines.count];
                    CTFrameGetLineOrigins(ctfFrameRef, CFRangeMake(0, 0), mOrigins);
                    CFRelease(ctfFrameRef);
                    
                    count = arraylines.count;
                    if (count > 0) {
                        NSInteger lineIndex = MIN(lines-1, count-1);
                        if (lineIndex >= 0 && lineIndex < count) {
                            line = (__bridge CTLineRef)[arraylines objectAtIndex:lineIndex];
                        }
                        
                        
                        if (line) {
                            CGFloat ascent, descent, leading;
                            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
                            height = 1000 - mOrigins[MIN(lines-1, count-1)].y + descent;//ascent + descent - 14;
                            height += 1;//in some case this height is not enough
                            [self storeHeightInStoreDictionary:lines height:height];
                            //                self.fitSize = CGSizeMake(maxW, height);
                            return height;
                        }
                    }
                }
            } else {
                CFRelease(ctfFrameRef);
            }
        }
    }
    else {
        [self storeHeightInStoreDictionary:lines height:0];
    }
    
    return 0;
}

#pragma mark - Link implementation


/*
 * This function is to check if a character is valid for appearing in a link, due to the RFC 3986
 * https://en.wikipedia.org/wiki/Percent-encoding#Types_of_URI_characters
 */
static BOOL markValidCharacter[128];
static BOOL validCharacterInit = NO;

- (void) initValidCharacter{
    if(!validCharacterInit){
        NSString *validString = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~:/?#[]@!$&'()*+,;=";
        for(int i=0; i<128; ++i) markValidCharacter[i] = NO;
        for(int i=0; i<validString.length; ++i){
            unichar ch = [validString characterAtIndex:i];
            if(0<=ch && ch<128) markValidCharacter[ch] = YES;
        }
        validCharacterInit = YES;
    }
}

- (BOOL) isValidCharacter:(unichar)ch{
    return (0<=ch && ch<128 && markValidCharacter[ch]);
}

/*
 * This function is to check if the character is ignored if it is the last character of the link.
 * The rule is referenced from WeChat's link detection rule. Those characters are ignored in the end of each link in WeChat
 * For example: The 2 last characters: ')' and '.' must be ignored to have a correct link (http://baomoi.com/abc).
 */

static BOOL markIgnoredCharater[128];
static BOOL ignoredCharacterInit = NO;

- (void) initIgnoredCharacter{
    if(!ignoredCharacterInit){
        NSString *ignoredString = @".?[]!'(),;";
        for(int i=0; i<128; ++i) markIgnoredCharater[i] = NO;
        for(int i=0; i<ignoredString.length; ++i){
            unichar ch = [ignoredString characterAtIndex:i];
            if(0<=ch && ch<128) markIgnoredCharater[ch] = YES;
        }
        ignoredCharacterInit = YES;
    }
}

- (BOOL) isIgnoredCharacter:(unichar)ch{
    return (0<=ch && ch<128 && markIgnoredCharater[ch]);
}

/**
 * This function extends the links detected by NSDataDetector as long as possible in an reasonable way :)
 * The purpose is to help link detection smarter with link containing special characters as : ) ( ...
 * Complexity O(length)
 */
- (NSArray *)extendLinkMatches:(NSArray*)locations inString:(NSString*)string{
    //Init for checking those characters in O(1)
    [self initIgnoredCharacter];
    [self initValidCharacter];
    
    
    NSMutableArray *newLocations = [[NSMutableArray alloc] initWithCapacity:locations.count];
    for(int i=0; i<locations.count; ++i){
        int lastIndex = (int)string.length;
        NSTextCheckingResult * result = [locations objectAtIndex:i];
        if(i+1 < locations.count){
            NSTextCheckingResult *tmp = [locations objectAtIndex:i+1];
            lastIndex = (int)tmp.range.location;
        }
        
        NSRange range = result.range;
        //Just extend for links result
        if(result.resultType == NSTextCheckingTypeLink){
            int firstIndex = (int)(range.length + range.location - 1);
            int lastKnownGoodPosition = firstIndex;
            for(int j = firstIndex+1; j < lastIndex; ++j){
                unichar ch = [string characterAtIndex:j];
                if([self isValidCharacter:ch]) lastKnownGoodPosition = j;
                else break;
            }
            //truncated the link if needed
            while(lastKnownGoodPosition >= range.location){
                unichar ch = [string characterAtIndex:lastKnownGoodPosition];
                if([self isIgnoredCharacter:ch]) --lastKnownGoodPosition;
                else break;
            }
            
            //This case shouldn't be happened
            if(lastKnownGoodPosition < range.location) continue;
            
            range.length = lastKnownGoodPosition - range.location + 1;
            //need to append the new string to the url if it is extended
        
            if(range.length != result.range.length){
                NSString *strNew = [string substringWithRange:range];
                //add prefix http:// if the url doesn't start with http:// , https:// , ftp:// or ftps://
                NSString *strNewLowerCase = [strNew lowercaseString];
                if(![strNewLowerCase hasPrefix:@"http://"]
                   && ![strNewLowerCase hasPrefix:@"https://"]
                   && ![strNewLowerCase hasPrefix:@"ftp://"]
                   && ![strNewLowerCase hasPrefix:@"ftps://"]
                   && ![strNewLowerCase hasPrefix:ZALO_TAG_PREFIX]){
                    strNew = [NSString stringWithFormat:@"http://%@", strNew];
                }
                strNew = [strNew stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSURL *newURL = [NSURL URLWithString:strNew];
                [newLocations addObject:[NSTextCheckingResult linkCheckingResultWithRange:range URL:newURL]];
            }else{
                [newLocations addObject:result];
            }
            
        }else{
            [newLocations addObject:result];
        }
        
        
    }
    return newLocations;
}

/**
 *This function using the NSDataDetector to detect links and phone numbers.
 *
 *Return type is an array of NSTextCheckingResult
 */
- (NSArray *)detectLinksAndPhoneNumbersInString:(NSString*) string{
    
    NSError* error = nil;
    NSArray *linkLocations = nil;
    
    if (string && string.length > 0) {
        
        NSDataDetector* linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber
                                                                       error:&error];
        if (error) {
            return nil;
        }
        
        NSRange range = NSMakeRange(0, string.length);
        linkLocations = [linkDetector matchesInString:string options:0 range:range];
        
        // Extend the links' length if needed
        linkLocations = [self extendLinkMatches:linkLocations inString:string];
    }
    
    
    return linkLocations;
}

//Function from label
- (void)detectLinks {
    if (self.autoDetectLinks && !_linksHaveBeenDetected) {
        if (!_attributedString) {
            return;
        }
        
        NSArray *linkLocations = [self detectLinksAndPhoneNumbersInString:_attributedString.string];
        
        _detectedlinkLocations = [[NSMutableArray alloc] initWithArray:linkLocations];
        _linksHaveBeenDetected = YES;
        
        //append links
        NSUInteger count = [self.aLinks count];
        for (int i=0; i<count; i++) {
            NSDictionary *dictInfo = [self.aLinks objectAtIndex:i];
            if (dictInfo && [dictInfo isKindOfClass:[NSDictionary class]]) {
                if ([dictInfo objectForKey:@"textRange"]) {
                    NSRange urlRange = [[dictInfo objectForKey:@"textRange"] rangeValue];
                    if (self.prefix) {
                        urlRange.location += self.prefix.length;
                    }
                    NSString *urlLink = [[dictInfo objectForKey:@"urlLink"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    if (urlLink) {
                        NSTextCheckingResult *checkingResult = [NSTextCheckingResult linkCheckingResultWithRange:urlRange URL:[NSURL URLWithString:urlLink]];
                        if (checkingResult && [checkingResult isKindOfClass:[NSTextCheckingResult class]]) {
                            [_detectedlinkLocations addObject:checkingResult];
                        }
                    }
                }
            }
        }
        
        //the "detectedlinkLocations" must be sorted for binary search later
        [_detectedlinkLocations sortUsingComparator:^NSComparisonResult(NSTextCheckingResult *a, NSTextCheckingResult *b) {
            if(a.range.location < b.range.location) return NSOrderedAscending;
            if(a.range.location == b.range.location) return NSOrderedSame;
            return NSOrderedDescending;
        }];
    }
}

#pragma mark - Color and Font for links, tags, 'view more' button

- (UIColor *)linkColor {
    if (_linkColor == nil) {
        _linkColor = [UIColor blueColor] ;
    }
    return _linkColor;
}


- (void)setLinkColor:(UIColor *)linkColor {
    if (_linkColor != linkColor) {
        _linkColor = linkColor;
    }
}

- (UIColor *)tagColor{
    if(_tagColor == nil){
        _tagColor = [UIColor blackColor];
    }
    return _tagColor;
}

- (UIFont*)tagFont{
    if(_tagFont == nil){
        _tagFont = [UIFont boldSystemFontOfSize:16];
    }
    return _tagFont;
}

- (UIColor *)moreButtonColor{
    if(_moreButtonColor == nil){
        _moreButtonColor = [UIColor blueColor];
    }
    return _moreButtonColor;
}


- (void)mutableAttributedStringWithLinkStylesApplied {
    if (self.autoDetectLinks && !_highlighHaveBeenApplied) {
        for (NSTextCheckingResult* result in _detectedlinkLocations) {
            if(result.resultType == NSTextCheckingTypeLink){
                if([result.URL.absoluteString hasPrefix:ZALO_TAG_PREFIX]){
                    [self.attributedString setTextColor:self.tagColor range:result.range];
                    [self.attributedString setFont:self.tagFont range:result.range];
                }else if([result.URL.absoluteString hasPrefix:@"zapp://"]){ //'View More' button
                    [self.attributedString setTextColor:self.moreButtonColor range:result.range];
                    if (self.moreButtonFont) {
                        [self.attributedString setFont:self.moreButtonFont range:result.range];
                    }
                }else{
                    [self.attributedString setTextColor:self.linkColor range:result.range];
                    if (self.linkFont) {
                        [self.attributedString setFont:self.linkFont range:result.range];
                    }
                }
            }
        }
        _highlighHaveBeenApplied = YES;
    }
}


#pragma mark - Parse Markup parser
- (void)parseFontColor:(NSString *)tag detected_p:(BOOL *)detected_p color:(UIColor**)color
{
    //font color
    NSRegularExpression* colorRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=color=\")[^\"]+" options:0 error:NULL] ;
    [colorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
        
        *detected_p = YES;
        
        NSRange range = match.range;
        NSString *textColor = [tag substringWithRange:range];
        
        if ([textColor isEqualToString:@"red"] || [textColor isEqualToString:@"green"] || [textColor isEqualToString:@"blue"] || [textColor isEqualToString:@"white"] || [textColor isEqualToString:@"black"] || [textColor isEqualToString:@"yellow"] || [textColor isEqualToString:@"gray"] || [textColor isEqualToString:@"brown"]) {
            // basic color
            SEL colorSel = NSSelectorFromString([NSString stringWithFormat: @"%@Color", textColor]);
            *color = [UIColor performSelector:colorSel];
        }
        else{// hex color
            *color = [self colorFromHexString:textColor alpha:1];
        }
    }];
}

- (void)parseFontSize:(BOOL *)detected_p tag:(NSString *)tag fontSize:(CGFloat*)fontSize
{
    //font size
    NSRegularExpression* sizeRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=size=\")[^\"]+" options:0 error:NULL];
    [sizeRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
        NSRange range = match.range;
        NSString *textSize = [tag substringWithRange:range];
        *detected_p = YES;
        *fontSize = [textSize floatValue];
    }];
}

- (void)parseImageSource:(BOOL *)detected_p tag:(NSString *)tag aString:(NSMutableAttributedString *)aString
{
    NIImageAttachment *attachment = [[NIImageAttachment alloc] init];
    attachment.width = EMOTICON_WIDTH;
    attachment.height = EMOTICON_HEIGHT;
    attachment.descent = EMOTICON_DESCENT;
    
    CTRunDelegateCallbacks callbacks = attachment.callbacks;
    
    //image file
    __block NSString* fileName = @"";
    NSRegularExpression* srcRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=src=\")[^\"]+" options:0 error:NULL];
    [srcRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
        fileName = [tag substringWithRange: match.range];
        
        *detected_p = YES;
    }];
    
    attachment.imageURL = fileName;
    
    [self.savedImageAttachment addObject:attachment];
    
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)attachment);
    NSDictionary *attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
                                            (__bridge id)delegate, (NSString*)kCTRunDelegateAttributeName,
                                            nil];
    CFRelease(delegate);
    
    //add a space to the text so that it can call the delegate
    [aString appendAttributedString:[[NSAttributedString alloc] initWithString:OBJECT_REPLACEMENT_CHARACTER attributes:attrDictionaryDelegate]];
}

- (void)parseLinkHref:(NSString *)stringPattern range_p:(NSRange *)range_p detected_p:(BOOL *)detected_p tag:(NSString *)tag
{
    NSRegularExpression* colorRegex = [[NSRegularExpression alloc] initWithPattern:stringPattern options:0 error:NULL];
    [colorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
        *detected_p = YES;
        *range_p = match.range;
    }];
}

- (void)pushTag:(NSString*)tag withStack:(NSMutableDictionary*)stack {
    NSNumber *number = [stack objectForKey:tag];
    if (!number) {
        number = [NSNumber numberWithInt:1];
    }
    else {
        NSInteger count = [number integerValue];
        number = [NSNumber numberWithInteger:(count + 1)];
    }
    [stack setObject:number forKey:tag];
}
- (NSInteger)popTag:(NSString*)tag withStack:(NSMutableDictionary*)stack {
    NSNumber *number = [stack objectForKey:tag];
    if (!number) {
        return 0;
    }
    else {
        NSInteger count = [number integerValue];
        number = [NSNumber numberWithInteger:MAX(0, (count - 1))];
        [stack setObject:number forKey:tag];
        return count;
    }
}

- (NSMutableAttributedString*)parseString:(NSString*)string
{
    //Re-init
    self.hasEmoticon = NO;
    
    //======
    if (string == nil) {
        return nil;
    }
    
    //Renew the storage array for images
    self.savedImageAttachment = [[NSMutableSet alloc] init];
    
    NSMutableDictionary *stackTagsRemember = [NSMutableDictionary dictionary];
    
    //define tags
    NSString *HTMLTypeFont = @"font";
    NSString *HTMLTypeFontColor = @"font color";
    NSString *HTMLTypeFontSize = @"font size";
    NSString *HTMLTypeImage = @"img";
    NSString *HTMLTypeLink = @"a";
    NSString *HTMLTypeBold = @"b";
    NSString *HTMLTypeUnderline = @"u";
    NSString *HTMLTypeItalic = @"i";
    NSString *HTMLTypeLinkSeeMoreChatMessage = @"a_zaloseemore_chatmessage";
    
    NSMutableArray *HTMLList = [NSMutableArray array];
    if (self.parseBoldTag) {
        [HTMLList addObject:HTMLTypeBold];
    }
    if (self.parseFontTag) {
        [HTMLList addObject:HTMLTypeFont];
    }
    if (self.parseImageTag) {
        [HTMLList addObject:HTMLTypeImage];
    }
    if (self.parseItalicTag) {
        [HTMLList addObject:HTMLTypeItalic];
    }
    if (self.parseLinkTag) {
        [HTMLList addObject:HTMLTypeLink];
    }
    if (self.parseUnderlineTag) {
        [HTMLList addObject:HTMLTypeUnderline];
    }
    if (self.parseLinkSeeMoreChatMessage) {
        [HTMLList addObject:HTMLTypeLinkSeeMoreChatMessage];
    }
    
    NSInteger lengthLimit = string.length;
    
    [self.aLinks removeAllObjects];
    UIColor *color = self.defaultTextColor;
    CGFloat fontSize = self.fontText.pointSize;
    BOOL hasItalic = NO;
    BOOL hasBold = NO;
    BOOL hasUnderline = NO;
    
    NSString *url = nil;
    
    NSMutableAttributedString* aString =
    [[NSMutableAttributedString alloc] initWithString:@""];
    
    NSRegularExpression* regex = [[NSRegularExpression alloc]
                                  initWithPattern:@"(.*?)(<[^>]+>|\\Z)"
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil];
    NSArray* chunks = [regex matchesInString:string options:0
                                       range:NSMakeRange(0, lengthLimit)];
    
    
    for (NSTextCheckingResult* b in chunks) {
        
        NSArray* parts = [[string substringWithRange:b.range]
                          componentsSeparatedByString:@"<"];
        if (parts.count > 0) {
            NSString *text = [parts objectAtIndex:0];
            
            if (![text isEqualToString:@""]) {
                
                NSMutableAttributedString *normalText = [[NSMutableAttributedString alloc] initWithString:text];
                if (fontSize != self.fontText.pointSize || hasItalic || hasBold) {
                    if (hasBold) {
                        [normalText setFont:[UIFont boldSystemFontOfSize:fontSize]];
                    }
                    else{
                        if (hasItalic) {
                            [normalText setFont:[UIFont italicSystemFontOfSize:fontSize]];
                        }
                        else{
                            [normalText setFont:[UIFont systemFontOfSize:fontSize]];
                        }
                    }
                }
                else{
                    [normalText setFont:self.fontText];
                }
                [normalText setTextColor:color];
                if (hasUnderline) {
                    [normalText setUnderlineStyle:kCTUnderlineStyleSingle modifier:kCTUnderlinePatternSolid];
                }
                [aString appendAttributedString:normalText];
                
                // determine link text
                if (url != nil) {
                    
                    NSString *urlLink = [url lowercaseString];
                    
                    if (urlLink && urlLink.length > 0) {
                        if (![urlLink hasPrefix:@"http://"] && ![urlLink hasPrefix:@"https://"] && ![urlLink hasPrefix:@"ftp://"] && ![urlLink hasPrefix:@"ftps://"]) {
                            
                            if (![urlLink hasPrefix:@"zm://"] && ![urlLink hasPrefix:@"maplocation:"]
                                && ![urlLink hasPrefix:@"zapp://"] && ![urlLink hasPrefix:ZALO_TAG_PREFIX])
                                // [zapp://] is for the "more text" button
                            {
                                urlLink = [NSString stringWithFormat:@"http://%@", urlLink];//incase google.com
                            }
                            else {
                                urlLink = url;
                            }
                            
                        }
                        NSString *textShow = text;
                        NSInteger current = aString.length - text.length;
                        NSRange textRange = NSMakeRange(current, text.length);
                        NSDictionary *dictInfo = [NSDictionary dictionaryWithObjectsAndKeys:urlLink, @"urlLink",
                                                  textShow, @"textShow",
                                                  [NSValue valueWithRange:textRange], @"textRange",
                                                  nil];
                        [[self aLinks] addObject:dictInfo];
                    }
                    
                    url = nil;
                }
            }
            
            //handle new formatting tag //3
            for (int i=1; i<parts.count; i++) {
                __block BOOL detected = NO;
                NSString* tag = (NSString*)[parts objectAtIndex:i];
                
                if ([tag hasPrefix:HTMLTypeFont] && self.parseFontTag) {// determine font
                    
                    [self pushTag:HTMLTypeFont withStack:stackTagsRemember];
                    
                    if ([tag hasPrefix:HTMLTypeFontColor] || [tag hasPrefix:HTMLTypeFontSize]) {// determine color
                        
                        //font color
                        [self parseFontColor:tag detected_p:&detected color:&color];
                        
                        //font size
                        [self parseFontSize:&detected tag:tag fontSize:&fontSize];
                    }
                    
                }
                else if ([tag hasPrefix:HTMLTypeImage] && self.parseImageTag) {// determine emoticon
                    
                    [self pushTag:HTMLTypeImage withStack:stackTagsRemember];
                    
                    self.hasEmoticon = YES;
                    
                    [self parseImageSource:&detected tag:tag aString:aString];
                    
                }
                else if (([tag hasPrefix:HTMLTypeLink] && self.parseLinkTag) || ([tag hasPrefix:HTMLTypeLinkSeeMoreChatMessage] && self.parseLinkSeeMoreChatMessage)) {// determine link
                    
                    NSString *htmlTyle = HTMLTypeLinkSeeMoreChatMessage;
                    if (![tag hasPrefix:HTMLTypeLinkSeeMoreChatMessage] && [tag hasPrefix:HTMLTypeLink] && self.parseLinkTag) {
                        htmlTyle = HTMLTypeLink;
                    }
                    
                    //convert <a href="">vng</a> --> <a href="#">vng</a>
                    tag = [tag stringByReplacingOccurrencesOfString:@"\"\"" withString:@"\"#\""];
                    
                    //href
                    __block NSRange range = NSMakeRange(0, 0);
                    
                    NSString *stringPattern = @"(?<=href=\")[^\"]+";
                    [self parseLinkHref:stringPattern range_p:&range detected_p:&detected tag:tag];
                    
                    if (range.length == 0) {
                        stringPattern = @"(?<=href =\")[^\"]+";
                        [self parseLinkHref:stringPattern range_p:&range detected_p:&detected tag:tag];
                        
                        if (range.length == 0) {
                            stringPattern = @"(?<=href = \")[^\"]+";
                            [self parseLinkHref:stringPattern range_p:&range detected_p:&detected tag:tag];
                            
                            if (range.length == 0) {
                                stringPattern = @"(?<=href= \")[^\"]+";
                                [self parseLinkHref:stringPattern range_p:&range detected_p:&detected tag:tag];
                            }
                            else {
                                [self pushTag:htmlTyle withStack:stackTagsRemember];
                            }
                        }
                        else {
                            [self pushTag:htmlTyle withStack:stackTagsRemember];
                        }
                    }
                    else {
                        [self pushTag:htmlTyle withStack:stackTagsRemember];
                    }
                    
                    NSString *textHref = [tag substringWithRange:range];
                    url = textHref;
                }
                else if ([tag hasPrefix:HTMLTypeBold] && self.parseBoldTag){
                    
                    [self pushTag:HTMLTypeBold withStack:stackTagsRemember];
                    
                    detected = YES;
                    hasBold = YES;
                }
                else if ([tag hasPrefix:HTMLTypeItalic] && self.parseItalicTag){
                    
                    [self pushTag:HTMLTypeItalic withStack:stackTagsRemember];
                    
                    detected = YES;
                    hasItalic = YES;
                }
                else if ([tag hasPrefix:HTMLTypeUnderline] && self.parseUnderlineTag){
                    
                    [self pushTag:HTMLTypeUnderline withStack:stackTagsRemember];
                    
                    detected = YES;
                    hasUnderline = YES;
                }
                
                //If this tag didn't defined
                if (!detected) {
                    NSString* tag = (NSString*)[parts objectAtIndex:i];
                    BOOL tagHasDefine = NO;
                    
                    if ([tag hasPrefix:@"/"] && [tag hasSuffix:@">"]) {
                        NSString *temp = tag;
                        if ([temp hasPrefix:@"/"]) {//sample "/a>"
                            temp = [temp substringFromIndex:1];
                        }
                        if ([temp hasSuffix:@">"]) {
                            temp = [temp substringToIndex:temp.length-1];
                        }
                        
                        //reset
                        if ([temp isEqualToString:HTMLTypeFont]) {
                            color = self.defaultTextColor;
                            fontSize = self.fontText.pointSize;
                        }
                        else if ([temp isEqualToString:HTMLTypeItalic]) {
                            hasItalic = NO;
                        }
                        else if ([temp isEqualToString:HTMLTypeBold]) {
                            hasBold = NO;
                        }
                        else if ([temp isEqualToString:HTMLTypeUnderline]) {
                            hasUnderline = NO;
                        }
                        
                        
                        for (NSString *key in HTMLList) {
                            if ([key isEqualToString:temp] && ([self popTag:key withStack:stackTagsRemember] > 0)) {
                                tagHasDefine = YES;
                                break;
                            }
                        }
                    }
                    
                    if (tagHasDefine == NO) {
                        NSString *textCanNotFormat = [NSString stringWithFormat:@"<%@", tag];
                        color = self.defaultTextColor;
                        fontSize = self.fontText.pointSize;
                        NSMutableAttributedString *normalText = [[NSMutableAttributedString alloc] initWithString:textCanNotFormat];
                        [normalText setFont:self.fontText];
                        [normalText setTextColor:color];
                        [aString appendAttributedString:normalText];
                    }
                }
            }
        }
    }
    
    return aString;
}

- (UIColor *) colorFromHexString:(NSString *)hexString alpha: (CGFloat)alpha{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)lockTagsInChat {
    self.parseBoldTag = NO;
    self.parseFontTag = NO;
    self.parseItalicTag = NO;
    self.parseUnderlineTag = NO;
    self.parseLinkTag = NO;
}

#pragma mark - Frame implementation

- (void)createTextFrame:(CGRect)bounds{
    if (nil == self.textFrame) {
        CFAttributedStringRef attributedStringRef = (__bridge CFAttributedStringRef)self.attributedString;
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attributedStringRef);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, bounds);
        self.textFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        
        CGPathRelease(path);
        CFRelease(framesetter);
    }
}

- (void)createLines:(CGRect)bounds{
    CFArrayRef textLines = CTFrameGetLines(self.textFrame);
    CFIndex count = CFArrayGetCount(textLines);
    CGPoint mOrigins[count];
    CTFrameGetLineOrigins(self.textFrame, CFRangeMake(0, 0), mOrigins);
    self.origins = [[NSMutableArray alloc] init] ;
    for (int i=0; i<count; i++) {
        [self.origins addObject:[NSValue valueWithCGPoint:CGPointMake(mOrigins[i].x, bounds.size.height - mOrigins[i].y)]];
    }
}

- (void)resetTextFrame{
    
    if(self.textFrame != nil){
        CFRelease(self.textFrame);
        self.textFrame = nil;
    }
}


- (void)expandOriginalString{
    self.fitSize = CGSizeZero;
    self.storeHeightWithLines = nil;
    //We don't need to refresh the string if it is not cut
    //But we still need to reset text frame and lines
    if(!self.hasInitWithLimit){
        [self resetTextFrame];
        return;
    }
    
    self.uiString = self.parsedString.copy;
    self.attributedString = nil;
    [self attributedString];
    
}
@end
