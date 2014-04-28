//
//  MyTableViewController.m
//  ParseSpliter
//
//  Created by Yusi Zhang on 4/23/14.
//  Copyright (c) 2014 08723 A4. All rights reserved.
//

#import "MyTableViewController.h"
#import "Bill.h"
#import "DetailBillViewController.h"

@interface MyTableViewController ()
   


@end

@implementation MyTableViewController {
     Bill *billObj;
}


//use initwithcoder if using storyboard
- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Bill";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"owner";

        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    billObj = [[Bill alloc]init];
//    billObj.image = [[UIImage alloc]init];
    NSLog(@"Mytable view name is %@",_name);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PFQuery *)queryForTable {
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    NSLog(@"Mytable view name is %@",_name);
    NSString *pred = [[NSString alloc]initWithFormat:@"owner = '%@' OR ownee = '%@'",_name,_name];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:pred];
    NSLog(@"Predicate is %@",predicate.description);
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName predicate:predicate];
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.textLabel.text = [object objectForKey:@"amount"];
   
    if ([ [object objectForKey:@"owner" ] isEqualToString: _name ]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ own you",[object objectForKey:@"ownee"]];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"you own %@",[object objectForKey:@"owner"]];
    }

    
    return cell;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self loadObjects];
        }];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    NSLog(@"Seletced!!");
    [self performSegueWithIdentifier:@"DetailBillViewController" sender:self];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"SEGUE!!");
    if ([segue.identifier isEqualToString:@"DetailBillViewController"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailBillViewController *dvc = [segue destinationViewController];
//        destViewController.recipe = [recipes objectAtIndex:indexPath.row];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        Bill *temp = [[Bill alloc]init];
        temp.image = [[UIImage alloc]init];
        
        temp.owner = [object objectForKey:@"owner"];
        temp.ownee = [object objectForKey:@"ownee"];
        temp.amount = [object objectForKey:@"amount"];
        temp.location = [object objectForKey:@"location"];
        temp.lat =[object objectForKey:@"lat"];
        temp.lon =[object objectForKey:@"lon"];
        temp.time = [object objectForKey:@"createdAt"];
        
        NSData *imagedata = [[object objectForKey:@"image"] getData];
        temp.image = [[UIImage alloc]initWithData:imagedata];
        
        
        NSLog(@"%@",[object objectForKey:@"ownee"]);
        
        
        NSDate *date= [object objectForKey:@"createdAt"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        NSString *stringFromDate = [formatter stringFromDate:date];
        temp.time = stringFromDate;
        
        dvc.billObj = temp;

    }
}



@end
