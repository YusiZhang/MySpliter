//
//  FirstPageTableViewController.m
//  ParseSpliter
//
//  Created by Yusi Zhang on 4/28/14.
//  Copyright (c) 2014 08723 A4. All rights reserved.
//

#import "FirstPageTableViewController.h"
#import "Bill.h"

@interface FirstPageTableViewController ()

@end

@implementation FirstPageTableViewController{
    Bill *billObj;
}



//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom the table
//        NSLog(@"init with style");
//        // The className to query on
//        self.parseClassName = @"Bill";
//        
//        // The key of the PFObject to display in the label of the default cell style
//        self.textKey = @"ownee";
//        
//        // The title for this table in the Navigation Controller.
////        self.title = @"Todos";
//        
//        // Whether the built-in pull-to-refresh is enabled
//        self.pullToRefreshEnabled = YES;
//        
//        // Whether the built-in pagination is enabled
//        self.paginationEnabled = YES;
//        
//        // The number of objects to show per page
//        self.objectsPerPage = 5;
//    }
//    return self;
//}

//use initwithcoder if using storyboard
- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Bill";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"ownee";
        
        
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
    NSLog(@"FirstTable view name is %@",_name);
    NSString *pred = [[NSString alloc]initWithFormat:@"owner = 'Yusi Zhang' OR ownee = 'Yusi Zhang'"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:pred];
    NSLog(@"First Table Predicate is %@",predicate.description);
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
    
    if ([ [object objectForKey:@"owner" ] isEqualToString: @"Yusi Zhang" ]) {
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
