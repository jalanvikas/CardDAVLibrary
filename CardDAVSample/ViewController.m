//
//  ViewController.m
//  CardDAVSample
//
//  Created by Vikas Jalan on 1/14/16.
//  Copyright © 2016 Vikas Jalan. All rights reserved.
//

#import "ViewController.h"
#import "CardDAVManager.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *syncingStatus;

@property (nonatomic, weak) IBOutlet UITextField *userName;
@property (nonatomic, weak) IBOutlet UITextField *password;
@property (nonatomic, weak) IBOutlet UITextField *baseURL;
@property (nonatomic, weak) IBOutlet UIButton *syncButton;
@property (nonatomic, weak) IBOutlet UITextView *response;

#pragma mark - Action Methods

- (IBAction)syncButtonClicked:(id)sender;

#pragma mark - Notification Handler Methods

- (void)syncStarted:(NSNotification *)notification;

- (void)syncFailed:(NSNotification *)notification;

- (void)syncCompleted:(NSNotification *)notification;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.syncButton.layer.cornerRadius = 10.0;
    self.syncButton.layer.borderColor = self.syncButton.titleLabel.textColor.CGColor;
    self.syncButton.layer.borderWidth = 1.0;
    
    self.response.layer.cornerRadius = 5.0;
    self.response.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.response.layer.borderWidth = 1.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(syncStarted:)
                                                 name:CARD_DAV_SYNC_STARTED_NOTIFICATION
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(syncFailed:)
                                                 name:CARD_DAV_SYNC_FAILED_NOTIFICATION
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(syncCompleted:)
                                                 name:CARD_DAV_SYNC_COMPLETED_NOTIFICATION
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Action Methods

- (IBAction)syncButtonClicked:(id)sender
{
    [self.syncingStatus setText:@""];
    [[CardDAVManager sharedInstance] startSyncingForUserName:self.userName.text
                                                withPassword:self.password.text
                                                     baseURL:self.baseURL.text];
}

#pragma mark - Notification Handler Methods

- (void)syncStarted:(NSNotification *)notification
{
    [self.syncingStatus setText:@"Sync Started..."];
}

- (void)syncFailed:(NSNotification *)notification
{
    [self.syncingStatus setText:@"Sync Failed"];
    [self.response setText:[[CardDAVManager sharedInstance] getErrorInfo]];
}

- (void)syncCompleted:(NSNotification *)notification
{
    [self.syncingStatus setText:@"Sync Completed"];
    [self.response setText:[[CardDAVManager sharedInstance] getResponse]];
}

@end
