//
//  TTViewController.h
//  sqliteFTSTest
//
//  Created by Tonny Xu on 12/11/11.
//
//  Copyright 2011 Tonny Xu (http://www.totodotnet.net)
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface TTViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *searchFeild;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (strong, nonatomic) FMDatabase *db;

- (IBAction)readinRecords:(id)sender;
- (IBAction)doFTSSearch:(id)sender;
- (IBAction)doFTSSearchWithJapanese:(id)sender;
@end
