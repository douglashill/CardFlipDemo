//
//  CAAnimation+CompletionBlock.m
//
//  Created by Douglas Hill on 10/03/2013.
//

#import "CAAnimation+CompletionBlock.h"


@interface _DHAnimationDelegate : NSObject

@property (nonatomic, copy) void (^completion)(BOOL finished);

@end

@implementation _DHAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished
{
	self.completion(finished);
}

@end



@implementation CAAnimation (CompletionBlock)

- (void (^)(BOOL))completion
{
	if ([self.delegate isKindOfClass:[_DHAnimationDelegate class]]) {
		_DHAnimationDelegate *delegate = (_DHAnimationDelegate *)self.delegate;
		return delegate.completion;
	}
	return nil;
}

- (void)setCompletion:(void (^)(BOOL))completion
{
	_DHAnimationDelegate *delegate = [[_DHAnimationDelegate alloc] init];
	delegate.completion = completion;
	self.delegate = delegate;
}

@end
