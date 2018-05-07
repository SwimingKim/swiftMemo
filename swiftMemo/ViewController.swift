//
//  ViewController.swift
//  swiftMemo
//
//  Created by KimSuyoung on 2018. 5. 7..
//  Copyright © 2018년 KimSuyoung. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    var list = [MemoEntity]()
    
    lazy var df: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        return f
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.estimatedRowHeight = 100
        listTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func fetchMemo() {
        list.removeAll()
        
        let request = NSFetchRequest<MemoEntity>(entityName: "Memo")
        print(request)
        
        let sortByDate = NSSortDescriptor(key: "insertDate", ascending: false)
        let sortByTitle = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortByDate, sortByTitle]
        
        do {
            let list = try context.fetch(request)
            print(list.count)
            self.list = list
            
            listTableView.reloadData()
        } catch {
            show(message: error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchMemo()
    }

}

extension ViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.identifier) as! MemoTableViewCell
        
        let target = list[indexPath.row]
        cell.memoTitleLabel.text = target.title
        
        if let content = target.content, content.count > 200 {
            let to = content.index(content.startIndex, offsetBy: 200)
            cell.memoContentLabel.text = "\(content[..<to])"
        } else {
            cell.memoContentLabel.text = target.content
        }
        cell.memoDateLabel.text = df.string(for: target.insertDate)
        
        return cell
    }
    
}
