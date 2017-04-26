//
//  CameraViewController.m
//  MessengerUX
//
//  Created by CPU11815 on 4/25/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CameraViewController.h"
#import "CameraSessionView.h"

@interface CameraViewController () <CACameraSessionDelegate>

@property (nonatomic, strong) CameraSessionView *cameraView;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _cameraView = [[CameraSessionView alloc] initWithFrame:self.view.frame];
    _cameraView.delegate = self;
    [self.view addSubview:_cameraView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - CACameraSessionDelegate

- (void)didCaptureImage:(UIImage *)image {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
