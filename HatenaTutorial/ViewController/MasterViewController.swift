//
//  MasterViewController.swift
//  HatenaTutorial
//
//  Created by 藤井陽介 on 2017/05/20.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var repositories: [Repository] = [] {
        
        didSet {
            
            tableView.reloadData()
        }
    }


    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // API Call
        _ = SearchRepositories(searchQuery: "Hatena", page: 0).request(URLSession.shared) { (result) in
            
            switch result {
            case .success(let searchResult):
                DispatchQueue.main.async {
                    
                    self.repositories.append(contentsOf: searchResult.items)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let repository = repositories[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.repository = repository
            }
        }
    }

    // MARK: - TableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository.name
        return cell
    }
}

