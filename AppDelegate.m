//
//  AppDelegate.m
//  ServerSync
//
//  Created by Joseph Malle on 3/16/16.
//  Copyright © 2016 Joseph Malle. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (strong, nonatomic) NSStatusItem *statusItem;

@property (assign, nonatomic) BOOL darkModeOn;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Insert code here to initialize your application
  self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  _statusItem.image = [NSImage imageNamed:@"server.png"];
  [_statusItem setAction:@selector(itemClicked:)];
}

- (void)itemClicked:(id)sender {
  int pid = [[NSProcessInfo processInfo] processIdentifier];
  NSPipe *pipe = [NSPipe pipe];
  NSFileHandle *file = pipe.fileHandleForReading;

  NSTask *task = [[NSTask alloc] init];
  task.launchPath = @"/usr/bin/rsync";
  // these would change...
  task.arguments = @[@"-avzp", @"/Users/malle/Desktop/site", @"root@hashtagmap.website:/var/www/html2"];
  task.standardOutput = pipe;
  [task launch];
  NSData *data = [file readDataToEndOfFile];
  [file closeFile];
  NSString *grepOutput = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
  NSAlert * alert = [NSAlert alertWithMessageText:@"Bat signal acknowledged" defaultButton:@"Alright!" alternateButton:nil otherButton:nil informativeTextWithFormat:grepOutput];
  [alert runModal];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
  [NSApp terminate:self];
}



@end
