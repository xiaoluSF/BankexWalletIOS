//
//  AddressQRCodeController.swift
//  BankexWallet
//
//  Created by Korovkina, Ekaterina on 3/13/2561 BE.
//  Copyright © 2561 Alexander Vlasov. All rights reserved.
//

import UIKit
import web3swift

class AddressQRCodeController: UIViewController {

    var addressToGenerateQR: String?
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var addressLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = generateQRCode(from: addressToGenerateQR)
        addressLabel.text = addressToGenerateQR
    }
 
    @IBAction func copyAddress(_ sender: Any) {
        UIPasteboard.general.string = addressToGenerateQR
    }
    
    func generateQRCode(from string: String?) -> UIImage? {
        guard let string = string else {
            return nil
        }
        
        guard let code = Web3.EIP67Code(address: string)?.toString() else {
            return nil
        }
        
        let data = code.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
}
