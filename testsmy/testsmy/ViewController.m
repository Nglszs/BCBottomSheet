//
//  ViewController.m
//  testsmy
//
//  Created by 莱昂纳多·迪卡普里奥 on 2024/11/18.
//

#import "ViewController.h"
#import "BottomUpView.h"
@interface ViewController ()
{
    BottomUpView *bottom;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    bottom  = [[BottomUpView  alloc]initWithMinHeight:100 withMidHeight:450 withMaxHeight:800];
    [self.view addSubview:bottom];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击了");
}
@end
