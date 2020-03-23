//
//  RecordViewController.m
//  BabyDaily
//
//  Created by marco on 8/17/16.
//  Copyright © 2016 marco. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()

@end

@implementation RecordViewController
- (instancetype)initWithTitle:(NSString *)tite
{
    self = [super init];
    if (self) {
        self.title = tite;
        self.tabbarItem = [[TTTabbarItem alloc] initWithTitle:self.title titleColor:Color_Gray146 selectedTitleColor:Color_Yellow icon:nil selectedIcon:nil];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ( !self.tabbarItem ) {
            self.tabbarItem = [[TTTabbarItem alloc] initWithTitle:@"记录成长" titleColor:Color_Gray146 selectedTitleColor:Color_Yellow icon:nil selectedIcon:nil];
        }
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
