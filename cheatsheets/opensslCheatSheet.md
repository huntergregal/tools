#openssl Quick encrypt/decrypt w/ password

##Encrypt
* openssl enc -e -aes128 -a -in fileToEncrypt.txt -out Encrypted.enc

##Decrypt
* openssl enc -e -aes128 -a -in Encrypted.enc -out Decrypted.txt
