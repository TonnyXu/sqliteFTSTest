//
//  TTViewController.m
//  sqliteFTSTest
//
//  Created by Tonny Xu on 12/11/11.
//  Copyright (c) 2011 blog.totodotnet.net. All rights reserved.
//

#import "TTViewController.h"
#import "FileReader.h"

@implementation TTViewController
@synthesize searchFeild;
@synthesize resultLabel;

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
}

- (void)viewDidUnload
{
  [self setSearchFeild:nil];
  [self setResultLabel:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)readinRecords:(id)sender {

  FileReader *txtFileReader = [[FileReader alloc] initWithFilePath:[[NSBundle mainBundle] pathForResource:@"edict2_utf8" ofType:@"txt"]];
  __block int readLines = 0;
  [txtFileReader enumerateLinesUsingBlock:^(NSString *aNewLine, BOOL *stop) {
    if (readLines >= 20) *stop = YES;
    NSLog(@"We Got: %@", aNewLine);
    readLines++;
  }];
  
  
}

- (IBAction)doFTSSearch:(id)sender {
}
@end
