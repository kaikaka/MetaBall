//
//  ViewController.m
//  KLMetaBall
//
//  Created by xiangkai yin on 16/4/12.
//  Copyright © 2016年 kuailao_2. All rights reserved.
//

#import "ViewController.h"
#import "KLMetaBallCanvas.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableViewList;
@property (weak, nonatomic) IBOutlet KLMetaBallCanvas *KLBallCanvasView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *ID = @"MainTableViewCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  UIView *view = [cell viewWithTag:20];
  [_KLBallCanvasView attach:view];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}

//选中时取消选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
//  [self performSegueWithIdentifier:@"toDetail" sender:nil];
  //    [self.navigationController pushViewController:[[ViewController alloc] init] animated:YES];
}
@end
