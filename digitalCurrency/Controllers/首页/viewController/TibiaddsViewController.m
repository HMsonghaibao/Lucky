//
//  TibiaddsViewController.m
//  digitalCurrency
//
//  Created by Apple on 2019/9/18.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "TibiaddsViewController.h"
#import "AddAddssViewController.h"
#import "addssTableViewCell.h"
@interface TibiaddsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TibiaddsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提币地址";
    [self.tableView registerNib:[UINib nibWithNibName:@"addssTableViewCell" bundle:nil] forCellReuseIdentifier:@"addssTableViewCell"];
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    addssTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addssTableViewCell"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 82;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
#pragma mark-获取首页推荐信息

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (IBAction)addBtnClick:(UIButton *)sender {
    AddAddssViewController *groupVC = [[AddAddssViewController alloc] init];
    groupVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupVC animated:YES];
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
