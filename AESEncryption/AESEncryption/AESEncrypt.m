//
//  AESEncrypt.m
//  AESEncryption1
//
//  Created by N Sankar on 8/2/11.
//  Copyright © 2015 N Sankar. All rights reserved.
//

#import "AESEncrypt.h"

#define ENCRYPT_ALGORITHM kCCAlgorithmAES128
#define ENCRYPT_BLOCK_SIZE kCCBlockSizeAES128
#define ENCRYPT_KEY_SIZE kCCKeySizeAES128

@interface AESEncrypt (private)


@end

@implementation AESEncrypt

-(NSData *)Encyrpt:(NSString *)plainText ForKey:(NSString*)keyString
{
    @try
    {
        NSData *dataToEncrypt=[plainText dataUsingEncoding:NSUTF8StringEncoding];
        const char myByteArray[] = {
            0x01,0x02,0x03,0x04,
            0x05,0x06,0x07,0x08,
            0x09,0x0a,0x0b,0x0c,
            0x0d,0x0e,0x0f,0x10 };
        NSMutableData *vector = [NSMutableData dataWithBytes: myByteArray length:16];
        NSData *key = [keyString dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableData* result = nil;
        // setup key
        unsigned char cKey[ENCRYPT_KEY_SIZE];
        bzero(cKey, sizeof(cKey));
        [key getBytes:cKey length:ENCRYPT_KEY_SIZE];
        // setup iv
        char cIv[ENCRYPT_BLOCK_SIZE];
        bzero(cIv, ENCRYPT_BLOCK_SIZE);
        if (vector) {
            [vector getBytes:cIv length:ENCRYPT_BLOCK_SIZE];
        }
        
        // setup output buffer
        size_t bufferSize = [dataToEncrypt length] + ENCRYPT_BLOCK_SIZE;
        void *buffer = malloc(bufferSize);
        
        // do encrypt
        size_t encryptedSize = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                              ENCRYPT_ALGORITHM,
                                              kCCOptionPKCS7Padding,
                                              cKey,
                                              ENCRYPT_KEY_SIZE,
                                              cIv,
                                              [dataToEncrypt bytes],
                                              [dataToEncrypt length],
                                              buffer,
                                              bufferSize,
                                              &encryptedSize);
        if (cryptStatus == kCCSuccess) {
            result = [[NSMutableData alloc]initWithData:[NSData dataWithBytesNoCopy:buffer length:encryptedSize]];
        } else {
            free(buffer);
        }
        [vector appendData:result];
        return vector;
    }
    @catch (NSException *error) {
    }
}



-(NSString *) Decrypt:(NSData *) cipherData ForKey: (NSString*)keyString
{
    NSData* decodeddata= cipherData;
    NSData *vector=[decodeddata subdataWithRange:NSMakeRange(0,16)];
    NSData* data4 = [decodeddata subdataWithRange:NSMakeRange(16,[decodeddata length]-16)];
    NSData *key = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    NSData* result = nil;
    // setup key
    unsigned char cKey[ENCRYPT_KEY_SIZE];
    bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:ENCRYPT_KEY_SIZE];
    // setup iv
    char cIv[ENCRYPT_BLOCK_SIZE];
    bzero(cIv, ENCRYPT_BLOCK_SIZE);
    if (vector) {
        [vector getBytes:cIv length:ENCRYPT_BLOCK_SIZE];
    }
    // setup output buffer
    size_t bufferSize = [data4 length] + ENCRYPT_BLOCK_SIZE;
    void *buffer = malloc(bufferSize);
    // do decrypt
    size_t decryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          ENCRYPT_ALGORITHM,
                                          kCCOptionPKCS7Padding,
                                          cKey,
                                          ENCRYPT_KEY_SIZE,
                                          cIv,
                                          [data4 bytes],
                                          [data4 length],
                                          buffer,
                                          bufferSize,
                                          &decryptedSize);
    
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:decryptedSize];
    }else if(cryptStatus == kCCBufferTooSmall) {
        char * ccKey = [key bytes];
        NSUInteger dataLength = [data4 length];
        uint8_t unencryptedData[dataLength + kCCKeySizeAES128];
        size_t unencryptedLength;
        
        CCCrypt(kCCDecrypt, kCCAlgorithmAES128, 0, ccKey, kCCKeySizeAES128, cIv, [data4 bytes], dataLength, unencryptedData, dataLength, &unencryptedLength);
        NSString *output = [[NSString alloc] initWithBytes:unencryptedData length:unencryptedLength encoding:NSUTF8StringEncoding];
        result = [output dataUsingEncoding:NSUTF8StringEncoding];
    }
    else {
        free(buffer);
    }
    NSString *decodedString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    return decodedString;
}


-(NSString *)generateKey : (NSString*)password{
    @try{
        NSData *saltData=[[NSData alloc]initWithData:[self generateSalt256]];
        NSString* myPass = password;
        
        unsigned char key[16];
        int result= CCKeyDerivationPBKDF(kCCPBKDF2, myPass.UTF8String, myPass.length, saltData.bytes, saltData.length, kCCPRFHmacAlgSHA256,10000, key,16);
        
        if(result ==0){
            NSData* data = [NSData dataWithBytes:(const void *)key length:sizeof(unsigned char)*16];
            NSString *generatedKey =[[NSString alloc]initWithString:[data base64EncodedStringWithOptions:0]];
            return   generatedKey;
        }
        else{
            return   nil;
        }
    }
    @catch (NSException * exp) {
    }
}


- (NSData*)generateSalt256 {
    unsigned char salt[32];
    for (int i=0; i<32; i++) {
        salt[i] = (unsigned char)arc4random();
    }
    return [NSData dataWithBytes:salt length:32];
}


@end