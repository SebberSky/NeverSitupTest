//
//  ViewController.swift
//  Chawapon
//
//  Created by chawapon.kiatpravee on 23/4/2566 BE.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var currencyTextField: UITextField!
    @IBOutlet var btcTextField: UITextField!
    @IBOutlet var countdownView: UIProgressView!
    @IBOutlet var pinTextfield: UITextField!
    
    var btcData: [BTCData] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var timer: Timer?
    let pickerData: [Currency] = [.USD, .GBP, .EUR]
    var countdownSeconds = 60

    override func viewDidLoad() {
        super.viewDidLoad()
        btcTextField.text = "1"
        setUpUI()
        updateBTC()
    }
    
    private func updateBTC() {
        AF.request("https://api.coindesk.com/v1/bpi/currentprice.json").responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseData = try JSONDecoder().decode(BTCData.self, from: data)
                    if self.btcData.count == 0 {
                        self.btcData.append(responseData)
                    } else {
                        self.btcData.insert(responseData, at: 0)
                    }
                    self.updateUI()
                    self.startTimer()
                } catch let error as NSError {
                    print("failed :", error)
                }
            case .failure(let error):
                print("failed :", error)
            }
        }
    }
    
    private func setUpUI() {
        countdownView.progress = 1
        pickerView.delegate = self
        pickerView.dataSource = self
        tableView.dataSource = self
        tableView.delegate = self
        currencyTextField.delegate = self
        btcTextField.delegate = self
        pickerView.selectRow(0, inComponent: 0, animated: false)
    }
    
    private func updateUI() {
        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        currencyTextField.text = getStringValueFromPicker(currency: pickerData[selectedIndex])
        btcTextField.text = "1"
    }
    
    private func getStringValueFromPicker(currency: Currency) -> String? {
        guard let data = btcData.first else {
            return nil
        }
        switch currency {
        case .USD:
            return data.bpi?.usd?.rate
        case .GBP:
            return data.bpi?.gbp?.rate
        case .EUR:
            return data.bpi?.eur?.rate
        }
    }
    
    private func getNumberValueFromPicker(currency: Currency) -> Float? {
        guard let data = btcData.first else {
            return nil
        }
        switch currency {
        case .USD:
            return data.bpi?.usd?.rateFloat
        case .GBP:
            return data.bpi?.gbp?.rateFloat
        case .EUR:
            return data.bpi?.eur?.rateFloat
        }
    }
    
    @IBAction func fibonacciTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FibonacciViewController") as! FibonacciViewController
        self.present(vc, animated: true)
    }
    
    @IBAction func validatePinTapped(_ sender: Any) {
        guard let pin = pinTextfield.text else {
            return
        }
        
        if pin.count < 6 {
            pinTextfield.backgroundColor = .red
            return
        }
        
        var dupCount = 0
        var baseChar = ""
        for char in pin {
            if baseChar == char {
                dupCount += 1
                if dupCount == 2 {
                    pinTextfield.backgroundColor = .red
                    break
                }
            } else {
                baseChar = char
                dupCount = 0
            }
        }
        
        let pinArray = Array(pin)
        let maxIndex = pin.count - 1
        for i in 0..<pin.count {
            let secIndex = i + 1
            let thirdIndex = i + 2
            if secIndex > maxIndex || thirdIndex > maxIndex {
                break
            }
            
            let char1 = pinArray[i]
            let char2 = pinArray[secIndex]
            let char3 = pinArray[thirdIndex]
            if char1 - char2 == 1 {
                if char2 - char3 == 1 {
                    pinTextfield.backgroundColor = .red
                    break
                }
            } else if char1 - char2 == -1 {
                if char2 - char3 == -1 {
                    pinTextfield.backgroundColor = .red
                    break
                }
            }
        }
        
        var doubleCount = 0
        var baseChar = ""
        for char in pin {
            if baseChar == char {
                doubleCount += 1
                if doubleCount > 2 {
                    pinTextfield.backgroundColor = .red
                    break
                } else {
                    baseChar = ""
                }
            } else {
                baseChar = char
            }
        }
    }
}

extension ViewController {
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        DispatchQueue.main.async {
            self.countdownSeconds -= 1
            self.countdownView.progress = Float(self.countdownSeconds) / 60.0
            if self.countdownSeconds == 0 {
                self.restartTimer()
            }
        }
    }

    private func restartTimer() {
        countdownSeconds = 60
        timer?.invalidate()
        updateBTC()
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateUI()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return btcData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else {
            return UITableViewCell()
        }
        let data = btcData[indexPath.row]
        cell.updateUI(data: data)
        return cell
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        let btcRate = getNumberValueFromPicker(currency: pickerData[selectedIndex]) ?? 0.0
        if textField == btcTextField {
            let stringToDouble = Float(newString) ?? 0.0
            currencyTextField.text = addComma(input: stringToDouble * btcRate)
        } else if textField == currencyTextField {
            let stringToDouble = Float(newString) ?? 0.0
            btcTextField.text = addComma(input: stringToDouble / btcRate)
        }
        if newString == "" {
            updateUI()
        }
        textField.text = newString
        return false
    }
    
    private func addComma(input: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: input as NSNumber) ?? "0.0"
    }
}
