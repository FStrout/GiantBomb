//
//  SearchViewController.swift
//  Giant Bomb
//
//  Created by Fred Strout on 4/18/22.
//

import UIKit


class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var gamesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var gamesSearchBar: UISearchBar!
    
    // MARK: - Properties
    var selectedGames = [Game]()
    private var gamesList = [Game]()
    private let selectedSymbol = UIImage(systemName: "checkmark.circle.fill")
    private let deselectedSymbol = UIImage(systemName: "circle")
    
    // MARK: SearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
            performRequest(searchString: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        performRequest(searchString: "")
    }
    
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = gamesList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCellIdentifier", for: indexPath) as! SearchTableViewCell
        cell.cellLabel.text = game.name
        cell.thumbnail.image = game.image
        if selectedGames.contains(where: {$0.name == game.name}) {
            cell.selectedIcon.image = selectedSymbol
        } else {
            cell.selectedIcon.image = deselectedSymbol
        }
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = gamesList[indexPath.row]
        
        if selectedGames.contains(where: {$0.name == selectedGame.name}) {
            // remove game from selected list
            if let gameOffset = selectedGames.firstIndex(where: {$0.name == selectedGame.name}) {
                selectedGames.remove(at: gameOffset)
            }
        } else {
            selectedGames.append(selectedGame)
        }
        gamesTableView.reloadRows(at: [indexPath], with: .none)
    }
    
    // MARK: - Methods
    @objc func performRequestOnCancel() {
        performRequest(searchString: "")
    }
    
    func performRequest(searchString: String) {
        activityIndicatorView.isHidden = false
        activityIndicator.startAnimating()
        RestClient().getResponse(searchString: searchString) { [weak self] (games) in
            
            self?.gamesList = games
            
            
            DispatchQueue.main.async {
                for game in games {
                    guard let urlString = game.images["thumb_url"],
                          let url = URL(string: urlString) else {
                        return
                    }
                    
                    if let imageData = try? Data(contentsOf: url) {
                        if let loadedImage = UIImage(data: imageData) {
                            game.image = loadedImage
                            
                        }
                    }
                }
                
                self?.gamesTableView.reloadData()
                self?.activityIndicator.stopAnimating()
                self?.activityIndicatorView.isHidden = true
            }
        }
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {

        if let searchTextField = self.gamesSearchBar.value(forKey: "searchField") as? UITextField , let clearButton = searchTextField.value(forKey: "_clearButton")as? UIButton {

             clearButton.addTarget(self, action: #selector(self.performRequestOnCancel), for: .touchUpInside)
        }
        performRequest(searchString: "")
        
        print("viewDidLoad")
    }
}
