//
//  CAAnimation+CompletionBlock.h
//
//  Created by Douglas Hill on 10/03/2013.
//

#import <QuartzCore/QuartzCore.h>

@interface CAAnimation (CompletionBlock)

@property (nonatomic, copy) void (^completion)(BOOL finished);

@end
