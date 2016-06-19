//
//  TitleVC.m
//  SizeClassesApp
//
//  Created by Melany Gulianovych on 6/18/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import "TitleVC.h"

@interface TitleVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end



@implementation TitleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.program.name;
    self.titleLable.text = self.program.name;
    self.textView.text = self.program.descriptor;
    self.imageView.image = [UIImage imageWithData:self.program.image scale:1.0];


}
@end
