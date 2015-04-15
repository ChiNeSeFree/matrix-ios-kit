/*
 Copyright 2015 OpenMarket Ltd

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "MXKDataSource.h"

#import "MXKCellData.h"
#import "MXKCellRendering.h"

@interface MXKDataSource () {
    /**
     The mapping between cell identifiers and MXKCellData classes.
     */
    NSMutableDictionary *cellDataMap;

    /**
     The mapping between cell identifiers and MXKCellRendering classes.
     */
    NSMutableDictionary *cellViewMap;
}
@end

@implementation MXKDataSource
@synthesize state;

#pragma mark - Life cycle
- (instancetype)initWithMatrixSession:(MXSession *)matrixSession {

    self = [super init];
    if (self) {
        _mxSession = matrixSession;
        state = MXKDataSourceStatePreparing;
        cellDataMap = [NSMutableDictionary dictionary];
        cellViewMap = [NSMutableDictionary dictionary];

        // Listen to MXSession state changes
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didMXSessionStateChange:) name:kMXSessionStateDidChangeNotification object:nil];
    }
    return self;
}

- (void)destroy {
    
    _mxSession = nil;
    _delegate = nil;

    [self cancelAllRequests];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    cellDataMap = nil;
    cellViewMap = nil;
    state = MXKDataSourceStateUnknown;
}

#pragma mark - MXSessionStateDidChangeNotification
- (void)didMXSessionStateChange:(NSNotification *)notif {

    // Check this is our Matrix session that has changed
    if (notif.object == _mxSession) {
        [self didMXSessionStateChange];
    }
}

- (void)didMXSessionStateChange {

    // The inherited class is highly invited to override this method for its business logic
}


#pragma mark - MXKCellData classes
- (void)registerCellDataClass:(Class)cellDataClass forCellIdentifier:(NSString *)identifier {

    // Sanity check: accept only MXKCellData classes or sub-classes
    NSParameterAssert([cellDataClass isSubclassOfClass:MXKCellData.class]);

    cellDataMap[identifier] = cellDataClass;
}

- (Class)cellDataClassForCellIdentifier:(NSString *)identifier {

    return cellDataMap[identifier];
}


#pragma mark - MXKCellRendering classes
- (void)registerCellViewClass:(Class<MXKCellRendering>)cellViewClass forCellIdentifier:(NSString *)identifier {

    cellViewMap[identifier] = cellViewClass;
}

- (Class<MXKCellRendering>)cellViewClassForCellIdentifier:(NSString *)identifier {

    return cellViewMap[identifier];
}


#pragma mark - MXKCellRenderingDelegate
- (void)cell:(id<MXKCellRendering>)cell didRecognizeAction:(NSString*)actionIdentifier userInfo:(NSDictionary *)userInfo {

    // The data source simply relays the information to its delegate
    if (_delegate && [_delegate respondsToSelector:@selector(dataSource:didRecognizeAction:inCell:userInfo:)]) {

        [_delegate dataSource:self didRecognizeAction:actionIdentifier inCell:cell userInfo:userInfo];
    }
}


#pragma mark - Pending HTTP requests
/**
 Cancel all registered requests.
 */
- (void)cancelAllRequests {

    NSLog(@"[MXKDataSource] cancelAllRequests: TODO");
}

@end
