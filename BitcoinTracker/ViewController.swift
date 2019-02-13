//
//  ViewController.swift
//  BitcoinTracker
//
//  Created by Juan Guardado on 2/6/19.
//  Copyright © 2019 Juan Guardado. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var BTCTextLabel: UILabel!
    @IBOutlet weak var EURTextLabel: UILabel!
    @IBOutlet weak var YinTextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getPrice()
    }
    

    
    func getPrice () {
        if let url = URL(string: "https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC&tsyms=BTC,USD,EUR,JPY&api_key=cb35d8d21bee0c7e3a4556b3f511e5971c09a6aadf6170b510b6071120418d9a") {
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if let newData = data {
                    if let json = try? JSONSerialization.jsonObject(with: newData, options: []) as? [String: Dictionary<String, Any>] {
                        if let jsonDictionary = json {
                            DispatchQueue.main.async {
                                if let bitcoinPrices = jsonDictionary["BTC"] {
                                    if let bitcoinDollar = bitcoinPrices["USD"] {
                                        print(bitcoinDollar)
                                        self.BTCTextLabel.text = "$\(bitcoinDollar)"
                                    }
                                    
                                    if let bitcoinEuro = bitcoinPrices["EUR"] {
                                        self.EURTextLabel.text = "€ \(bitcoinEuro)"
                                    }

                                    if let bitcoinYin = bitcoinPrices["JPY"] {
                                        self.YinTextLabel.text = "¥ \(bitcoinYin)"
                                    }
                                }
                            }
                            print(jsonDictionary)
                        } else {
                            print("cant unwrap")
                        }
                        print(json)
                    } else {
                        print("json try failed")
                    }
                } else {
                    print("problemos")
                }
            }.resume()
        }
    }
    
    @IBAction func refreshButton(_ sender: Any) {
    }
    
}

