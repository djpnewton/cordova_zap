/********* zap.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

#import "zap.h"

@interface zap : CDVPlugin {
  // Member variables go here.
}

+ (NSDictionary*)txDict:(struct tx_t)tx;

- (void)version:(CDVInvokedUrlCommand*)command;
- (void)nodeGet:(CDVInvokedUrlCommand*)command;
- (void)nodeSet:(CDVInvokedUrlCommand*)command;
- (void)mnemonicCreate:(CDVInvokedUrlCommand*)command;
- (void)mnemonicCheck:(CDVInvokedUrlCommand*)command;
- (void)seedAddress:(CDVInvokedUrlCommand*)command;
- (void)addressBalance:(CDVInvokedUrlCommand*)command;
- (void)addressTransactions:(CDVInvokedUrlCommand*)command;
- (void)transactionFee:(CDVInvokedUrlCommand*)command;
- (void)transactionCreate:(CDVInvokedUrlCommand*)command;
- (void)transactionBroadcast:(CDVInvokedUrlCommand*)command;
@end

@implementation zap

+ (NSDictionary*)txDict:(struct tx_t)tx
{
    return @{
             @"id" : [NSString stringWithUTF8String:tx.id],
             @"sender" : [NSString stringWithUTF8String:tx.sender],
             @"recipient" : [NSString stringWithUTF8String:tx.recipient],
             @"asset_id" : [NSString stringWithUTF8String:tx.asset_id],
             @"fee_asset" : [NSString stringWithUTF8String:tx.fee_asset],
             @"attachment" : [NSString stringWithUTF8String:tx.attachment],
             @"amount" : [NSNumber numberWithUnsignedLongLong:tx.amount],
             @"fee" : [NSNumber numberWithUnsignedLongLong:tx.fee],
             @"timestamp" : [NSNumber numberWithUnsignedLongLong:tx.timestamp]
             };
}

- (void)version:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    int version = lzap_version();
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:version];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)nodeGet:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    const char *c_url = lzap_node_get();
    NSString *url = [NSString stringWithUTF8String:c_url];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:url];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)nodeSet:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* url = [command.arguments objectAtIndex:0];

    if (url != nil && [url length] > 0) {
        const char *c_url = [url cStringUsingEncoding:NSUTF8StringEncoding];
        lzap_node_set(c_url);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)networkGet:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    char c_network = lzap_network_get();
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsChar:network];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)networkSet:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    char network = [command.arguments objectAtIndex:0];
    lzap_network_set(network);
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)mnemonicCreate:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    char c_mnemonic[1024];
    int result = lzap_mnemonic_create(c_mnemonic, 1024);
    if (result) {
        NSString *mnemonic = [NSString stringWithUTF8String:c_mnemonic];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:mnemonic];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)mnemonicCheck:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* mnemonic = [command.arguments objectAtIndex:0];

    if (mnemonic != nil && [mnemonic length] > 0) {
        const char *c_mnemonic = [mnemonic cStringUsingEncoding:NSUTF8StringEncoding];
        int result = lzap_mnemonic_check(c_mnemonic);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:result];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)seedAddress:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    NSString* seed = [command.arguments objectAtIndex:0];

    if (seed != nil && [seed length] > 0) {
        const char *c_seed = [seed cStringUsingEncoding:NSUTF8StringEncoding];
        char c_address[1024];
        lzap_seed_address(c_seed, c_address);
        NSString *address = [NSString stringWithUTF8String:c_address];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:address];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)addressBalance:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    NSString* address = [command.arguments objectAtIndex:0];

    if (address != nil && [address length] > 0) {
        const char *c_address = [address cStringUsingEncoding:NSUTF8StringEncoding];
        struct int_result_t result = lzap_address_balance(c_address);
        if (result.success)
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:result.value];
        else
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)addressTransactions:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    NSString *address = [command.arguments objectAtIndex:0];
    NSNumber *limit = [command.arguments objectAtIndex:1];

    if (address != nil && [address length] > 0) {
        const char *c_address = [address cStringUsingEncoding:NSUTF8StringEncoding];
        NSMutableData* data = [NSMutableData dataWithLength:sizeof(struct tx_t) * limit.intValue];
        struct tx_t *txs = [data mutableBytes];
        if (!txs)
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        else {
            struct int_result_t result = lzap_address_transactions(c_address, txs, limit.intValue);
            if (result.success) {
                NSMutableArray *tx_array = [NSMutableArray array];
                for (int i = 0; i < result.value; i++) {
                    NSDictionary *tx = [zap txDict:txs[i]];
                    [tx_array addObject:tx];
                }
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:tx_array];
            }
            else
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        }
    } else
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)transactionFee:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    struct int_result_t result = lzap_transaction_fee();
    if (result.success)
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:result.value];
    else
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)transactionCreate:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    NSString *seed = [command.arguments objectAtIndex:0];
    NSString *recipient = [command.arguments objectAtIndex:1];
    NSNumber *amount = [command.arguments objectAtIndex:2];
    NSNumber *fee = [command.arguments objectAtIndex:3];
    NSString *attachment = [command.arguments objectAtIndex:4];

    if (seed != nil && [seed length] > 0 &&
        recipient != nil && [recipient length] > 0) {
        const char *c_seed = [seed cStringUsingEncoding:NSUTF8StringEncoding];
        const char *c_recipient = [recipient cStringUsingEncoding:NSUTF8StringEncoding];
        uint64_t c_amount = amount.unsignedLongLongValue;
        uint64_t c_fee = fee.unsignedLongLongValue;
        const char *c_attachment = NULL;
        if (attachment != nil)
            c_attachment = [attachment cStringUsingEncoding:NSUTF8StringEncoding];

        struct spend_tx_t c_spend_tx = lzap_transaction_create(c_seed, c_recipient, c_amount, c_fee, c_attachment);
        if (c_spend_tx.success) {
            NSData *data = [NSData dataWithBytes:c_spend_tx.data length:c_spend_tx.data_size];
            NSData *signature = [NSData dataWithBytes:c_spend_tx.signature length:sizeof(c_spend_tx.signature)];
            NSDictionary *spend_tx = @{
                @"data" : [data base64EncodedStringWithOptions:0],
                @"signature" : [signature base64EncodedStringWithOptions:0],
            };
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:spend_tx];
        } else
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)transactionBroadcast:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    NSDictionary *spendTx = [command.arguments objectAtIndex:0];
    NSString *data = spendTx[@"data"];
    NSString *signature = spendTx[@"signature"];

    if (data != nil && [data length] > 0 &&
        signature != nil && [signature length] > 0) {
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];
        NSData *decodedSignature = [[NSData alloc] initWithBase64EncodedString:signature options:0];
        struct spend_tx_t c_spend_tx = {};
        if (decodedData.length <= sizeof(c_spend_tx.data)) {
            memcpy(c_spend_tx.data, [decodedData bytes], decodedData.length);
            c_spend_tx.data_size = decodedData.length;
        }
        if (decodedSignature.length == sizeof(c_spend_tx.signature))
            memcpy(c_spend_tx.signature, [decodedSignature bytes], decodedSignature.length);
        struct tx_t broadcast_tx;
        int result = lzap_transaction_broadcast(c_spend_tx, &broadcast_tx);
        if (result) {
            NSDictionary *tx = [zap txDict:broadcast_tx];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:tx];
        } else
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
