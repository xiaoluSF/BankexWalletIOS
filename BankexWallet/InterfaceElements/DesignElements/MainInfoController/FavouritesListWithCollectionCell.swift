//
//  FavouritesListWithCollectionCell.swift
//  BankexWallet
//
//  Created by Korovkina, Ekaterina  on 4/5/2561 BE.
//  Copyright © 2561 Alexander Vlasov. All rights reserved.
//

import UIKit

protocol FavoriteSelectionDelegate: class {
    func didSelectFavorite(with name: String, address: String)
    func didSelectAddNewFavorite()
}

class FavouritesListWithCollectionCell: UITableViewCell,
                                        UICollectionViewDelegate,
                                        UICollectionViewDataSource {

    weak var selectionDelegate: FavoriteSelectionDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView?
    
    let favoritesService: RecipientsAddressesService = RecipientsAddressesServiceImplementation()
    var allFavorites: [FavoriteModel]?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        allFavorites = favoritesService.getAllStoredAddresses()
    }
    
    override func prepareForReuse() {
        allFavorites = favoritesService.getAllStoredAddresses()
        collectionView?.reloadData()
    }
    
    // MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + (allFavorites?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            selectionDelegate?.didSelectAddNewFavorite()
        }
        else if let selected = allFavorites?[indexPath.row - 1] {
            selectionDelegate?.didSelectFavorite(with: selected.name, address: selected.address)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.row != 0 else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "AddContactCollectionCell", for: indexPath)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesCollectionViewCell", for: indexPath) as! FavoritesCollectionViewCell
        cell.configure(with: allFavorites![indexPath.row - 1])
        return cell
    }
}
