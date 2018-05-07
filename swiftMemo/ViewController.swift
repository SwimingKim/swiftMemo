//
//  ViewController.swift
//  swiftMemo
//
//  Created by KimSuyoung on 2018. 5. 7..
//  Copyright © 2018년 KimSuyoung. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
    var context: NSManagedObjectContext {
        guard let ad = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        return ad.persistentContainer.viewContext
    }
    
    func show(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
}

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchMemo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("detailSegue"):
            if let vc = segue.destination as? DetailViewController, let cell = sender as? UITableViewCell, let indexPath = listTableView.indexPath(for: cell) {
                vc.memo = list[indexPath.row]
            }
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
    
    func fetchMemo() {
        list.removeAll()
        
        let request = NSFetchRequest<MemoEntity>(entityName: "Memo")
        
        let sortByDate = NSSortDescriptor(key: "insertDate", ascending: false)
        let sortByTitle = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortByDate, sortByTitle]
        
        do {
            let list = try context.fetch(request)
            self.list = list
            
            listTableView.reloadData()
        } catch {
            show(message: error.localizedDescription)
        }
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
        
        if let content = target.content, content.count > 50 {
            let to = content.index(content.startIndex, offsetBy: 50)
            cell.memoContentLabel.text = "\(content[..<to])..."
        } else {
            cell.memoContentLabel.text = target.content
        }
        cell.memoDateLabel.text = df.string(for: target.insertDate)
        
        return cell
    }
    
}


extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let target = list[indexPath.row]
            context.delete(target)
            
            do {
                try context.save()
                
                list.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                show(message: error.localizedDescription)
            }
        default:
            break
        }
    }
    
}
