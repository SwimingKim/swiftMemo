//
//  ComposeViewController.swift
//  swiftMemo
//
//  Created by KimSuyoung on 2018. 5. 7..
//  Copyright © 2018년 KimSuyoung. All rights reserved.
//

import UIKit
import CoreData

class ComposeViewController: UIViewController {
    
    var memo: MemoEntity?

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentField: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleField.text, title.count > 0 else {
            show(message: "제목을 입력해주세요.")
            return
        }
        guard let content = contentField.text, content.count > 0 else {
            show(message: "내용을 입력해주세요.")
            return
        }
        
        if let editTarget = memo {
            editTarget.title = title
            editTarget.content = content
        } else {
            if let newMemo = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: context) as? MemoEntity {
                newMemo.title = title
                newMemo.content = content
                newMemo.insertDate = Date()
            }
        }
        
        do {
            try context.save()
            dismiss(animated: true, completion: nil)
        } catch {
            show(message: error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) {
            [weak self] (noti) in
            if let value = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let frame = value.cgRectValue
                self?.bottomConstraint.constant = frame.height + 20
                
                UIView.animate(withDuration: 0.3, animations: {
                    self?.view.layoutIfNeeded()
                })
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) {
            [weak self] (noti) in
            self?.bottomConstraint.constant = 20
            
            UIView.animate(withDuration: 0.3, animations: {
                self?.view.layoutIfNeeded()
            })
        }
        
        if let editTarget = memo {
            titleField.text = editTarget.title
            contentField.text = editTarget.content
            
            title = "편집하기"
        } else {
            title = "새 메모"
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if titleField.isFirstResponder {
            titleField.resignFirstResponder()
        }
        
        if contentField.isFirstResponder {
            contentField.resignFirstResponder()
        }
    }

}
