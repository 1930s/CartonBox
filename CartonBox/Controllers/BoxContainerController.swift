//
//  BoxContainerController.swift
//  CartonBox
//
//  Created by kay weng on 07/01/2018.
//  Copyright © 2018 kay weng. All rights reserved.
//

import UIKit

let segueForBoxContent = "SegueForBoxContent"

protocol BoxContainerDelegate {
    func selectedMediaAsset(_ selectedAsset:[PHAssetMedia])
    
}

class BoxContainerController: UIViewController,UINavigationBarDelegate {
    
    var vm:MediaFilesViewModel = MediaFilesViewModel()
    var delegate:BoxContainerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setBarButtons()
        
        UIView.animate(withDuration: 0.5) {
            self.tabBarController?.tabBar.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    //MARK: - Actions
    @objc func popToNewBoxController(){
        if vm.selectedPHAsset.count > 0{
            let ok = UIAlertAction(title: "Back", style: .destructive, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            self.alert(title: Message.Application, message: "You have selected one or more media files.Are you sure want to lose the changes ?", style: .alert, actions: [ok,cancel])
            
            return
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func donePHAssetsSelection(){
        if self.vm.selectedPHAsset.count > 0{
            self.delegate?.selectedMediaAsset(self.vm.selectedPHAsset)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Methods
    fileprivate func setBarButtons() {
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(BoxContainerController.donePHAssetsSelection))
        let btnBack = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(BoxContainerController.popToNewBoxController))
        
        self.navigationItem.setLeftBarButton(btnBack, animated: true)
        
        self.navigationItem.setRightBarButton(btnDone, animated: true)
    }

    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == segueForBoxContent{
                let destinationVC = segue.destination as! PHAssetsController

                destinationVC.mediaViewModel = self.vm
            }
        }
    }
}
