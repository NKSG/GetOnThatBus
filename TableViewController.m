//
//  TableViewController.m
//  GetOnThatBus
//
//  Created by Richard Fellure on 5/28/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "TableViewController.h"
#import "DetailViewController.h"

@interface TableViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", self.stopsArray);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stopsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    NSDictionary *stops = [self.stopsArray objectAtIndex:indexPath.row];

    cell.textLabel.text = stops[@"cta_stop_name"];
    cell.detailTextLabel.text = stops[@"route"];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
    DetailViewController *nextViewController = segue.destinationViewController;
    NSDictionary *dictionary = [self.stopsArray objectAtIndex:selectedIndexPath.row];

    nextViewController.detailDictionary = dictionary;

}

@end
