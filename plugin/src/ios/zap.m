/********* zap.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

#import "zap.h"

@interface zap : CDVPlugin {
  // Member variables go here.
}

+ (NSDictionary*)txDict:(struct tx_t)tx;
+ (CDVPluginResult*)error;

- (void)pluginInitialize;

- (void)version:(CDVInvokedUrlCommand*)command;
- (void)nodeGet:(CDVInvokedUrlCommand*)command;
- (void)nodeSet:(CDVInvokedUrlCommand*)command;
- (void)networkGet:(CDVInvokedUrlCommand*)command;
- (void)networkSet:(CDVInvokedUrlCommand*)command;
- (void)mnemonicCreate:(CDVInvokedUrlCommand*)command;
- (void)mnemonicCheck:(CDVInvokedUrlCommand*)command;
- (void)mnemonicWordlist:(CDVInvokedUrlCommand*)command;
- (void)seedAddress:(CDVInvokedUrlCommand*)command;
- (void)addressCheck:(CDVInvokedUrlCommand*)command;
- (void)addressBalance:(CDVInvokedUrlCommand*)command;
- (void)addressTransactions:(CDVInvokedUrlCommand*)command;
- (void)transactionFee:(CDVInvokedUrlCommand*)command;
- (void)transactionCreate:(CDVInvokedUrlCommand*)command;
- (void)transactionBroadcast:(CDVInvokedUrlCommand*)command;
- (void)uriParse:(CDVInvokedUrlCommand*)command;
@end

@implementation zap
{
    dispatch_queue_t network_queue;
}

+ (NSDictionary*)txDict:(struct tx_t)tx
{
    return @{
             @"type" : [NSNumber numberWithUnsignedLongLong:tx.type],
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

+ (CDVPluginResult*)error
{
    int c_code;
    const char *c_msg;
    lzap_error(&c_code, &c_msg);
    NSDictionary *err = @{
                         @"code" : [NSNumber numberWithInt:c_code],
                         @"message" : [NSString stringWithUTF8String:c_msg],
                        };
    return [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:err];
}

- (void)pluginInitialize
{
    [super pluginInitialize];
    network_queue = dispatch_queue_create("network requests", NULL);
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

    if (url != nil) {
        const char *c_url = [url cStringUsingEncoding:NSUTF8StringEncoding];
        lzap_node_set(c_url);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)networkGet:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    char c_network = lzap_network_get();
    NSString *network = [NSString stringWithFormat:@"%c", c_network];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:network];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)networkSet:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString *network = [command.arguments objectAtIndex:0];
    if (network != nil && [network length] == 1) {
        char c_network = [network characterAtIndex:0];
        if (lzap_network_set(c_network))
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        else
            pluginResult = [zap error];
    } else
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

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
    } else
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

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
    } else
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)mnemonicWordlist:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    const char* const* c_words = lzap_mnemonic_wordlist();
    NSMutableArray *words = [NSMutableArray array];
    while (*c_words)
    {
        const char *c_word = *c_words;
        NSString *word = [NSString stringWithUTF8String:c_word];
        [words addObject:word];
        c_words++;
    }
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:words];
    
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
    } else
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)addressCheck:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    NSString* address = [command.arguments objectAtIndex:0];

    if (address != nil && [address length] > 0) {
        const char *c_address = [address cStringUsingEncoding:NSUTF8StringEncoding];
        struct int_result_t result = lzap_address_check(c_address);
        if (result.success)
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:result.value];
        else
            pluginResult = [zap error];
    } else
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)addressBalance:(CDVInvokedUrlCommand*)command
{
    dispatch_async(network_queue, ^{ 

        CDVPluginResult* pluginResult = nil;

        NSString* address = [command.arguments objectAtIndex:0];

        if (address != nil && [address length] > 0) {
            const char *c_address = [address cStringUsingEncoding:NSUTF8StringEncoding];
            struct int_result_t result = lzap_address_balance(c_address);
            if (result.success)
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:result.value];
            else
                pluginResult = [zap error];
        } else
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    });
}

- (void)addressTransactions:(CDVInvokedUrlCommand*)command
{
    dispatch_async(network_queue, ^{ 

        CDVPluginResult* pluginResult = nil;

        NSString *address = [command.arguments objectAtIndex:0];
        NSNumber *limit = [command.arguments objectAtIndex:1];
        NSString *after = [command.arguments objectAtIndex:2];

        if (address != nil && [address length] > 0) {
            const char *c_address = [address cStringUsingEncoding:NSUTF8StringEncoding];
            NSMutableData* data = [NSMutableData dataWithLength:sizeof(struct tx_t) * limit.intValue];
            struct tx_t *txs = [data mutableBytes];
            if (!txs)
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            else {
                struct int_result_t result;
                if (after != nil && (id)after != [NSNull null] && [after length] > 0) {
                    const char *c_after = [after cStringUsingEncoding:NSUTF8StringEncoding];
                    result = lzap_address_transactions2(c_address, txs, limit.intValue, c_after);
                } else
                    result = lzap_address_transactions(c_address, txs, limit.intValue);
                if (result.success) {
                    NSMutableArray *tx_array = [NSMutableArray array];
                    for (int i = 0; i < result.value; i++) {
                        NSDictionary *tx = [zap txDict:txs[i]];
                        [tx_array addObject:tx];
                    }
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:tx_array];
                }
                else
                    pluginResult = [zap error];
            }
        } else
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    });
}

- (void)transactionFee:(CDVInvokedUrlCommand*)command
{
    dispatch_async(network_queue, ^{

        CDVPluginResult* pluginResult = nil;

        struct int_result_t result = lzap_transaction_fee();
        if (result.success)
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:result.value];
        else
            pluginResult = [zap error];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    });
}

- (void)transactionCreate:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    NSString *seed = [command.arguments objectAtIndex:0];
    NSString *recipient = [command.arguments objectAtIndex:1];
    NSNumber *amount = [command.arguments objectAtIndex:2];
    NSNumber *fee = [command.arguments objectAtIndex:3];
    NSString *attachment = [command.arguments objectAtIndex:4];

    if (seed != nil  && [seed length] > 0 &&
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
            pluginResult = [zap error];
    } else
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)transactionBroadcast:(CDVInvokedUrlCommand*)command
{
    dispatch_async(network_queue, ^{
        
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
                pluginResult = [zap error];
        } else
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    });
}

- (void)uriParse:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    
    NSString *uri = [command.arguments objectAtIndex:0];
    
    if (uri != nil && [uri length] > 0) {
        const char *c_uri = [uri cStringUsingEncoding:NSUTF8StringEncoding];
        struct waves_payment_request_t c_req = {};
        int result = lzap_uri_parse(c_uri, &c_req);
        if (result) {
            NSDictionary *request = @{
                @"address" : [NSString stringWithUTF8String:c_req.address],
                @"asset_id" : [NSString stringWithUTF8String:c_req.asset_id],
                @"attachment" : [NSString stringWithUTF8String:c_req.attachment],
                @"amount" : [NSNumber numberWithUnsignedLongLong:c_req.amount],
            };
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:request];
        }
        else
            pluginResult = [zap error];
    } else
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
