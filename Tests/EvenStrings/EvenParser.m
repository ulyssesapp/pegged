//
//  Generated by preggers 0.3.0.
//

#import "EvenParser.h"


@interface EvenParser ()

- (BOOL) _matchDot;
- (BOOL) _matchString:(char *)s;
- (BOOL) _matchClass:(unsigned char *)bits;
- (BOOL) matchString;

@end


@implementation EvenParser

@synthesize dataSource = _dataSource;

//==================================================================================================
#pragma mark -
#pragma mark Rules
//==================================================================================================


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef matchDEBUG
#define yyprintf(args)	{ fprintf args; fprintf(stderr," @ %s\n",[[_string substringFromIndex:_index] UTF8String]); }
#else
#define yyprintf(args)
#endif

- (BOOL) _refill
{
    if (!self.dataSource)
        return NO;

    NSString *nextString = [self.dataSource nextString];
    if (nextString)
    {
        nextString = [_string stringByAppendingString:nextString];
        [_string release];
        _string = [nextString retain];
    }
    _limit = [_string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    yyprintf((stderr, "refill"));
    return YES;
}

- (BOOL) _matchDot
{
    if (_index >= _limit && ![self _refill]) return NO;
    ++_index;
    return YES;
}

- (BOOL) _matchString:(char *)s
{
#ifndef EVENPARSER_CASE_INSENSITIVE
    const char *cstring = [_string UTF8String];
#else
    const char *cstring = [[_string lowercaseString] UTF8String];
#endif
    int saved = _index;
    while (*s)
    {
        if (_index >= _limit && ![self _refill]) return NO;
        if (cstring[_index] != *s)
        {
            _index = saved;
    yyprintf((stderr, "  fail _matchString"));
            return NO;
        }
        ++s;
        ++_index;
    }
    yyprintf((stderr, "  ok   _matchString"));
    return YES;
}

- (BOOL) _matchClass:(unsigned char *)bits
{
    if (_index >= _limit && ![self _refill]) return NO;
    int c = [_string characterAtIndex:_index];
    if (bits[c >> 3] & (1 << (c & 7)))
    {
        ++_index;
        yyprintf((stderr, "  ok   _matchClass"));
        return YES;
    }
    yyprintf((stderr, "  fail _matchClass"));
    return NO;
}

- (void) yyDo:(SEL)action
{
    while (yythunkpos >= yythunkslen)
    {
        yythunkslen *= 2;
        yythunks= realloc(yythunks, sizeof(yythunk) * yythunkslen);
    }
    yythunks[yythunkpos].begin=  yybegin;
    yythunks[yythunkpos].end=    yyend;
    yythunks[yythunkpos].action= action;
    ++yythunkpos;
}

- (void) yyText:(int)begin to:(int)end
{
    int len = end - begin;
    if (len <= 0)
    {
        [_text release];
        _text = nil;
    }
    else
    {
        _text = [_string substringWithRange:NSMakeRange(begin, end-begin)];
        [_text retain];
    }
}

- (void) yyDone
{
    int pos;
    for (pos= 0;  pos < yythunkpos;  ++pos)
    {
        yythunk *thunk= &yythunks[pos];
        [self yyText:thunk->begin to:thunk->end];
        yyprintf((stderr, "DO [%d] %s %s\n", pos, [NSStringFromSelector(thunk->action) UTF8String], [_text UTF8String]));
        [self performSelector:thunk->action withObject:_text];
    }
    yythunkpos= 0;
}

- (void) yyCommit
{
    NSString *newString = [_string substringFromIndex:_index];
    [_string release];
    _string = [newString retain];
    _limit -= _index;
    _index = 0;

    yybegin -= _index;
    yyend -= _index;
    yythunkpos= 0;
}

- (BOOL) matchString
{
    NSUInteger index0=_index, yythunkpos1=yythunkpos;
    yyprintf((stderr, "%s", "String"));
    NSUInteger index3=_index, yythunkpos4=yythunkpos;
    yybegin = _index;
    if (![self _matchString:"a"]) goto L6;
    ;
    NSUInteger index9, yythunkpos10;
L11:
    index9=_index; yythunkpos10=yythunkpos;
    if (![self _matchString:"a"]) goto L12;
    goto L11;
L12:
    _index=index9; yythunkpos=yythunkpos10;
    yyend = _index;
    if (!( (yyend-yybegin)%2 == 0 )) goto L6;
    NSUInteger index13=_index, yythunkpos14=yythunkpos;
    if ([self _matchDot]) goto L6;
    _index=index13; yythunkpos=yythunkpos14;
    goto L5;
L6:
    _index=index3; yythunkpos=yythunkpos4;
    yybegin = _index;
    if (![self _matchString:"b"]) goto L2;
    ;
    NSUInteger index17, yythunkpos18;
L19:
    index17=_index; yythunkpos18=yythunkpos;
    if (![self _matchString:"b"]) goto L20;
    goto L19;
L20:
    _index=index17; yythunkpos=yythunkpos18;
    yyend = _index;
    if (( (yyend-yybegin)%2 == 1 )) goto L2;
    NSUInteger index21=_index, yythunkpos22=yythunkpos;
    if ([self _matchDot]) goto L2;
    _index=index21; yythunkpos=yythunkpos22;
    goto L5;
L5:
    yyprintf((stderr, "  ok   %s", "String"));
    return YES;
L2:
    _index=index0; yythunkpos=yythunkpos1;
    yyprintf((stderr, "  fail %s", "String"));
    return NO;
}

- (BOOL) yyparsefrom:(SEL)startRule
{
    BOOL yyok;
    if (!yythunkslen)
    {
        yythunkslen= 32;
        yythunks= malloc(sizeof(yythunk) * yythunkslen);
        yybegin= yyend= yythunkpos= 0;
    }
    if (!_string)
    {
        _string = [NSString new];
        _limit = 0;
        _index = 0;
    }
    yybegin= yyend= _index;
    yythunkpos= 0;

    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:startRule];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:self];
    [invocation setSelector:startRule];
    [invocation invoke];
    [invocation getReturnValue:&yyok];
    if (yyok) [self yyDone];
    [self yyCommit];

    [_string release];
    _string = nil;
    [_text release];
    _text = nil;

    return yyok;
}

- (BOOL) yyparse
{
    return [self yyparsefrom:@selector(matchString)];
}


//==================================================================================================
#pragma mark -
#pragma mark NSObject Methods
//==================================================================================================

- (void) dealloc
{
    free(yythunks);

    [_string release];

    [super dealloc];
}


//==================================================================================================
#pragma mark -
#pragma mark Public Methods
//==================================================================================================

- (BOOL) parse
{
    NSAssert(_dataSource != nil, @"can't call -parse without specifying a data source");
    return [self yyparse];
}


- (BOOL) parseString:(NSString *)string
{
    _string = [string copy];
    _limit  = [_string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    _index  = 0;
    BOOL retval = [self yyparse];
    [_string release];
    _string = nil;
    return retval;
}


@end

