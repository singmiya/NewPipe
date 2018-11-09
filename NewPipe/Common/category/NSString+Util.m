//
//  NSString+Util.m
//  NewPipe
//
//  Created by Somiya on 2018/11/3.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)
- (NSString *)convertNumber {
    NSArray *nums = [self componentsSeparatedByString:@","];
    if (nums.count == 2) {
        return [NSString stringWithFormat:@"%@K", nums[0]];
    }
    if (nums.count == 3) {
        return [NSString stringWithFormat:@"%@M", nums[0]];
    }
    if (nums.count == 4) {
        return [NSString stringWithFormat:@"%@Bil", nums[0]];
    }
    return [NSString stringWithFormat:@"%@", self];
}
@end
