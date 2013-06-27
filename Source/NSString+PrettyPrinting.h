//
//  NSString+PrettyPrinting.h
//  pegged
//
//  Created by Friedrich Gräter on 27.06.13.
//
//

#import <Foundation/Foundation.h>

@interface NSString (PrettyPrinting)

- (NSString *)stringIndentedByCount:(NSInteger)count;

- (NSString *)stringByRemovingTrailingWhitespace;

@end
