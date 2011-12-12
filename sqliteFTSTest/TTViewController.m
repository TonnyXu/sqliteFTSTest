//
//  TTViewController.m
//  sqliteFTSTest
//
//  Created by Tonny Xu on 12/11/11.
//  Copyright (c) 2011 blog.totodotnet.net. All rights reserved.
//

#import "TTViewController.h"
#import "FileReader.h"

@interface TTViewController()

- (NSString *) getSystemFolder:(NSSearchPathDirectory) dir;
- (NSString *) getDocumentFolder;
@end

#define DBFileName (@"FTS.sqlite")

@implementation TTViewController
@synthesize searchFeild;
@synthesize resultLabel;
@synthesize db;

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (NSString *) getSystemFolder:(NSSearchPathDirectory) dir{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(dir, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
  return basePath;
}

- (NSString *) getDocumentFolder{
	return [self getSystemFolder:NSDocumentDirectory];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  NSString *dbPath = [[self getDocumentFolder] stringByAppendingPathComponent:DBFileName];
  NSFileManager *fm = [NSFileManager defaultManager];
  if (NO == [fm fileExistsAtPath:dbPath]) {
    NSString *originPath = [[NSBundle mainBundle] pathForResource:@"FTS" ofType:@"sqlite"];
    [fm copyItemAtPath:originPath toPath:dbPath error:nil];
  }
  
  self.db = [FMDatabase databaseWithPath:dbPath];
  [self.db open];
  self.db.traceExecution = YES;
}

- (void)viewDidUnload
{
  [self setSearchFeild:nil];
  [self setResultLabel:nil];
  [super viewDidUnload];
  [self.db close];
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
  /* Tonny's NOTE
   * ============
   *
   * See origin: http://www.sqlite.org/fts3.html#section_1_3
   *
   * -- Create an FTS table
   * CREATE VIRTUAL TABLE pages USING fts4(title, body);
   * 
   * -- Insert a row with a specific docid value.
   * INSERT INTO pages(docid, title, body) VALUES(53, 'Home Page', 'SQLite is a software...');
   * 
   * -- Insert a row and allow FTS to assign a docid value using the same algorithm as
   * -- SQLite uses for ordinary tables. In this case the new docid will be 54,
   * -- one greater than the largest docid currently present in the table.
   * INSERT INTO pages(title, body) VALUES('Download', 'All SQLite source code...');
   * 
   * -- Change the title of the row just inserted.
   * UPDATE pages SET title = 'Download SQLite' WHERE rowid = 54;
   * 
   * -- Delete the entire table contents.
   * DELETE FROM pages;
   * 
   * -- The following is an error. It is not possible to assign non-NULL values to both
   * -- the rowid and docid columns of an FTS table.
   * INSERT INTO pages(rowid, docid, title, body) VALUES(1, 2, 'A title', 'A document body');
   * 
   */

  FMResultSet *tableExistRS = [self.db executeQuery:@"SELECT name FROM sqlite_master WHERE type='table' AND name='edict';"];
  if (NO == [tableExistRS next]) {
    [self.db beginTransaction];
    BOOL tableCreated = [self.db executeUpdate:@"CREATE VIRTUAL TABLE edict USING fts4(word, body);"];
    if (tableCreated == NO) {
      self.resultLabel.text = [NSString stringWithFormat:@"*** Failed: %d (%@)", [self.db lastErrorCode], [self.db lastErrorMessage]];
      return;
    }else{
      self.resultLabel.text = @"OK, Virtual Table created.";
    }
    [self.db commit];
  }

  FMResultSet *existRecords = [self.db executeQuery:@"SELECT * FROM edict WHERE rowid = 1;"];
  if (NO == [existRecords next]) {
    [self.db beginTransaction];
    FileReader *txtFileReader = [[FileReader alloc] initWithFilePath:[[NSBundle mainBundle] pathForResource:@"edict2_utf8" ofType:@"txt"]];
    __block int readLines = 0;
    [txtFileReader enumerateLinesUsingBlock:^(NSString *aNewLine, BOOL *stop) {
      if (readLines >= 197000) {
        // Drop the last 18 lines.
        //      [self.db commit];
        FMResultSet *result = [self.db executeQuery:@"SELECT count(*) from edict;"];
        if ([result next]) {
          self.resultLabel.text = [NSString stringWithFormat:@"Result: imported %d records", [result intForColumnIndex:0]];
        }else{
          self.resultLabel.text = @"Result: finished importing, but has no data.";
        }
        *stop = YES;
      }
      @autoreleasepool {
        NSRange firstSlash = [aNewLine rangeOfString:@"/"]; // first occurence of "/"
        if (firstSlash.location != NSNotFound) {
          NSString *word = [aNewLine substringToIndex:firstSlash.location];
          NSString *body = [aNewLine substringFromIndex:firstSlash.location + 1];
          [self.db executeUpdate:@"INSERT INTO edict(word, body) VALUES(?, ?);", word, body];
          if (readLines % 10000 == 0) {
            NSLog(@"Reaches line: %d", readLines);
          }
        }
      }
      readLines++;
    }];
    [self.db commit];
  }else{
    FMResultSet *numberOfRecords = [self.db executeQuery:@"SELECT count(*) FROM edict;"];

    self.resultLabel.text = [NSString stringWithFormat:@"Already has %d records.", [numberOfRecords intForColumnIndex:0]];
  }
  
  
}

- (IBAction)doFTSSearch:(id)sender {
  if ([self.searchFeild.text isEqualToString:@""]) {
    self.resultLabel.text = @"Result: NO keyword";
    return;
  }
  
  /* Tonny's NOTE
   * ============
   *
   * See origin: http://www.sqlite.org/fts3.html#section_1_3
   *
   * -- The examples in this block assume the following FTS table:
   * CREATE VIRTUAL TABLE mail USING fts3(subject, body);
   * 
   * SELECT * FROM mail WHERE rowid = 15;                -- Fast. Rowid lookup.
   * SELECT * FROM mail WHERE body MATCH 'sqlite';       -- Fast. Full-text query.
   * SELECT * FROM mail WHERE mail MATCH 'search';       -- Fast. Full-text query.
   * SELECT * FROM mail WHERE rowid BETWEEN 15 AND 20;   -- Slow. Linear scan.
   * SELECT * FROM mail WHERE subject = 'database';      -- Slow. Linear scan.
   * SELECT * FROM mail WHERE subject MATCH 'database';  -- Fast. Full-text query.
   *
   */

  NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
  FMResultSet *result = [self.db executeQuery:[NSString stringWithFormat:@"SELECT count(*) FROM edict WHERE body MATCH '%@';", self.searchFeild.text]];
  NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];

  while ([result next]) {
    self.resultLabel.text = [NSString stringWithFormat:@"Result: [%6d] hits, using: %.3f seconds", [result intForColumnIndex:0], (endTime - startTime)];
  }
  
}

- (IBAction)doFTSSearchWithJapanese:(id)sender {
}
@end
