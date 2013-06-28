//
//  Literal.m
//  pegged
//
//  Created by Matt Diephouse on 12/29/09.
//  This code is in the public domain.
//

#import "Literal.h"


@implementation Literal

@synthesize caseInsensitive = _caseInsensitive;
@synthesize string = _string;

//==================================================================================================
#pragma mark -
#pragma mark Terminal Methods
//==================================================================================================

- (NSString *) condition
{
    NSString *string = self.caseInsensitive ? [self.string lowercaseString] : self.string;
    return [NSString stringWithFormat:@"[parser matchString: \"%@\" asserted:%@]", string, _asserted ? @"YES" : @"NO"];
}


//==================================================================================================
#pragma mark -
#pragma mark Public Methods
//==================================================================================================

+ (id) literalWithString:(NSString *)string asserted:(BOOL)asserted
{
    return [[[self class] alloc] initWithString:string asserted:asserted];
}


- (id) initWithString:(NSString *)string asserted:(BOOL)asserted
{
    self = [super init];
    
    if (self)
    {
        _string = [string copy];
		_asserted = asserted;
    }
    
    return self;
}


@end
