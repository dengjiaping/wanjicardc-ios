//
//  CacheManager.h
//  SportsServicer
//
//  Created by Gang Li on 3/18/15.
//  Copyright (c) 2015 LeTV Sports Culture Develop (Beijing) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, CachePolicy) {
    /**
     * This policy will not use any caching, and will execute every request online.
     *
     * Use this policy if your application is dependant on data that is shared between multiple
     * users and always needs to be up to date.
     */
    
    NOCACHE = 0x0001,
    
    /**
     *  This policy will only retrieve data from the cache, and will not use any network connection.
     *
     *  Use this policy in combination with another policy, to allow for quick response times
     *  without requiring a network connection for specific operations.
     */
    
    CACHEONLY = NOCACHE << 1,
    
    /**
     * This policy will first attempt to retrieve data from the cache.
     * If the data has been cached, it will be returned. If the data does not exist in the cache,
     * the data will be retrieved from Kinvey's Backend and the cache will be updated.
     *
     * Use this policy if your application can display data that doesn't change very often but you
     * still want local updates.
     *
     */
    
    CACHEFIRST = NOCACHE << 2,
    
    /**
     * This policy will first attempt to retrieve data from the cache. If the data has been cached,
     * it will be returned. If the data does not exist in the cache,
     * the data will be retrieved from Kinvey's Backend but the cache will not be updated with the new results.
     *
     * Use this policy if you want to set default results, however if a request is made that cannot return
     * these defaults a live request will be made (without modifying those default values)
     */
    
    CACHEFIRST_NOREFRESH = NOCACHE << 3,
    
    /**
     * This policy will execute the request on the network, and will store the result in the cache.
     * If the online execution fails, the results will be pulled from the cache.
     *
     * Use this policy if you application wants the latest data but you still want responsiveness
     * if a connection is lost
     */
    
    NETWORKFIRST = NOCACHE << 4,
    
    /**
     * This policy will first retrieve an element from the cache, and then it will attempt to
     * execute the request on line. This caching policy will make two calls to the KinveyClientCallback,
     * either onSuccess or onFailure for both executing on the cache as well as executing online.
     *
     * Use this policy if you want more responsiveness without sacrificing the consistency of
     * data with your backend.
     */
    
    BOTH = NOCACHE << 5
};
