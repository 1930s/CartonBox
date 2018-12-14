//
//  ApplicationErrorEnum.swift
//  CartonBox
//
//  Created by kay weng on 20/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation

enum AmazonErrorDomain : String{
    case AWSCognitoErrorDomain = "com.amazon.cognito.AWSCognitoErrorDomain";
    case AWSDynamoDBErrorDomain = "com.amazon.dynamodb.AWSDynamoDBErrorDomain"
    case AWSS3ErrorDomain = "com.amazon.s3.AWSS3ErrorDomain"
}


//error code: 2000
enum DynamoDBError: Int{
    case nullModel = 2000
    case getItemFailed = 2001
    case saveItemFailed = 2002
    case deleteItemFailed = 2003
    case scanTableFailed = 2004
    case queryTableFailed = 2005
}

//error code : 3000
enum CognitoError: Int{
    case cognitoLoginFailed = 3000
    case cognitoGetIdentityFailed = 30001
    case cognitoSyncDataFailed = 30002
}
