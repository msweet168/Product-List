//
//  ViewController.swift
//  Product List
//
//  Created by Mitchell Sweet on 1/4/18.
//  Copyright © 2018 Mitchell Sweet. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    // Stores products parsed from JSON document. 
    var allProducts = [Product]()
    var filteredProducts = [Product]()
    
    // URL of JSON document.
    let url = URL(string: "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")
    let imageLoader = ImageLoader()
    let searchController = UISearchController(searchResultsController: nil)
    var selectedRow: NSInteger = -1
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        tableViewSetup()
        parse()
    }
    
    /// Sets up UI elements and navbar at runtime.
    func viewSetup() {
        
        title = "Product List"
        
        // Sets the bar style to black so the bold title changes to a white color.
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        // then sets the bar to the app's theme color,
        navigationController?.navigationBar.barTintColor = UIColor.themeColor
        // and sets the text color of the nav bar to white.
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        // Search controller
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search products", attributes: nil)
        searchController.searchBar.tintColor = UIColor.white
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    /// Called by search button to bring focus to search field.
    @IBAction func search() {
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
    }
    
    /// Returns true if search bar has text in it.
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    /// Returns true if search bar is active and not empty.
    func isSearching() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    /// Retreives JSON data from URL and parses it with JSON decoder.
    func parse() {
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            guard error == nil else {
                print("Error in parsing JSON: \(error?.localizedDescription ?? "description not available.")")
                return
            }
            guard let content = data else {
                print("Error: There was no data returned from JSON file.")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                // Decode JSON file starting from Response struct.
                let decodedProducts = try decoder.decode(Response.self, from: content)
                
                // Pass data to main queue
                DispatchQueue.main.async {
                    self.allProducts = decodedProducts.products // Add products to array
                    self.tableView.reloadData()
                }
            }
            catch {
                // Present an alert if the JSON data cannot be decoded.
                let alert = UIAlertController(title: "Error", message: "Could not read products.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        task.resume()
    }
    
    
    
    
    /// Sets up runtime UI elements of table view.
    func tableViewSetup() {
        tableView.separatorColor = UIColor.themeColor
        tableView.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if isSearching() {
            return filteredProducts.count
        }
        
        return allProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListViewCell
        
        // Creates an array of products to display bases on wheather a search is being conducted or not.
        var displayedProducts: [Product] {
            if isSearching() {
                return filteredProducts
            } else {
                return allProducts
            }
        }
        
        // Current product for specific cell
        let product = displayedProducts[indexPath.row]
        
        // If the image has an image URL, imageLoader is used to download the image and display it in the cell's imageview.
        if let imageUrl = product.images.first?.src {
            imageLoader.loadImage(url: imageUrl) { image, error in
                if let error = error {
                    print("Error: Could not download image. Description: \(error.localizedDescription)")
                    cell.itemImage.image = UIImage.init(named: "default")
                }
                cell.itemImage.image = image
            }
        }
        else {
            cell.itemImage.image = UIImage.init(named: "default")
        }
        
        
        // Set other labels in cell.
        
        cell.title.text = product.title
        cell.desc.text = product.body_html
        cell.id.text = "ID: \(product.id)"
        cell.vendor.text = "Vendor: \(product.vendor)"
        cell.type.text = "Product Type: \(product.product_type)"
        cell.numVarients.text = "Variants: \(product.variants.count)"
        cell.varients.text = product.variants.map { $0.title }.joined(separator: ", ")

        cell.tintColor = UIColor.themeColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        cellTapped(rowNum: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        cellTapped(rowNum: indexPath.row)
    }
    
    /// Changes the selected row index and updates the table view.
    func cellTapped(rowNum: Int) {
        if rowNum == selectedRow {
            selectedRow = -1
        }
        else {
            selectedRow = rowNum
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedRow {
            return 315
        }
        else {
            return 120
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension UIColor {
     @nonobjc static var themeColor: UIColor {
        return #colorLiteral(red: 0, green: 0.5882352941, blue: 0.5333333333, alpha: 1)
    }
}

extension ViewController: UISearchResultsUpdating {
    /// Updates the search results each time text is entered. 
    func updateSearchResults(for searchController: UISearchController) {
        filteredProducts = allProducts.filter { $0.matchesSearchText((searchController.searchBar.text?.lowercased())!) }
        tableView.reloadData()
    }
}

