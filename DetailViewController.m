//
//  DetailViewController.m
//  GetOnThatBus
//
//  Created by Richard Fellure on 5/28/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;
@property (weak, nonatomic) IBOutlet UILabel *intraModalLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation DetailViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.detailDictionary[@"cta_stop_name"];
    self.routeLabel.text = self.detailDictionary[@"routes"];
    self.addressLabel.text = self.detailDictionary[@"_address"];

    if (self.detailDictionary[@"inter_modal"] != nil) {
        self.intraModalLabel.text = self.detailDictionary[@"inter_modal"];
    }
    else
    {
        self.intraModalLabel.text = @"No Connection";
    }
}



@end
