//
//  CFDViewController.m
//  CardFlipDemo
//
//  Created by Douglas Hill on 16/03/2013.
//  Copyright (c) 2013 Douglas Hill. All rights reserved.
//

#import "CFDViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CAAnimation+CompletionBlock.h"

@interface CFDViewController ()

@property (nonatomic, strong) UIView *card;
@property (nonatomic, strong) UIView *cardBack;

@end

@implementation CFDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	return [self init];
}

- (instancetype)init
{
	self = [super initWithNibName:nil bundle:nil];
	return self;
}

- (void)loadView
{
	[self setView:[[UIView alloc] init]];
	[[self view] setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.8 alpha:1.0]];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UIView *card = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	[card setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.6 alpha:1.0]];
	[[self view] addSubview:card];
	[self setCard:card];
	
	UITapGestureRecognizer *tapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)];
	[tapRecogniser setNumberOfTouchesRequired:1];
	[tapRecogniser setNumberOfTapsRequired:1];
	[card addGestureRecognizer:tapRecogniser];
	
	UIView *cardBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
	[cardBack setBackgroundColor:[UIColor colorWithRed:0.8 green:0.1 blue:0.3 alpha:1.0]];
	[self setCardBack:cardBack];
	UITapGestureRecognizer *backTapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardBackTapped:)];
	[backTapRecogniser setNumberOfTouchesRequired:1];
	[backTapRecogniser setNumberOfTapsRequired:1];
	[cardBack addGestureRecognizer:backTapRecogniser];
}

- (void)viewDidAppear:(BOOL)animated
{
	[UIView animateWithDuration:0.25 animations:^{
		[[self card] setCenter:[[self view] center]];
	}];
}

- (void)flip
{
	CFTimeInterval duration = 0.5;
	
//	CGFloat xScale = [[self cardBack] bounds].size.width / [[self card] frame].size.width;
//	CGFloat yScale = [[self cardBack] bounds].size.height / [[self card] frame].size.height;
	CGFloat xScale = 1.6;
	CGFloat yScale = 2.3;
	
	CATransform3D frontRotation = CATransform3DMakeRotation(M_PI / 2.0, 0, 1, 0);
	frontRotation = CATransform3DScale(frontRotation, xScale, yScale, 1);
	frontRotation.m34 = - 1.0 / 200.0;
	
	CATransform3D backRotation = CATransform3DMakeRotation(- M_PI / 2.0, 0, 1, 0);
	backRotation = CATransform3DScale(backRotation, 1.0 / xScale, 1.0 / yScale, 1);
	backRotation.m34 = - 1.0 / 200.0;
	
	CABasicAnimation *frontAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	[frontAnimation setDuration:duration / 2.0];
	[frontAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
	[frontAnimation setToValue:[NSValue valueWithCATransform3D:frontRotation]];
	
	CABasicAnimation *backAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	backAnimation.duration = duration / 2.0;
	backAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	backAnimation.fromValue = [NSValue valueWithCATransform3D:backRotation];
	backAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	[backAnimation setCompletion:^(BOOL finished) {
		
	}];
	
	[frontAnimation setCompletion:^(BOOL finished) {
		[[self card] removeFromSuperview];
		[[self view] addSubview:[self cardBack]];
		[[self cardBack] setFrame:[[self view] bounds]];
		[[[self cardBack] layer] addAnimation:backAnimation forKey:nil];
	}];
	
	[[[self card] layer] addAnimation:frontAnimation forKey:nil];
}

- (void)unflip
{
	CFTimeInterval duration = 0.5;
	
	CGFloat xScale = 1.6;
	CGFloat yScale = 2.3;
	
	CATransform3D frontRotation = CATransform3DMakeRotation(M_PI / 2.0, 0, 1, 0);
	frontRotation = CATransform3DScale(frontRotation, xScale, yScale, 1);
	frontRotation.m34 = - 1.0 / 200.0;
	
	CATransform3D backRotation = CATransform3DMakeRotation(- M_PI / 2.0, 0, 1, 0);
	backRotation = CATransform3DScale(backRotation, 1.0 / xScale, 1.0 / yScale, 1);
	backRotation.m34 = - 1.0 / 200.0;
	
	CABasicAnimation *backAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	backAnimation.duration = duration / 2.0;
	backAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	backAnimation.toValue = [NSValue valueWithCATransform3D:backRotation];
	
	CABasicAnimation *frontAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	[frontAnimation setDuration:duration / 2.0];
	[frontAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
	[frontAnimation setFromValue:[NSValue valueWithCATransform3D:frontRotation]];
	[frontAnimation setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
	
	[backAnimation setCompletion:^(BOOL finished) {
		[[self cardBack] removeFromSuperview];
		[[self view] addSubview:[self card]];
		[[[self card] layer] addAnimation:frontAnimation forKey:nil];
	}];
	
	[[[self cardBack] layer] addAnimation:backAnimation forKey:nil];
}

- (void)cardTapped:(UIGestureRecognizer *)sender
{
	if ([sender state] == UIGestureRecognizerStateRecognized) {
		[self flip];
	}
}

- (void)cardBackTapped:(UIGestureRecognizer *)sender
{
	if ([sender state] == UIGestureRecognizerStateRecognized) {
		[self unflip];
	}
}

@end
