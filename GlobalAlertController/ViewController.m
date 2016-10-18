//
//  ViewController.m
//  GlobalAlertController
//
//  Created by xdliu on 16/10/18.
//  Copyright © 2016年 derclown. All rights reserved.
//

#import "ViewController.h"
#import "GlobalAlertController.h"

@interface ViewController ()<GlobalAlertControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *selectPictBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [selectPictBtn setTitle:@"选取照片" forState:UIControlStateNormal];
    [selectPictBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    selectPictBtn.frame = CGRectMake(30, 50.0f, self.view.frame.size.width - 60.0f, 50.0f);
    [selectPictBtn addTarget:self action:@selector(selectPict) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectPictBtn];
    
    UIButton *resignBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [resignBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [resignBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    resignBtn.frame = CGRectMake(30, 120, self.view.frame.size.width - 60.0f, 50.0f);
    [resignBtn addTarget:self action:@selector(showResignAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resignBtn];
}

- (void)showResignAlert {
    NSAttributedString *titleAttribute = [[NSAttributedString alloc] initWithString:@"下次登陆依然可以使用本账号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor colorWithWhite:0 alpha:0.5]}];
    NSAttributedString *cancelAttribute = [[NSAttributedString alloc] initWithString:@"取消" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName:[UIColor colorWithWhite:0 alpha:0.95]}];
    NSAttributedString *resignAttribute = [[NSAttributedString alloc] initWithString:@"退出登录" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName:[UIColor redColor]}];
    GlobalAlertController *alertController = [[GlobalAlertController alloc] initWithAttributeTitle:titleAttribute delegate:self cancelButtonAttributeTitle:cancelAttribute otherButtonAttributeTitles:resignAttribute, nil];
    [alertController showAlertController];
}

- (void)selectPict {
    GlobalAlertController *alertController = [[GlobalAlertController alloc] initWithDelegate:self otherButtonTitles:@"拍照", @"从手机相册选取", @"保存图片", nil];
    [alertController showAlertController];
}

#pragma mark - GlobalAlertControllerDelegate

- (void)alertController:(GlobalAlertController *)alertController clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            NSLog(@"拍照");
        }
            break;
        case 1: {
            NSLog(@"相册");
        }
            break;
        case 2: {
            NSLog(@"保存照片");
        }
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
