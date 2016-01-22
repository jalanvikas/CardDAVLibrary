//
//  ViewController.m
//  CardDAVSample
//
//  Created by Vikas Jalan on 1/14/16.
//  Copyright © 2016 Vikas Jalan. All rights reserved.
//

#import "ViewController.h"
#import "CardDAVManager.h"

#define USER_NAME       @""
#define PASSWORD        @""
#define BASE_URL        @""

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[CardDAVManager sharedInstance] startSyncingForUserName:USER_NAME
                                                withPassword:PASSWORD
                                                     baseURL:BASE_URL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
