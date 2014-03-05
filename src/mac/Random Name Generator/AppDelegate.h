//
//  AppDelegate.h
//  Random Name Generator
//
//  Created by Dylan McAllister on 2/24/14.
//  Copyright (c) 2014 Dylan McAllister. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <math.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *TLabel;
@property (weak) IBOutlet NSButton *TGenButton;
@property (weak) IBOutlet NSMenuItem *TOpenList;
@property (weak) IBOutlet NSButton *listButton;
@property (weak) IBOutlet NSButton *toggleLoopButton;
@property (weak) IBOutlet NSButton *saveNamesButton;
@property (weak) IBOutlet NSMenuItem *saveNamesMenu;
@property (unsafe_unretained) IBOutlet NSWindow *genGroupWindow;
@property (weak) IBOutlet NSButton *GenGroupListsButton;
@property (weak) IBOutlet NSStepper *groupStepper;
@property (weak) IBOutlet NSButton *groupGenAndSave;
@property (weak) IBOutlet NSTextField *groupStepperText;

@property NSDocumentController *theDocCont;

- (void) refreshRand;

- (void) tGenName:(BOOL)isGroup;
- (void) loadList:(NSURL*)url;
- (void) promptList;
- (void) promptSaveList:(BOOL) isGroup;
- (void) saveList:(NSURL*) url:(BOOL) isGroup;
- (NSString*) genNameForGroup;

@property NSMutableArray *tList;
@property NSMutableArray *tGroupList;
@property NSArray *tStartingList;
@property NSMutableArray *tSelectedList;
@property NSMutableArray *tGroupSelectedList;
@property (nonatomic, retain) NSMutableString *printString;
@property BOOL tLoop;
@property NSInteger groupGenStepValue;
@property NSInteger numOfGroups;

@end
