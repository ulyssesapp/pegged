//
//  main.m
//  pegged
//
//  Created by Matt Diephouse on 12/17/09.
//  This code is in the public domain.
//

#import <Foundation/Foundation.h>

#import "ASTNode.h"
#import "ASTParser.h"

BOOL checkError(NSString *equation)
{
	BOOL hadError = NO;
	
	NSNumberFormatter *formatter = [NSNumberFormatter new];
	
	NSArray  *parts			= [equation componentsSeparatedByString:@"="];
	NSString *expression	= [parts objectAtIndex:0];
	
	NSArray *expectedError			= [[parts lastObject] componentsSeparatedByString: @","];
	if (expectedError.count != 2)
		return NO;

	NSString *expectedErrorName		= [expectedError[0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	NSNumber *expectedErrorIndex	= [formatter numberFromString:expectedError[1]];
	
	ASTParser *parser     = [ASTParser new];
	ASTNode *node;
	
	BOOL matched = [parser parseString:expression usingResult:&node];
	
	if (matched || ![parser.lastError.localizedDescription isEqual: expectedErrorName] || ![parser.lastError.userInfo[ASTParserErrorStringIndexKey] isEqual: expectedErrorIndex]) {
		NSLog(@"Expected error: '%@' at %@. Got '%@' at %@.", expectedErrorName, expectedErrorIndex, parser.lastError.localizedDescription, parser.lastError.userInfo[ASTParserErrorStringIndexKey]);
		hadError = YES;
	}

	return hadError;
}

BOOL checkValue(NSString *equation)
{
	BOOL hadError = NO;
	
	NSNumberFormatter *formatter = [NSNumberFormatter new];
	
	NSArray  *parts			= [equation componentsSeparatedByString:@"="];
	NSString *expression	= [parts objectAtIndex:0];
	NSNumber *result		= [formatter numberFromString:[parts lastObject]];
	
	ASTParser *parser     = [ASTParser new];
	ASTNode *node;
	
	BOOL matched = [parser parseString:expression usingResult:&node];
	
	if (!matched || (result.integerValue != node.evaluate))
	{
		NSString *output = [NSString stringWithFormat:@"%@ should result in %@. Got %@.\n", expression, result, node.description];
		fprintf(stderr, "%s", [output UTF8String]);
		hadError = YES;
	}

	return hadError;
}

int main (int argc, const char * argv[])
{
    if (argc < 2)
        return 1;
	
	if (argc > 3)
		return 1;
	
	BOOL matchErrors = (argc == 3) && !strcmp(argv[2], "-e");

    @autoreleasepool {
    
        NSError *error = nil;
        NSString *file     = [NSString stringWithUTF8String:argv[1]];
        NSString *contents = [[NSString alloc] initWithContentsOfFile: file
                                                             encoding: NSUTF8StringEncoding
                                                                error: &error];
        
        
        
        BOOL hadError = NO;

        for (NSString *equation in [contents componentsSeparatedByString:@"\n"])
        {
            if (matchErrors)
				hadError |= checkError(equation);
			else
				hadError |= checkValue(equation);
        }
        
        
        
        return hadError;
    }
}
