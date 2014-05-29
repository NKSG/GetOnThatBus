//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Richard Fellure on 5/28/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "DetailViewController.h"


@interface ViewController ()<MKMapViewDelegate,UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property NSArray *stopArray;
@property NSDictionary *selectedDictionary;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        NSError *jSonError = nil;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:&jSonError];
        self.stopArray = [jsonDictionary objectForKey:@"row"];


        for (NSDictionary *stop in self.stopArray)
        {

            double latitude = [stop[@"latitude"]doubleValue];
            double longitude = [stop[@"longitude"]doubleValue];

            if (longitude > 0)
            {
                double fixedDouble = longitude * -1;
                longitude = fixedDouble;
            }
            NSString *title = stop[@"cta_stop_name"];

            MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
            CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
            annotation.coordinate = locationCoordinate;
            annotation.title = title;
            annotation.subtitle = stop[@"routes"];

            [self.mapView addAnnotation:annotation];
            [self.tableView reloadData];

        }
        [self.mapView showAnnotations:self.mapView.annotations animated:YES];

    }];




}

-(void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    for (NSDictionary *dictionary in self.stopArray) {
        if (view.annotation.title == dictionary[@"cta_stop_name"]) {
            self.selectedDictionary = dictionary;
            break;
        }
    }
    [self performSegueWithIdentifier:@"ShowDetail" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

        DetailViewController *nextViewController = segue.destinationViewController;

    if ([segue.identifier isEqual:@"ShowDetail"])
    {
        nextViewController.detailDictionary = self.selectedDictionary;
    }

    else
    {
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        NSDictionary *selectedDictionary = [self.stopArray objectAtIndex:selectedIndexPath.row];
        nextViewController.detailDictionary = selectedDictionary;
    }
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];

    NSArray *metraArray = [[NSArray alloc]init];
    NSArray *paceArray = [[NSArray alloc]init];

    for (NSDictionary *stop in self.stopArray)
    {
       
        if ([stop[@"inter_modal"]  isEqual: @"Metra"])
        {
            metraArray = [NSArray arrayWithObject:stop];

            for (NSDictionary *metraStops in metraArray)
            {
                if (annotation.title == metraStops[@"cta_stop_name"])
                {
                    pin.pinColor = MKPinAnnotationColorGreen;
                }
            }
        }

        if ([stop[@"inter_modal"] isEqual:@"Pace"])
        {
            paceArray = [NSArray arrayWithObject:stop];
            for (NSDictionary *paceStops in paceArray)
            {
                if (annotation.title == paceStops[@"cta_stop_name"])
                {
                pin.pinColor = MKPinAnnotationColorPurple;
                }
            }
        }

    }
    return pin;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stopArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    NSDictionary *stopDictionary = [self.stopArray objectAtIndex:indexPath.row];

    cell.textLabel.text = stopDictionary[@"cta_stop_name"];
    cell.detailTextLabel.text = stopDictionary[@"routes"];
    return cell;
}
- (IBAction)segmentedButton:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 1)
    {
        [self.mapView setHidden:YES];

    }
    else if (sender.selectedSegmentIndex == 0)
    {
        [self.mapView setHidden:NO];
    }
}


@end
