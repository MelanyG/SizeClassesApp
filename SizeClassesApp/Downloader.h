//
//  Downloader.h
//  SizeClassesApp
//
//  Created by Melany Gulianovych on 6/16/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DBManager.h"

@protocol DownloaderDelegate <NSObject>

- (void)downloadingfinished;

@end

@interface Downloader : NSObject

@property (nonatomic, weak) id <DownloaderDelegate> delegate;

- (void)startDownload;

@end
