//
//  ViewController.swift
//  Giant Bomb
//
//  Created by Fred Strout on 4/18/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var checkoutTableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    private var selectedGames = [Game]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = selectedGames[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutCellIdentifier", for: indexPath) as! CheckoutTableViewCell
        
        cell.thumbnail.image = game.image
        cell.cellLabel.text = game.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            selectedGames.remove(at: indexPath.row)
            checkoutTableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        let vc = segue.source as! SearchViewController
        selectedGames.removeAll()
        selectedGames.append(contentsOf: vc.selectedGames)
        checkoutTableView.reloadData()
        checkoutButton.isHidden = selectedGames.count == 0
    }
    
    @IBAction func checkoutAction(_ sender: UIButton) {
        if selectedGames.count > 0 {
            let checkoutAlert = UIAlertController(title: "Checkout", message: "Do you want to checkout the following \(selectedGames.count) item(s)?", preferredStyle: UIAlertController.Style.alert)

            checkoutAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.checkout()
            }))

            checkoutAlert.addAction(UIAlertAction(title: "No", style: .cancel))

            present(checkoutAlert, animated: true, completion: nil)
        }
    }
    
    func checkout() {
        
        let paymentAlert = UIAlertController(title: "Payment", message: "Please provide a card for payment.\nAll fields are required.", preferredStyle: UIAlertController.Style.alert)
        
        paymentAlert.addTextField { (textField) in
            textField.placeholder = "Name as it appears on the card."
        }
        
        paymentAlert.addTextField { (textField) in
            textField.placeholder = "16 digit card number."
            textField.keyboardType = .numberPad
        }
        
        paymentAlert.addTextField { (textField) in
            textField.placeholder = "Expiration date (MM/YY)."
            textField.keyboardType = .numberPad
        }
        
        paymentAlert.addTextField { (textField) in
            textField.placeholder = "3 digit security code."
            textField.keyboardType = .numberPad
        }
        
        paymentAlert.addTextField { (textField) in
            textField.placeholder = "Zip code of billing address."
            textField.keyboardType = .numberPad
        }
        
        paymentAlert.addAction(UIAlertAction(title: "Process Payment", style: .default, handler: { (action: UIAlertAction!) in
            self.selectedGames.removeAll()
            self.checkoutTableView.reloadData()
            self.checkoutButton.isHidden = self.selectedGames.count == 0
        }))

        paymentAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(paymentAlert, animated: true, completion: nil)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Checkout.GoTo.Search" {
            if let vc = segue.destination as? SearchViewController {
                vc.selectedGames.removeAll()
                vc.selectedGames.append(contentsOf: selectedGames)
            }
        }
    }
}

