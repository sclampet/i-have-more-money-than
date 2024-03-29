//
//  ViewController.swift
//  I Have More Money Than
//
//  Created by Scott Clampet on 9/6/19.
//  Copyright © 2019 Scott Clampet. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewController: UICollectionViewController {
    
    fileprivate let cellId = "cellId"
    fileprivate let headerId = "headerId"
    fileprivate let errorCellId = "errorCellId"
    
    var accounts: [Account] = []
    var isError: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAccounts()
        setupCollectionView()
        setupNavBar()
    }
}

//MARK: DataSource & Delegate Methods
extension HomeViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return !isError ? accounts.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isError {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: errorCellId, for: indexPath) as! ErrorCell
            cell.retryButton.addTarget(self, action: #selector(reloadCollectionView), for: .touchUpInside)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AccountCell
            cell.account = accounts[indexPath.item]
            setBorderAndShadow(on: cell)
            return cell
            
        }
    }
    
}


//MARK: FlowLayout Methods
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 50, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsScreen = AccountDetailsViewController()
        if let nav = navigationController {
            detailsScreen.account = accounts[indexPath.item]
            nav.pushViewController(detailsScreen, animated: true)
        }
    }
}

//MARK: Header Methods
extension HomeViewController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderView
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return !isError ? CGSize(width: view.frame.width, height: 125) : CGSize.zero
    }
}


//MARK: Helper Methods
extension HomeViewController {
    
    fileprivate func setupNavBar() {
        if let navBar = navigationController?.navigationBar {
            navBar.backgroundColor = .white
            navBar.shadowImage = UIImage()
            navBar.isTranslucent = false
        }
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(AccountCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(ErrorCell.self, forCellWithReuseIdentifier: errorCellId)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    fileprivate func fetchAccounts() {
        let networkManager = NetworkManager()
        SVProgressHUD.show()
        networkManager.getAccounts(from: BaseURL.allAccounts) { (response) in
            switch response {
            case .success(let accountList):
                SVProgressHUD.dismiss()
                DispatchQueue.main.async {
                    self.accounts = accountList
                    self.isError = false
                    self.collectionView.reloadData()
                }
            case .failure(let err):
                SVProgressHUD.dismiss()
                print("failed to fetch accounts: \(err)")
                DispatchQueue.main.async {
                    self.isError = true
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    fileprivate func setBorderAndShadow(on cell: UICollectionViewCell) {
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 0.7
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    }
    
    @objc fileprivate func reloadCollectionView() {
        fetchAccounts()
    }
}

