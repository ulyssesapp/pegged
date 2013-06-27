//
//  Subrule.h
//  pegged
//
//  Created by Matt Diephouse on 1/1/10.
//  This code is in the public domain.
//

#import <Foundation/Foundation.h>

#import "Terminal.h"

@class Rule;

@interface Subrule : Terminal
{
    Rule *_rule;
	BOOL _capturing;
}

@property (strong) Rule *rule;

+ (id) subruleWithRule:(Rule *)rule capturing:(BOOL)capturing;
- (id) initWithRule:(Rule *)rule capturing:(BOOL)capturing;

@end
