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

//        UserDefaults.standard.set(33387, forKey: "JPY")
//        UserDefaults.standard.synchronize()
        

        getDefaultPrices()
        getPrice()
    }
    
    func getDefaultPrices () {
        let usdPrice = UserDefaults.standard.double(forKey: "USD")
        if usdPrice != 0.0 {
            self.BTCTextLabel.text = self.doubleMoneyToString(price: usdPrice, currencyCode: "USD") + "~"
        }
        
        let eurPrice = UserDefaults.standard.double(forKey: "EUR")
        if eurPrice != 0.0 {
            self.EURTextLabel.text = self.doubleMoneyToString(price: eurPrice, currencyCode: "EUR") + "~"
        }
        
        let jpyPrice = UserDefaults.standard.double(forKey: "JPY")
        if jpyPrice != 0.0 {
            self.YinTextLabel.text = self.doubleMoneyToString(price: jpyPrice, currencyCode: "JPY") + "~"
        }
    }

    func getPrice () {
        if let url = URL(string: "https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC&tsyms=BTC,USD,EUR,JPY&api_key=cb35d8d21bee0c7e3a4556b3f511e5971c09a6aadf6170b510b6071120418d9a") {
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if let newData = data {
                    if let json = try? JSONSerialization.jsonObject(with: newData, options: []) as? [String: Dictionary<String, Double>] {
                        if let jsonDictionary = json {
                            DispatchQueue.main.async {
                                if let bitcoinPrices = jsonDictionary["BTC"] {
                                    if let bitcoinDollar = bitcoinPrices["USD"] {
                                        self.BTCTextLabel.text = self.doubleMoneyToString(price: bitcoinDollar, currencyCode: "USD")
                                        UserDefaults.standard.set(bitcoinDollar, forKey: "USD")
                                        UserDefaults.standard.synchronize()
                                    }
                                    
                                    if let bitcoinEuro = bitcoinPrices["EUR"] {
                                        self.EURTextLabel.text = self.doubleMoneyToString(price: bitcoinEuro, currencyCode: "EUR")
                                        UserDefaults.standard.set(bitcoinEuro, forKey: "EUR")
                                        UserDefaults.standard.synchronize()
                                    }

                                    if let bitcoinYen = bitcoinPrices["JPY"] {
                                        self.YinTextLabel.text = self.doubleMoneyToString(price: bitcoinYen, currencyCode: "JPY")
                                        UserDefaults.standard.set(bitcoinYen, forKey: "JPY")
                                        UserDefaults.standard.synchronize()
                                    }
                                }
                            }
                        }
                    }
                }
            }.resume()
        }
    }
    
    func doubleMoneyToString (price: Double, currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        let priceString = formatter.string(from: NSNumber(value: price))
        if priceString == nil {
            return "ERROR"
        } else {
            return priceString!
        }
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        getPrice()
    }
    
}

