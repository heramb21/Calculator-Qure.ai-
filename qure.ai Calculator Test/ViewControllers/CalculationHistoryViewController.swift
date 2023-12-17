//
//  CalculationHistoryViewController.swift
//  qure.ai Calculator Test
//
//  Created by Heramb on 15/12/23.
//

import UIKit

class CalculationHistoryViewController: UIViewController {
    
    //MARK: Properties
    var calculationHistory: [CalculationData] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

    // MARK: - Table view data source & delegates
extension CalculationHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculationHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calculationHistoryCell", for: indexPath)
        let operation = calculationHistory[indexPath.row].generateEquation()
        let currentDate = NSDate.now
        if #available(iOS 14.0, *) {
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.attributedText = NSAttributedString(string: operation + "(Timestamp:\(currentDate.description.dropLast(5)))", attributes: [.foregroundColor: UIColor.white])
            cell.contentConfiguration = contentConfiguration
        } else {
            cell.textLabel?.textColor = .white
            cell.textLabel?.text = operation + "(Timestamp:\(currentDate.description.dropLast(5)))"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uiPasteboard = UIPasteboard.general
        uiPasteboard.string = calculationHistory[indexPath.row].result
        
        let alert = UIAlertController(title: "Copied to clipboard", message: "\(calculationHistory[indexPath.row].result) has been added to your clipboard.", preferredStyle: .alert)
        
        present(alert, animated: true) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
