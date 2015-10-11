//
//  AESEncrypt.h
//  AESEncryption
//
//  Created by N Sankar on 8/2/11.
//  Copyright © 2015 N Sankar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@interface AESEncrypt : NSObject {
    
}

-(NSData *)Encyrpt:(NSString *)plainText ForKey:(NSString*)keyString;
-(NSString *) Decrypt:(NSData *) cipherData ForKey: (NSString*)keyString;
-(NSString *)generateKey : (NSString*)password;

@end
