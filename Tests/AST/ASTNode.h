//
//  Calculator.h
//  pegged
//
//  Created by Friedrich Gräter.
//  This code is in the public domain.
//

#import <Foundation/Foundation.h>


@interface ASTNode : NSObject

+ (id)astNodeWithValue:(NSInteger)value;
+ (id)astNodeWithName:(NSString *)name left:(ASTNode *)left operator:(NSString *)operator right:(ASTNode *)right;

@property NSString *name, *operator;
@property ASTNode *left, *right;

@property NSInteger value;

- (NSInteger)evaluate;
- (NSString *)description;

@end
