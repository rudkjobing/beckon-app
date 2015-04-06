//
//  CreateBeckonStep3VC.m
//  Beckon
//
//  Created by Steffen Rudkjøbing on 04/01/15.
//  Copyright (c) 2015 Beckon IVS. All rights reserved.
//

#import "CreateBeckonStep3VC.h"
#import "CreateBeckonSwipeVC.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface CreateBeckonStep3VC ()

@property (strong, nonatomic) UIBarButtonItem *previousButton;
@property (strong, nonatomic) UIBarButtonItem *doneButton;
@property (strong, nonatomic) CreateBeckonSwipeVC *swipeVC;
@property (assign, nonatomic) BOOL isSearching;
@property (strong, nonatomic) NSString *searchedText;
@property (strong, nonatomic) NSArray *searchResults;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightTextFieldConstraint;

@end

@implementation CreateBeckonStep3VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.swipeVC = (CreateBeckonSwipeVC*)self.parentViewController.parentViewController;
    self.isSearching = NO;
    self.navigationItem.title = @"Location";
    
    self.table.dataSource = self;
    self.table.delegate = self;
    
    self.previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self  action:@selector(previous)];
    self.previousButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = self.previousButton;
    
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.doneButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
}

- (void) previous{
    [self.swipeVC swipeToPrevious:self.parentViewController sender:self];
}

- (void) done{
    NSLog(@"%@", self.swipeVC.beckon);
    [self.swipeVC dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)searchChangedAction:(id)sender {
 
    if(!self.isSearching && self.searchTextField.text.length > 2){
        
        self.isSearching = YES;
        self.searchedText = self.searchTextField.text;
        
        MKLocalSearchRequest* request = [[MKLocalSearchRequest alloc] init];
        request.naturalLanguageQuery = self.searchTextField.text;
        request.region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate, 0.5, 0.5);
        
        MKLocalSearch* search = [[MKLocalSearch alloc] initWithRequest:request];
        [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
            self.searchResults = response.mapItems;
            [self.table reloadData];
            self.isSearching = NO;
            if(![self.searchTextField.text isEqualToString:self.searchedText]){
//                [self searchForLocations];
            }
        }];
    }
    
}

- (IBAction)searchInitAction:(id)sender {
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.rightTextFieldConstraint.constant += 60.0f;
                         self.table.layer.hidden = NO;
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         self.cancelButton.hidden = NO;
                     }];
}

- (IBAction)SearchCanceledAction:(id)sender {
    [self.searchTextField endEditing:YES];
    [self resignFirstResponder];
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.cancelButton.hidden = YES;
                         self.rightTextFieldConstraint.constant -= 60.0f;
                         self.table.layer.hidden = YES;
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu", self.searchResults.count);
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"SearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    MKMapItem *searchResult = [self.searchResults objectAtIndex:indexPath.row];
    NSString *addressString = @"";
    if(searchResult.placemark.thoroughfare){
        addressString = [addressString stringByAppendingString:searchResult.placemark.thoroughfare];
        addressString = [addressString stringByAppendingString:@" "];
    }
    if(searchResult.placemark.subThoroughfare){
        addressString = [addressString stringByAppendingString:searchResult.placemark.subThoroughfare];
        addressString = [addressString stringByAppendingString:@", "];
    }
    if(searchResult.placemark.locality){
        addressString = [addressString stringByAppendingString:searchResult.placemark.locality];
        addressString = [addressString stringByAppendingString:@", "];
    }
    if(searchResult.placemark.administrativeArea){
        addressString = [addressString stringByAppendingString:searchResult.placemark.administrativeArea];
    }
    cell.textLabel.text = addressString;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
