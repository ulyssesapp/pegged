//
//  Action.m
//  pegged
//
//  Created by Matt Diephouse on 12/29/09.
//  This code is in the public domain.
//

#import "Action.h"


@implementation Action

//==================================================================================================
#pragma mark -
#pragma mark Node Methods
//==================================================================================================

- (NSString *) compile:(NSString *)parserClassName
{
    NSMutableString *code = [NSMutableString string];
    
    [code appendFormat:@"    [parser performActionUsingCaptures:*localCaptures block:^id(%@ *self, NSString *text){", parserClassName];
    [code appendString:_code];
	if (!_hasReturnValue)
		[code appendString: @"return nil;"];
    [code appendString:@"    }];"];
    	
    return code;
}


//==================================================================================================
#pragma mark -
#pragma mark Public Methods
//==================================================================================================

+ (id) actionWithCode:(NSString *)code returnValue:(BOOL)returnValue
{
    return [[[self class] alloc] initWithCode:code returnValue:returnValue];
}


- (id) initWithCode:(NSString *)code returnValue:(BOOL)returnValue
{
    self = [super init];
    
    if (self)
    {
        _code = [code copy];
		_hasReturnValue = returnValue;
    }
    
    return self;
}


@end
