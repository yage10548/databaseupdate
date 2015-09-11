//
//  ViewController.m
//  databaseupdate
//
//  Created by eric wang on 15/9/10.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "ViewController.h"
#import "smartLiteSqlBase.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
#if TARGET_IPHONE_SIMULATOR
    // From: http://pinkstone.co.uk/where-is-the-documents-directory-for-the-ios-8-simulator/
    NSLog(@"\n\n\nSimulator Documents Directory:\n%@\n\n\n",
          [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                  inDomains:NSUserDomainMask] lastObject]);
#endif
    
    [smartLiteSqlBase shareMyDdataBase];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
