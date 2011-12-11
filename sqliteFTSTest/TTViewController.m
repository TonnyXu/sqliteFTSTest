//
//  TTViewController.m
//  sqliteFTSTest
//
//  Created by Tonny Xu on 12/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TTViewController.h"
#import "sqlite3.h"

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
  
  NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:[[NSBundle mainBundle] pathForResource:@"edict2_utf8" ofType:@"txt"]];
  __block int count = 0;
  fh.readabilityHandler = ^(NSFileHandle *theHandler){
    NSData *availableData = theHandler.availableData;
    NSLog(@"We got: %@", [[NSString alloc] initWithBytesNoCopy:[availableData bytes] length:[availableData length] encoding:NSUTF8StringEncoding freeWhenDone:YES]);
    count++;
    if (count >= 20) {
      theHandler = nil;
    }
  };
//  dispatch_queue_t importQueue = dispatch_queue_create("net.totodotnet.tonny.fts.readin", NULL);
//  dispatch_async(importQueue, ^{
//    
//  });
  
}

- (IBAction)doFTSSearch:(id)sender {
}
@end
