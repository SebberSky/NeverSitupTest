//
//  HistoryCell.swift
//  Chawapon
//
//  Created by chawapon.kiatpravee on 23/4/2566 BE.
//

import UIKit
class HistoryCell: UITableViewCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var usdLabel: UILabel!
    @IBOutlet var gbpLabel: UILabel!
    @IBOutlet var eurLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(data: BTCData) {
        guard let usd = data.bpi?.usd,
              let gbp = data.bpi?.gbp,
              let eur = data.bpi?.eur else {
            return
        }
        
        dateLabel.text = data.time?.updated
        let usdSymbol = getSymbol(symbol: usd.symbol ?? "")
        usdLabel.text = "\(usdSymbol?.string ?? "") : \(usd.rate ?? "")"
        let gbpSymbol = getSymbol(symbol: gbp.symbol ?? "")
        gbpLabel.text = "\(gbpSymbol?.string ?? "") : \(gbp.rate ?? "")"
        let eurSymbol = getSymbol(symbol: eur.symbol ?? "")
        eurLabel.text = "\(eurSymbol?.string ?? "") : \(eur.rate ?? "")"
    }
    
    private func getSymbol(symbol: String) -> NSAttributedString? {
        guard let data = symbol.data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
               ],
               documentAttributes: nil)
        } catch {
            print("Error:", error)
            return nil
        }
    }
}
