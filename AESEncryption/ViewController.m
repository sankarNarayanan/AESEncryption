//
//  ViewController.m
//  AESEncryption
//
//  Created by N Sankar on 12/10/15.
//  Copyright © 2015 N Sankar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AESEncrypt *encryptionLibrary = [[AESEncrypt alloc]init];
    NSString *dataToBeEncrypted = @"Data to be Encrypted";
    NSLog(@"Data to be encrypted = %@", dataToBeEncrypted);
    NSString *key = [encryptionLibrary generateKey:@"password"];
    NSData *encryptedData = [encryptionLibrary Encyrpt:dataToBeEncrypted ForKey:key];
    NSString *decryptedData = [encryptionLibrary Decrypt:encryptedData ForKey:key];
    NSLog(@"decryptedData = %@", decryptedData);
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
