//
//  Rule.m
//  pegged
//
//  Created by Matt Diephouse on 12/28/09.
//  This code is in the public domain.
//

#import "Rule.h"

#import "Compiler.h"
#import "Node.h"

@implementation Rule

@synthesize name = _name;
@synthesize used = _used;

@synthesize definition = _definition;

//==================================================================================================
#pragma mark -
#pragma mark Public Methods
//==================================================================================================

+ (id) ruleWithName:(NSString*)name
{
    return [[[self class] alloc] initWithName:name];
}


- (id) initWithName:(NSString*)name
{
    self = [super init];
    
    if (self)
    {
        _name = [name copy];
    }
    
    return self;
}


- (NSString *) compile:(NSString *)parserClassName
{
    NSMutableString *code = [NSMutableString string];
    
    [code appendString: [[self.definition compile:parserClassName] stringByRemovingTrailingWhitespace]];
    [code appendString: @"\n\nreturn YES;\n"];
    
    return code;
}


//==================================================================================================
#pragma mark -
#pragma mark Public Properties
//==================================================================================================

- (BOOL) defined
{
    return self.definition != nil;
}


@end
