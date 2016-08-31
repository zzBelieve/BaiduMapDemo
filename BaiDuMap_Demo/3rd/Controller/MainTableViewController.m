//
//  MainTableViewController.m
//  BaiDuMap_Demo
//
//  Created by ZZBelieve on 16/8/24.
//  Copyright © 2016年 ZZBelieve. All rights reserved.
//

#import "MainTableViewController.h"

@interface MainTableViewController ()


@property(nonatomic,strong)NSArray *dataArray;
@end


@implementation MainTableViewController

- (NSArray *)dataArray{

    
    if (!_dataArray) {
        
        
        _dataArray = @[@"定位,自定义精度圈",@"覆盖物",@"自定义标注,大头针",@"地理编码和反地理编码"];
    }
    
    return _dataArray;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"百度地图Demo";
    
    self.tableView.tableFooterView = [UIView new];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *ID = @"id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSArray *vcArrayNameArray = @[@"LocationViewController",@"OverLayViewController",@"MeiTuanViewController",@"GeoAndReGeoViewController"];
    
    NSString *vcName = vcArrayNameArray[indexPath.row];
    
    
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    vc.title = self.dataArray[indexPath.row];;
    [self.navigationController pushViewController:vc animated:YES];


}
@end
