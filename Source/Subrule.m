//
//  Subrule.m
//  pegged
//
//  Created by Matt Diephouse on 1/1/10.
//  This code is in the public domain.
//

#import "Subrule.h"

#import "Rule.h"

@implementation Subrule

@synthesize rule = _rule;

//==================================================================================================
#pragma mark -
#pragma mark Terminal Methods
//==================================================================================================

- (NSString *) condition
{
    return [NSString stringWithFormat:@"[parser matchRule: @\"%@\" asserted:%@]", self.rule.name, _asserted ? @"YES" : @"NO"];
}

- (NSString *)compileIfAccepted
{
	if (_capturing)
		return [NSString stringWithFormat:@"*localCaptures += 1;\n"];
	else
		return nil;
}


//==================================================================================================
#pragma mark -
#pragma mark Public Methods
//==================================================================================================

+ (id) subruleWithRule:(Rule *)rule capturing:(BOOL)capturing asserted:(BOOL)asserted
{
    return [[[self class] alloc] initWithRule:rule capturing:capturing asserted:asserted];
}


- (id) initWithRule:(Rule *)rule capturing:(BOOL)capturing asserted:(BOOL)asserted
{
    self = [super init];
    
    if (self)
    {
        _rule = rule;
		_capturing = capturing;
		_asserted = asserted;
    }
    
    return self;
}


@end
