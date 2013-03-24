//
//  UploadProgressView.m
//  Weddine
//
//  Created by Guilherme Moura on 26/01/2013.
//  Copyright (c) 2013 Reefactor, Inc. All rights reserved.
//

#import "WDUploadProgressView.h"
#import <QuartzCore/QuartzCore.h>

@interface WDUploadProgressView ()
@property (assign, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UIProgressView *progressView;


@end

@implementation WDUploadProgressView

// Init a progress view on a header view of a scroll view, such as a table view.
- (id)initWithTableView:(UITableView *)tableView {
	return [self initWithTableView:tableView cancelButton:NO];
}

- (id)initWithTableView:(UITableView *)tableView cancelButton:(BOOL)showButton {
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 320.0, 54.0)];
    if (self) {
		self.tableView = tableView;
		self.progress = 0.0f;
		self.animatedProgress = YES;
		
		// Configure the background
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WDUploadProgressView.bundle/progress_view_background.png"]];
		

		
		// Create the Uploading Label
		self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(56.0, 8.0, 225.0, 20.0)];
		self.progressLabel.text = @"Downloading...";
		self.progressLabel.opaque = NO;
		self.progressLabel.backgroundColor = [UIColor clearColor];
		self.progressLabel.textColor = [UIColor colorWithRed:0.062 green:0.078 blue:0.156 alpha:1.0];
		self.progressLabel.font = [UIFont boldSystemFontOfSize:15.0];
		
		[self addSubview:self.progressLabel];
		
		// Create the Progress Bar
		self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
		
		if (showButton) {
			[self.progressView setFrame:CGRectMake(56.0, 32.0, 225.0, 11.0)];
		} else {
			[self.progressView setFrame:CGRectMake(56.0, 32.0, 250.0, 11.0)];
		}
		
		[self.progressView setProgress:0.0 animated:NO];
		[self.progressView setProgressTintColor:[UIColor colorWithRed:0.431 green:0.753 blue:0.949 alpha:1.0]];
		[self.progressView setTrackTintColor:[UIColor darkGrayColor]];
		
		[self addSubview:self.progressView];
		
				
		[self.tableView setTableHeaderView:self];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
	CGFloat prog = MIN(progress, 1.0);

	[self.progressView setProgress:prog animated:self.animatedProgress];
	
	if (prog == 1.0) {
		[self performSelector:@selector(completedUpload) withObject:nil afterDelay:2.0];
	}
}

- (void)setProgressTintColor:(UIColor *)color {
	[self.progressView setProgressTintColor:color];
}

- (void)setProgressTrackColor:(UIColor *)color {
	[self.progressView setTrackTintColor:color];
}



- (void)setUploadMessage:(NSString *)uploadMessage {
	[self.progressLabel setText:uploadMessage];
}

- (void)completedUpload {
	if (self.delegate)
		[self.delegate uploadDidFinish:self];
}

- (void)canceledUpload {
	if (self.delegate)
		[self.delegate uploadDidCancel:self];
}

#pragma mark - APIClientUpload delegate methods
- (void)uploadDidUpdate:(CGFloat)progress {
	[self setProgress:progress];
}

@end
