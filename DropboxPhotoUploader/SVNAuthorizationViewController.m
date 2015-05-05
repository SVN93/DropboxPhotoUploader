//
//  SVNAuthorizationViewController.m
//  DropboxPhotoUploader
//
//  Created by Vladislav on 05.05.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import "SVNAuthorizationViewController.h"

@interface SVNAuthorizationViewController () 
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation SVNAuthorizationViewController

#pragma mark - SVNMainController life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Buttons

- (IBAction)loginButtonPressed:(UIButton *)sender {
    
}

- (IBAction)tapOnVC:(id)sender {
    if ([self.loginTextField isFirstResponder]) {
        [self.loginTextField resignFirstResponder];
    }
    
    if ([self.passwordTextField isFirstResponder]) {
        [self.passwordTextField resignFirstResponder];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
