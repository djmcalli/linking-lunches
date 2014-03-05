//
//  AppDelegate.m
//  Random Name Generator
//
//  Created by Dylan McAllister on 2/24/14.
//  Copyright (c) 2014 Dylan McAllister. All rights reserved.
//

#import "AppDelegate.h"
@implementation AppDelegate
@synthesize window;
@synthesize TLabel;
@synthesize TGenButton;
@synthesize TOpenList;
@synthesize tList;
@synthesize tGroupList;
@synthesize tStartingList;
@synthesize tSelectedList;
@synthesize tGroupSelectedList;
@synthesize tLoop;
@synthesize printString;
@synthesize theDocCont;
@synthesize genGroupWindow;
@synthesize GenGroupListsButton;
@synthesize groupStepper;
@synthesize groupStepperText;
@synthesize groupGenStepValue;
@synthesize numOfGroups;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    tSelectedList = [[NSMutableArray alloc] init];
    tGroupSelectedList = [[NSMutableArray alloc] init];
    
    [self tGenName:NO];
}

- (IBAction)genStepperClicked:(id)sender {
    // When stepper is changed, change text of textField
    groupGenStepValue = [groupStepper integerValue];
    
    [groupStepperText setIntegerValue:groupGenStepValue];
}

- (IBAction)genStepperTextChanged:(id)sender {
    // When textField in modified and entered, change value of stepper
    groupGenStepValue = [groupStepperText integerValue];
    
    [groupStepper setIntegerValue:groupGenStepValue];
}

- (IBAction)GenGroupListsClicked:(id)sender {
    id testid = nil;
    [genGroupWindow makeKeyAndOrderFront:testid];
}

- (IBAction)genGroupList:(id)sender {
    [self tGenName:YES];
}

- (IBAction)tButtonClicked:(id)sender {
    [self tGenName:NO];
}

- (IBAction)TOpenListClicked:(id)sender {
    [self promptList];
}

- (IBAction)listButton:(id)sender {
    [self promptList];
}

- (IBAction)tLoopButton:(id)sender {
    tLoop = !(tLoop);
}

- (IBAction)savedNamesButton:(id)sender {
    [self promptSaveList:NO];
}

- (IBAction)savedNamesMenu:(id)sender {
    [self promptSaveList:NO];
}

- (void) refreshRand {
    srand(time(0));
}

- (void) tGenName:(BOOL)isGroup {
    if (isGroup == NO) {
        [self refreshRand];
        if ([tList count] <= 0) {
            if (tLoop != true) TLabel.stringValue = @"End of list!";
            else {
                tList = [[NSMutableArray alloc] initWithArray:tStartingList];
                TLabel.stringValue = @"List looped!";
                tSelectedList = [NSMutableArray arrayWithObjects:nil];
            }
        }
        else {
            NSInteger index = (int)(rand() % [tList count]);
            TLabel.stringValue = [NSString stringWithFormat: @"%@", tList[index]];
            [tSelectedList addObject:tList[index]];
            [tList removeObjectAtIndex:index];
        }
    }
    else {
        tGroupList = [[NSMutableArray alloc] initWithArray:tStartingList];
        tGroupSelectedList = [[NSMutableArray alloc] init];
        numOfGroups = ceil((double)[tGroupList count] / (double)[groupStepperText integerValue]);
        TLabel.stringValue = [NSString stringWithFormat: @"%li", (long)numOfGroups];
        if (numOfGroups > 0) {
            for (int i = 0; i < numOfGroups; i ++) {
                NSMutableArray *tGroup = [[NSMutableArray alloc] init];
                for (int j = 0; j < [groupStepperText integerValue]; j ++) {
                    NSString *name = [self genNameForGroup];
                    
                    if ([name isEqual: @"NoMoreSubjects"]) {
                        // Do nothing
                    } else {
                        [tGroup addObject:name];
                        NSLog(@"names: %@", name);
                    }
                }
                [tGroupSelectedList addObject: tGroup];
            }
            NSLog(@"%ld", (long)[tGroupSelectedList count]);
            [self promptSaveList:YES];
        }
    }
}

- (NSString*) genNameForGroup {
    [self refreshRand];
    
    if ([tGroupList count] <= 0) {
        NSLog(@"no more subjects");
        return @"NoMoreSubjects";
    }
    else {
        NSInteger index = (int)(rand() % [tGroupList count]);
        NSString *returnVal = tGroupList[index];
        [tGroupList removeObjectAtIndex:index];
        
        return returnVal;
    }
}

- (void) loadList:(NSURL*)url {
    //pull the content from the file into memory
    NSData* data = [NSData dataWithContentsOfURL:url];
    // add to recently opened files
    [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:[NSURL URLWithString: [url absoluteString]]];
    //convert the bytes from the file into a string
    NSString* string = [[NSString alloc] initWithBytes:[data bytes]
        length:[data length]
        encoding:NSUTF8StringEncoding];
    
    //split the string around newline characters to create an array
    NSString* delimiter = @"\n";
    tList = [[NSMutableArray alloc] initWithArray:[string componentsSeparatedByString:delimiter]];
    tStartingList = [string componentsSeparatedByString:delimiter];
    TLabel.stringValue = @"List loaded!";
    
    tSelectedList = [NSMutableArray arrayWithObjects:nil];
}

- (void) saveList:(NSURL*) url:(BOOL) isGroup {
    // Initialize the NSMutableString already defined in header.
    printString = [[NSMutableString alloc] initWithCapacity:0];
    if (isGroup == NO) {
        // Not a group list
        // Append first line
        [printString appendString:@"Names:\n"];
        // Append each object of tSelectedList (generated names) into seperate lines.
        [printString appendString:[tSelectedList componentsJoinedByString:@"\n"]];
    } else {
        // It's a group list!
        for (int i = 0; i < numOfGroups; i ++) {
            NSString *groupNum = [NSString stringWithFormat:@"Group %ld:\n \t", (long)(i + 1)];
            [printString appendString:groupNum];
            // Append each object of tSelectedList (generated names) into seperate lines.
            [printString appendString:[[tGroupSelectedList objectAtIndex:i] componentsJoinedByString:@"\n \t"]];
            
            // Seperate each group by a line
            [printString appendString:@"\n\n"];
        }
    }
    
    // File location; use URL provided in params
    NSString *filePath_full = [url absoluteString];
    // Now take that URL and make it into a local location. No need for file://localhost prefix.
    NSString *filePath = [filePath_full substringFromIndex:16];
    
    // Start the save process.
    NSError *error;
    
    [printString writeToFile:filePath atomically:YES
                    encoding:NSUTF8StringEncoding error:&error];
}

- (void) promptList {
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    NSArray  * fileTypes = [NSArray arrayWithObjects:@"txt",@"nnt_txt",nil];
    
    [panel setAllowedFileTypes:fileTypes];
    [panel setMessage:@"Select a list of students to load."];
    
    // This method displays the panel and returns immediately.
    // The completion handler is called when the user selects an
    // item or cancels the panel.
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSURL*  theDoc = [[panel URLs] objectAtIndex:0];
            
            // Load text file into Mutable Array.
            [self loadList:theDoc];
        }
    }];
}

- (void) promptSaveList:(BOOL) isGroup {
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setRequiredFileType:@"txt"];
    NSString *titlep = (isGroup == YES? @"Groups":@"Names");
    NSString *titlef = [NSString stringWithFormat:@"Save %@ to File (.txt)", titlep];
    [savePanel setTitle:titlef];
    [savePanel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton)
        {
            [self saveList:[savePanel URL]:isGroup];
            NSLog(@"saved");
        }
    }];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename {
    return YES;
}

@end
