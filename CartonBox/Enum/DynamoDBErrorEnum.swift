//
//  ApplicationErrorEnum.swift
//  CartonBox
//
//  Created by kay weng on 20/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation

enum DynamoDBError{
    case nullModel
    case getItemFailed
    case saveItemFailed
    case deleteItemFailed
    case scanTableFailed
    case queryTableFailed
}
