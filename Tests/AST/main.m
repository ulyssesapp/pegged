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

int main (int argc, const char * argv[])
{
    if (argc != 2)
        return 1;
    
    @autoreleasepool {
    
        NSError *error = nil;
        NSString *file     = [NSString stringWithUTF8String:argv[1]];
        NSString *contents = [[NSString alloc] initWithContentsOfFile: file
                                                             encoding: NSUTF8StringEncoding
                                                                error: &error];
        
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        
        BOOL hadError = NO;
        NSUInteger line = 1;
        for (NSString *equation in [contents componentsSeparatedByString:@"\n"])
        {
            NSArray  *parts      = [equation componentsSeparatedByString:@"="];
            NSString *expression = [parts objectAtIndex:0];
            NSNumber *result     = [formatter numberFromString:[parts lastObject]];
            
            ASTParser *parser     = [ASTParser new];
			ASTNode *node;

            BOOL matched = [parser parseString:expression usingResult:&node];

            if (!matched || (result.integerValue != node.evaluate))
            {
                NSString *output = [NSString stringWithFormat:@"%@:%lu: error: %@!=%@ (== %@)\n", file, line, expression, result, node.description];
                fprintf(stderr, "%s", [output UTF8String]);
                hadError = YES;
            }
            line++;
        }
        
        
        
        return hadError;
    }
}
