//
//  SettingsViewController.swift
//  qure.ai Calculator Test
//
//  Created by Heramb on 15/12/23.
//

import UIKit

class SettingsViewController: UIViewController {

    //MARK: Properties
    var stateController: StateController?
    
    let sectionTitles = [ "Gestures",
                          "Customization",
                          "Calculation History"
                        ]
    let rowsPerSection = [2, 2, 2]
    
    var preferences = UserPreferences.getDefaultPreferences()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        
        table.register(TextTableViewCell.self, forCellReuseIdentifier: "ClearHistory")
        table.register(SwitchTableViewCell.nib(), forCellReuseIdentifier: "HistorySwitch")
        table.register(SwitchTableViewCell.nib(), forCellReuseIdentifier: "DecimalSwitch")
        table.register(SwitchTableViewCell.nib(), forCellReuseIdentifier: "SetCalculatorColourSwitch")
        table.register(SelectionSummaryTableViewCell.self, forCellReuseIdentifier: "ColourSelection")
        table.register(SelectionSummaryTableViewCell.self, forCellReuseIdentifier: "CopyActionSelection")
        table.register(SelectionSummaryTableViewCell.self, forCellReuseIdentifier: "PasteActionSelection")
        table.register(SelectionSummaryTableViewCell.self, forCellReuseIdentifier: "HistoryButtonSelection")
        table.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)
        
        table.sectionHeaderHeight = 40
        
        return table
    }()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        
        // Force dark mode to be used (for now)
        overrideUserInterfaceStyle = .dark
        
        // Check if prefereces are saved
        if let savedPreferences = DataPersistence.loadPreferences() {
            self.preferences = savedPreferences
            self.stateController?.convValues.colourNum = savedPreferences.colourNum
            self.stateController?.convValues.colour = savedPreferences.colour
        }
        else {
            // Use state controller as it will contain the default preferences
            self.preferences.copyActionIndex = self.stateController?.convValues.copyActionIndex ?? 0
            self.preferences.pasteActionIndex = self.stateController?.convValues.pasteActionIndex ?? 1
            self.preferences.setCalculatorTextColour = self.stateController?.convValues.setCalculatorTextColour ?? false
            self.preferences.colour = self.stateController?.convValues.colour ?? .systemBlue
        }

        // Set custom back button text to navigationItem
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Set the preferences that might have been changed by a child view
        if (self.preferences.colourNum != stateController?.convValues.colourNum) {
            self.preferences.colourNum = stateController?.convValues.colourNum ?? self.preferences.colourNum
            self.preferences.colour = stateController?.convValues.colour ?? self.preferences.colour
            
            // Reload UI only when necessary
            self.tableView.reloadSections([0,1,2], with: .none)
        }
        else if (self.preferences.copyActionIndex != stateController?.convValues.copyActionIndex) {
            self.preferences.copyActionIndex = stateController?.convValues.copyActionIndex ?? self.preferences.copyActionIndex
            // Reload UI only when necessary
            self.tableView.reloadSections([1], with: .none)
        }
        else if (self.preferences.pasteActionIndex != stateController?.convValues.pasteActionIndex) {
            self.preferences.pasteActionIndex = stateController?.convValues.pasteActionIndex ?? self.preferences.pasteActionIndex
            // Reload UI only when necessary
            self.tableView.reloadSections([1], with: .none)
        }
        else if (self.preferences.historyButtonViewIndex != stateController?.convValues.historyButtonViewIndex) {
            self.preferences.historyButtonViewIndex = stateController?.convValues.historyButtonViewIndex ?? self.preferences.historyButtonViewIndex
            // Reload UI only when necessary
            self.tableView.reloadSections([2], with: .none)
        }
        
        // Colour the navigation bar
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    // Function to toggle the optional setting of the calculator text colour
    @IBAction func setCalculatorTextColourSwitchPressed(_ sender: UISwitch) {
        let userPreferences = UserPreferences(colour: preferences.colour, colourNum: (stateController?.convValues.colourNum)!,
                                              hexTabState: preferences.hexTabState, binTabState: preferences.binTabState, decTabState: preferences.decTabState,
                                              setCalculatorTextColour: sender.isOn,
                                              copyActionIndex: preferences.copyActionIndex, pasteActionIndex: preferences.pasteActionIndex,
                                              historyButtonViewIndex: preferences.historyButtonViewIndex)
        DataPersistence.savePreferences(userPreferences: userPreferences)
        stateController?.convValues.setCalculatorTextColour = sender.isOn
        self.preferences = userPreferences
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

    // MARK: - Table view data source & delegates
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    // Setup number of rows per section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowsPerSection[section]
    }
    
    // Setup number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }
    
    // Setup section headers
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < self.sectionTitles.count {
            return sectionTitles[section]
        }

        return nil
    }
    // Build table cell layout
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            // Gestures section
        case 0:
            // Copy action
            if indexPath.row == 0 {
                // Show summary detail view for copy action selection
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "CopyActionSelection", for: indexPath) as! SelectionSummaryTableViewCell
                cell.configure(rightText: CopyOrPasteActionConverter.getActionFromIndex(index: Int(self.preferences.copyActionIndex), paste: false), colour: UIColor.systemGray)
                cell.textLabel?.text = "Copy Action"
                return cell
            }
            // Paste action
            else {
                // Show summary detail view for paste action selection
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "PasteActionSelection", for: indexPath) as! SelectionSummaryTableViewCell
                cell.configure(rightText: CopyOrPasteActionConverter.getActionFromIndex(index: Int(self.preferences.pasteActionIndex), paste: true), colour: UIColor.systemGray)
                cell.textLabel?.text = "Paste Action"
                return cell
            }
            // Customization section
        case 1:
            // Set calculator text colour
            if indexPath.row == 1 {
                // Show switch for set calculator text colour
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "SetCalculatorColourSwitch", for: indexPath) as! SwitchTableViewCell
                cell.configure(isOn: self.preferences.setCalculatorTextColour, colour: preferences.colour)
                cell.textLabel?.text = "Set Calculator Text Colour"
                cell.self.cellSwitch.addTarget(self, action: #selector(self.setCalculatorTextColourSwitchPressed), for: .touchUpInside)
                return cell
            }
            // Select colour preference
            else {
                // Show summary detail view for colour selection
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "ColourSelection", for: indexPath) as! SelectionSummaryTableViewCell
                cell.configure(rightText: ColourNumberConverter.getColourNameFromIndex(index: Int(self.preferences.colourNum)), colour: UIColor.systemGray)
                cell.textLabel?.text = "Colour"
                return cell
            }
            // Calculation history section
        case 2:
            // Select history button display preference
            if indexPath.row == 0 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "HistoryButtonSelection", for: indexPath) as! SelectionSummaryTableViewCell
                cell.configure(rightText: HistoryButtonViewConverter.getViewFromIndex(index: Int(self.preferences.historyButtonViewIndex)), colour: UIColor.systemGray)
                cell.textLabel?.text = "History Button View"
                return cell
            }
            // Clear local history
            else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "ClearHistory", for: indexPath) as! TextTableViewCell
                cell.textLabel?.text = "Clear Local History"
                cell.textLabel?.textColor = preferences.colour
                return cell
            }
        default:
            fatalError("Index out of range")
        }
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Navigate to copy or paste action selection view
        if indexPath.section == 0 {
            if let _ = tableView.cellForRow(at: indexPath), let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: SettingsSelectionViewController.identifier) as? SettingsSelectionViewController {
                destinationViewController.selectionList = ["Single Tap", "Double Tap", "Off"]
                destinationViewController.preferences = self.preferences
                destinationViewController.selectedIndex = indexPath.row == 0 ? Int(preferences.copyActionIndex) : Int(preferences.pasteActionIndex)
                destinationViewController.selectionType = indexPath.row == 0 ? SelectionType.copyAction : SelectionType.pasteAction
                destinationViewController.stateController = stateController
                destinationViewController.name = indexPath.row == 0 ? "Copy Action" : "Paste Action"
                
                // Navigate to new view
                navigationController?.pushViewController(destinationViewController, animated: true)
            }
        }
        // Navigate to colour selection view
        if indexPath.section == 1 && indexPath.row == 0 {
            if let _ = tableView.cellForRow(at: indexPath), let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: SettingsSelectionViewController.identifier) as? SettingsSelectionViewController {
                destinationViewController.selectionList = ["Red", "Orange", "Yellow", "Green", "Blue", "Teal", "Indigo", "Violet"]
                destinationViewController.preferences = self.preferences
                destinationViewController.selectedIndex = self.preferences.colourNum == -1 ? 4 : Int(self.preferences.colourNum)
                destinationViewController.selectionType = SelectionType.colour
                destinationViewController.stateController = stateController
                destinationViewController.name = "Colour"
                
                // Navigate to new view
                navigationController?.pushViewController(destinationViewController, animated: true)
            }
        }
        // Calculation history operations
        if indexPath.section == 2 {
            // Navigate to history button selection view
            if indexPath.row == 0 {
                if let _ = tableView.cellForRow(at: indexPath), let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: SettingsSelectionViewController.identifier) as? SettingsSelectionViewController {
                    destinationViewController.selectionList = ["Icon Image", "Text Label", "Off"]
                    destinationViewController.preferences = self.preferences
                    destinationViewController.selectedIndex = Int(self.preferences.historyButtonViewIndex)
                    destinationViewController.selectionType = SelectionType.historyButtonView
                    destinationViewController.stateController = stateController
                    destinationViewController.name = "History Button View"
                    
                    // Navigate to new view
                    navigationController?.pushViewController(destinationViewController, animated: true)
                }
            }
            // Clear local history
            else {
                // Set the flag to 7 (111 in binary)
                stateController?.convValues.clearLocalHistory = 7
                
                // Tell the user that the history was cleared
                let alert = UIAlertController(title: "Local History Cleared", message: "The local calculation history for all calculators has been cleared.", preferredStyle: .alert)
                
                present(alert, animated: true) {
                    tableView.deselectRow(at: indexPath, animated: true)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - Extension
//Adds state controller to the view controller
extension SettingsViewController: StateControllerProtocol {
  func setState(state: StateController) {
    self.stateController = state
  }
}
