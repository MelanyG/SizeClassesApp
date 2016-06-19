//
//  ContentTableVC.m
//  SizeClassesApp
//
//  Created by Melany Gulianovych on 6/17/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import "ContentTableVC.h"
#import "CustomCell.h"
#import "DBManager.h"
#import "Downloader.h"
#import "TitleVC.h"

@interface ContentTableVC () <DownloaderDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Programme *programme;
@property ( nonatomic) UIActivityIndicatorView *activityIndicator;

- (void)configureCell:(CustomCell *)cell withObject:(Programme *)object withIndexPath:(NSIndexPath *)index;
- (void)createProgressIndicator;

@end

@implementation ContentTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"News";
    self.managedObjectContext = [[DBManager sharedManager]managedObjectContext];
        [self createProgressIndicator];

        self.tableView.delegate=nil;
        self.tableView.dataSource=nil;
        Downloader *downloader = [Downloader new];
        downloader.delegate = self;
        [downloader startDownload];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    CustomCell *lCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!lCell)
    {
        lCell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
    }
    
    Programme *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self configureCell:lCell withObject:object withIndexPath:indexPath];
    
    return lCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.programme = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"showDetails" sender: indexPath];
    
    
}

#pragma mark - Fetched results controller


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Programme" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    [fetchRequest setFetchBatchSize:20];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject withIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark - private methods

- (void)configureCell:(CustomCell *)cell withObject:(Programme *)object withIndexPath:(NSIndexPath *)index {
    cell.nameLable.text = object.name;
    cell.descriptionLable.text = object.descriptor;
    cell.imageView.image = [UIImage imageWithData:object.image];
}


- (void)createProgressIndicator {
    self.activityIndicator = [[UIActivityIndicatorView alloc]
                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.activityIndicator.center = [[UIApplication sharedApplication] keyWindow].center;
    self.activityIndicator.color = [UIColor blackColor];
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.activityIndicator];
}

#pragma mark - Delegate methods

- (void)downloadingfinished {
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        TitleVC *controller = segue.destinationViewController;
        controller.program = self.programme;
    }
}


@end
