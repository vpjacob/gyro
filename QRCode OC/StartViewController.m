//
//  StartViewController.m
//  QRCode OC
//
//  Created by 董建新 on 2016/12/9.
//  Copyright © 2016年 vpjacob. All rights reserved.
//

#import "StartViewController.h"
#import "ViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];

    UIButton* btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    btn.center = self.view.center;
    
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
   }

-(void)btnClick{
    ViewController* vc = [ViewController new];
    
    [self presentViewController:vc animated:YES completion:nil];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
