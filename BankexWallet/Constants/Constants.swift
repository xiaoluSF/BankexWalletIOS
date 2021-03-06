//
//  StoragePaths.swift
//  BankexWallet
//
//  Created by Alexander Vlasov on 26.01.2018.
//  Copyright © 2018 Alexander Vlasov. All rights reserved.
//

import Foundation
struct BankexWalletConstants {
}
// TODO: Clear after all
extension BankexWalletConstants {
    static var KeystoreStoragePath:String = "/keystore"
    static var BIP32KeystoreStoragePath:String = "/bip32keystore"
}


// TODO: This is service layer, let's move it somewhere there
enum DataChangeNotifications: String {
    case didChangeWallet = "didChangeWallet"
    case didChangeNetwork = "didChangeNetwork"
    case didChangeToken = "didChangeToken"
    
    func notificationName() -> NSNotification.Name {
        return NSNotification.Name(self.rawValue)
    }
}


