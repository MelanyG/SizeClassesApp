//
//  Downloader.m
//  SizeClassesApp
//
//  Created by Melany Gulianovych on 6/16/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import "Downloader.h"


static NSString * const UserURLString = @"http://fv.netau.net/FirstScene.json";

@interface Downloader() <NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property (strong, nonatomic) NSDictionary *dictionary;

- (void)parseProgrammes:(NSDictionary *)responseDictionary;
- (void)compareWithExisting;
- (void)downloadImages:(NSString *)url intoProgramme:(Programme *)program;
- (NSDictionary *)checkForDuplications:(NSDictionary *)response;

@end

@implementation Downloader

- (void)startDownload {
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"recorded"];
    __weak Downloader *weakSelf = self;
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:UserURLString]
                                                         completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                              {
                                     NSMutableDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                  self.dictionary = [self checkForDuplications:responseDictionary];
                                  if([[DBManager sharedManager]coreDataHasEntriesForEntityName]) {
                                      
                                      [weakSelf compareWithExisting];
                                  } else {
                                      
                                      [weakSelf parseProgrammes:self.dictionary];
                                  }
                              }];
    [task resume];
}

#pragma mark - private methods

-(void)parseProgrammes:(NSDictionary *)responseDictionary {
    
    NSInteger qty = [responseDictionary[@"listOfPrograms"] count];
    DBManager *dbManager = [DBManager sharedManager];
    for(int i = 0; i < qty; i++) {
        
        Programme *program = [dbManager createProgramme];
        
        program.name = [responseDictionary [@"listOfPrograms"]objectAtIndex:i][@"title"];
        program.descriptor = [responseDictionary[@"listOfPrograms"]objectAtIndex:i][@"description"];
        NSString *url = [[responseDictionary objectForKey:@"listOfPrograms"]objectAtIndex:i][@"image"];
         [self downloadImages:url intoProgramme:program];
    }
    
    [dbManager saveContext];
   
    if(_delegate && [_delegate respondsToSelector:@selector(downloadingfinished)]) {
        [_delegate downloadingfinished];
    }
    
}

- (void)compareWithExisting {
    NSArray * dic = self.dictionary [@"listOfPrograms"];
    NSInteger qty = [dic count];
    DBManager *manager = [DBManager sharedManager];
    for(int i = 0; i < qty; i++) {
        
        if(![manager hasEntityWithTitle:[dic objectAtIndex:i][@"title"]]) {
            
            Programme *program = [manager createProgramme];
            
            program.name = [dic objectAtIndex:i][@"title"];
            program.descriptor = [dic objectAtIndex:i][@"description"];
            [self downloadImages:[dic objectAtIndex:i][@"image"] intoProgramme:program];
            [[DBManager sharedManager] saveContext];
        }
        
    }
    if(_delegate && [_delegate respondsToSelector:@selector(downloadingfinished)]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_delegate downloadingfinished];
        });
        
    }
}

-(void)downloadImages:(NSString *)url intoProgramme:(Programme *)program {
    NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession]
                                                   downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                       program.image = [NSData dataWithContentsOfURL:location];
                                                       [[DBManager sharedManager] saveContext];
                                                     }];
    [downloadPhotoTask resume];
}

- (NSDictionary *)checkForDuplications:(NSDictionary *)response {
    NSMutableSet *intersection = [NSMutableSet setWithArray:response [@"listOfPrograms"]];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[intersection allObjects] forKey:@"listOfPrograms"];
    return dic;
}


@end
