//
//  ProtocolDataSource.swift
//  CartonBox
//
//  Created by kay weng on 31/12/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import UIKit

protocol UIViewControllerProtocol{
    var delegate:UIViewController? { get set }
    
    func initWithDataSource()->Void
}

protocol UITableViewCellProtocol{
    var delegate:UITableViewCell? { get set }
    
    func initWithDataSource()->Void
}


protocol UICollectionViewProtocol {
    var delegate:UICollectionView? { get set }
    
    func initWithDataSource()->Void
}
