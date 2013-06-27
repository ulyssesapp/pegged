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
    return [NSString stringWithFormat:@"[parser matchRule:@\"%@\"]", self.rule.name];
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

+ (id) subruleWithRule:(Rule *)rule capturing:(BOOL)capturing
{
    return [[[self class] alloc] initWithRule:rule capturing:capturing];
}


- (id) initWithRule:(Rule *)rule capturing:(BOOL)capturing
{
    self = [super init];
    
    if (self)
    {
        _rule = rule;
		_capturing = capturing;
    }
    
    return self;
}


@end
