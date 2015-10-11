About:

1. A simple library to perform AES encrption and decryption.

2. It also has a component to generate PBKDF2 key.

How to use:

1. Create an instance for AESEncrypt which is our library.
AESEncrypt *encryptionLibrary = [[AESEncrypt alloc]init];

2. Create the data to be encrypted as NSString.
NSString *dataToBeEncrypted = @"Data to be Encrypted";
NSLog(@"Data to be encrypted = %@", dataToBeEncrypted);

3. Create PBKDF2 key (which is provided along with the project) or any other valid 128 bit key.
NSString *key = [encryptionLibrary generateKey:@"password"];
Note: please provide corresponding password.

4. Pass these two parameters to encrypt method.
NSData *encryptedData = [encryptionLibrary Encyrpt:dataToBeEncrypted ForKey:key];

5. To decrypt send the encrypted data and key to decrypt method.
NSString *decryptedData = [encryptionLibrary Decrypt:encryptedData ForKey:key];
NSLog(@"decryptedData = %@", decryptedData);

P.S : Code is java compatible and tested with Java systems.