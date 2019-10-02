//
//  ViewController.swift
//  CoreDataExample
//
//  Created by SeokHo on 2019/10/02.
//  Copyright © 2019 SeokHo. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var data = [Movie]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    let coreDataStack: CoreDataStack
    
    required init?(coder: NSCoder) {
        self.coreDataStack = CoreDataStack.manager
        super.init(coder: coder)
        
    }
    
    @IBAction func addNewData(_ sender: UIBarButtonItem) {
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = CoreDataStack.manager.persistentstoreCoordinator
        
        context.perform {
            let newData = Movie(context: context)
            newData.title = "이것은 영화제목 입니다. "
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    @IBAction func reload(_ sender: Any) {
        
        coreDataStack.managedObjectcontext.perform {
            let fetchRequest: NSFetchRequest = Movie.fetchRequest()
            do {
                
                let data =  try fetchRequest.execute()
                self.data = data
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        cell.textLabel?.text = self.data[indexPath.row].title
        return cell
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = CoreDataStack.manager.persistentstoreCoordinator
        
        context.perform {
            let fetchRequest: NSFetchRequest = Movie.fetchRequest()
            do {
                
                let data =  try fetchRequest.execute()
                
                guard let title = data[indexPath.row].title else { return }
                
                if title.contains("영화") {
                    data[indexPath.row].title = "이것은 드라마 제목 입니다."
                } else {
                    data[indexPath.row].title = "이것은 영화 제목 입니다."
                }
    
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
}
