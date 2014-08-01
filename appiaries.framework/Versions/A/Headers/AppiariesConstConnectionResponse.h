//
//  AppiariesConstConnectionResponse.h
//  appiaries
//
//  Created by t_kaifuku on 2014/04/22.
//  Copyright (c) 2014年 t_kaihuku. All rights reserved.
//

#ifndef appiaries_AppiariesConstConnectionResponse_h
#define appiaries_AppiariesConstConnectionResponse_h

/**
 * appiaries api 通信レスポンスコード
 */

/// Success
#define APPIARIES_RESPONSE_SUCCESS  204
/// Content unspecified, content format invalid
#define APPIARIES_RESPONSE_FORMAT_INVALID   400
/// Token unspecified, Authentication failure
#define APPIARIES_RESPONSE_AUTH_ERROR   401
/// No permission to access the app. No permission to create in the collection. The object that can be stored in the collection is not "JSON Data".
#define APPIARIES_RESPONSE_PERMISSION_ERROR 403
/// Content Value invalid
#define APPIARIES_RESPONSE_VALUE_INVALID    422
/// Unexpected error
#define APPIARIES_RESPONSE_UNEXPECTED_ERROR 500
/// Available storage capacity exceeded
#define APPIARIES_RESPONSE_STORAGE_OVER 507

/// connection error
#define HTTP_CONNECTION_ERROR   1001

/// invalid id
#define APPIARIES_INVALID_ID    -1

#endif
