//
//  AST.m
//  pegged
//
//  Created by Friedrich Gräter.
//  This code is in the public domain.
//

#import "ASTNode.h"

@implementation ASTNode

+ (id)astNodeWithValue:(NSInteger)value
{
	ASTNode *node = [ASTNode new];
	
	node.name = @"Value";
	node.value = value;
	
	return node;
}

+ (id)astNodeWithName:(NSString *)name left:(ASTNode *)left operator:(NSString *)operator right:(ASTNode *)right
{
	ASTNode *node = [ASTNode new];
	NSAssert(name && left && right && operator, @"Invalid arguments");
	
	node.name = name;
	node.operator = operator;
	node.left = left;
	node.right = right;

	return node;
}

- (NSInteger)evaluate
{
	if (!self.operator)
		return self.value;
	
	if ([self.operator isEqual: @"+"])
		return self.left.evaluate + self.right.evaluate;
	if ([self.operator isEqual: @"-"])
		return self.left.evaluate - self.right.evaluate;
	if ([self.operator isEqual: @"*"])
		return self.left.evaluate * self.right.evaluate;
	if ([self.operator isEqual: @"/"])
		return self.left.evaluate / self.right.evaluate;
	
	return 0;
}

- (NSString *)description
{
	if (!self.operator)
		return [NSString stringWithFormat: @"%li", self.value];
	
	NSString *left = self.left.description;
	NSString *right = self.right.description;
	
	left = [left stringByReplacingOccurrencesOfString:@"(?m)^" withString:@"\t" options:NSRegularExpressionSearch range:NSMakeRange(0, left.length)];
	right = [right stringByReplacingOccurrencesOfString:@"(?m)^" withString:@"\t" options:NSRegularExpressionSearch range:NSMakeRange(0, right.length)];	
	
	return [NSString stringWithFormat: @"%@ with %@:\n%@\n%@\n", self.name, self.operator, left, right];
}

@end
