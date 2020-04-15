//
//  ActionListController.swift
//  Assistant
//
//  Created by 飞亦 on 3/13/20.
//  Copyright © 2020 COB. All rights reserved.
//

import UIKit
import JXFoundation

private let cellId = "cellId"

class ActionListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var backBlock : ((_ arr: Array<String>)->())?
    
    var tableView : UITableView?
    var scrollView : UIScrollView?
    
    
    var actions = Array<String>()

    var totalButtons = Array<UIButton>()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "动作"
        self.view.backgroundColor = UIColor.white
        
        
        
//        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(edit(isEidt:index:)))
//        let editItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editChanged))
//        let dropItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dropTable))
        
        
//        self.customNavigationItem.rightBarButtonItems = [addItem,editItem,dropItem]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(finish))
        //UIBarButtonItem(customView: <#T##UIView#>)
       

        self.tableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight - 234 - 25), style: .plain)
        
        self.tableView?.register(UINib.init(nibName: "ActionCell", bundle: nil), forCellReuseIdentifier: cellId)
        //self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        self.tableView?.sectionFooterHeight = 0.1
        self.tableView?.tableFooterView = UIView()//group类型，设置高度不起作用
        self.tableView?.rowHeight = UITableView.automaticDimension
        self.tableView?.estimatedRowHeight = 44*kPercent
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        self.tableView?.isEditing = true
        //self.tableView?.allowsMultipleSelectionDuringEditing =  true
        
        self.view.addSubview(self.tableView!)
        
        
        let bottomView = UIView(frame: CGRect(x: 20, y: (self.tableView?.frame.maxY ?? 0) + 25, width: kScreenWidth - 40, height: 200))
        bottomView.layer.masksToBounds = false
        //bottomView.backgroundColor = UIColor.red
        bottomView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        bottomView.layer.borderWidth = 1
        bottomView.layer.cornerRadius = 20
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOffset = CGSize(width: 30, height: 30)
        bottomView.layer.shadowRadius = 30
        self.view.addSubview(bottomView)
        
        
        let button = UIButton()
        button.frame = CGRect(x: kScreenWidth - 80, y: bottomView.frame.minY - 25, width: 50, height: 50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 50)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("﹢", for: .normal)
        button.backgroundColor = JXMainColor
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 20, height: 20)
        button.layer.shadowRadius = 20
        button.addTarget(self, action: #selector(addAction(btn:)), for: .touchUpInside)
        self.view.addSubview(button)
        
    
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 10, width: 100, height: 21)
        label.text = "动作库"
        label.textColor = JXMainColor
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        
        bottomView.addSubview(label)
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 40, width: bottomView.bounds.width, height: 160))
        self.scrollView?.alwaysBounceVertical = true
        
        bottomView.addSubview(self.scrollView!)
        
        let height = self.setupMnemonicView(self.scrollView!, subViewsWithTitles: UserManager.shareInstance.userModel.totalTrainActions)
        self.scrollView?.contentSize = CGSize(width: kScreenWidth - 80, height: height)
        
    }
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func finish() {
        if let block = self.backBlock {
            block(self.actions)
        }
        self.dismiss(animated: true, completion: nil)
    }
    @objc func addAction(btn: UIButton) {
        let alert = UIAlertController(title: "添加动作", message: "添加后自动加入动作库", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "请输入"
        }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            alert.dismiss(animated: true) {
                guard let textField = alert.textFields?[0], let text = textField.text, text.isEmpty == false, UserManager.shareInstance.userModel.totalTrainActions.contains(text) == false else {
                    return
                }
                UserManager.shareInstance.userModel.totalTrainActions.append(text)
                UserManager.shareInstance.userModel.totalTrainActionsStr = UserManager.shareInstance.splice(arr: UserManager.shareInstance.userModel.totalTrainActions)
                UserManager.shareInstance.updateUserInfo()
                let height = self.setupMnemonicView(self.scrollView!, subViewsWithTitles: UserManager.shareInstance.userModel.totalTrainActions)
                self.scrollView?.contentSize = CGSize(width: kScreenWidth - 80, height: height)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ActionCell
        
//        let dbUserEntity = actions[indexPath.row] as! DBUserModel
//        cell.model = dbUserEntity
//        cell.textLabel?.text = actions[indexPath.row]
        cell.textField.text = actions[indexPath.row]
        cell.textField.delegate = self
        cell.textField.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除！"
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {

        let style : UITableViewCell.EditingStyle = .delete
        return style
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.actions.remove(at: indexPath.row)
//            self.dataArray.remove(at: indexPath.row)
//            self.tableView?.beginUpdates()
//            self.tableView.
//            self.tableView?.endUpdates()
        }
        
    }
    /// 代替以上的方法
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //default,destructive默认红色，normal默认灰色，可以通过backgroundColor 修改背景颜色，backgroundEffect 添加模糊效果
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { (action, indexPath) in
            print("删除")
            //let model = self.dataArray[indexPath.row] as! DBUserModel
            //if JXBaseDB.default.deleteData(condition: ["id = \(model.id)"]) == true{
            //    self.dataArray.remove(at: indexPath.row)
    
            
            let title = self.actions[indexPath.row]
            let index = UserManager.shareInstance.userModel.totalTrainActions.firstIndex(of: title)
            let button = self.totalButtons[index ?? 0]
            button.isSelected = false
            button.backgroundColor = UIColor.rgbColor(from: 249, 249, 249)
            
            self.actions.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
         
            UserManager.shareInstance.userModel.trainActions = self.actions
            UserManager.shareInstance.userModel.trainActionsStr = UserManager.shareInstance.splice(arr: self.actions)
            UserManager.shareInstance.updateUserInfo()
        }
  
        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //let arr = self.actions
        let temp = self.actions[sourceIndexPath.row]
        self.actions[sourceIndexPath.row] = self.actions[destinationIndexPath.row]
        self.actions[destinationIndexPath.row] = temp
    }

    func setupMnemonicView(_ mnemonicContentView: UIView, subViewsWithTitles titles: Array<String>) -> CGFloat{
        
        mnemonicContentView.removeAllSubView()
        self.totalButtons.removeAll()
        
        let rangeRect = CGRect(x: 20, y: 0, width: mnemonicContentView.bounds.width - 40, height: 28)
        let lineSpace : CGFloat = 10
        let itemSpace : CGFloat = 10
        let itemHeight : CGFloat = 28
        
        
        var frontRect = CGRect()
        
        for i in 0..<titles.count {
            
            let size = self.calculate(text: titles[i], width: rangeRect.width, fontSize: 15, lineSpace: 0)
            var frame = CGRect()
            
            
            
            let button = UIButton()
            button.backgroundColor = UIColor.rgbColor(from: 249, 249, 249)
            button.tag = i
            button.setTitle(titles[i], for: .normal)
            button.setTitleColor(JXMainTextColor, for: .normal)
            button.setTitleColor(UIColor.white, for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.addTarget(self, action: #selector(selectAction(button:)), for: .touchUpInside)
            
            button.layer.cornerRadius = 5
            button.layer.borderColor = UIColor.rgbColor(from: 205, 205, 205).cgColor
            button.layer.borderWidth = 1
            
            if self.actions.contains(titles[i]) == true {
                button.isSelected = true
            }
            if button.isSelected == true {
                button.backgroundColor = JXMainColor
            } else {
                button.backgroundColor = UIColor.rgbColor(from: 249, 249, 249)
            }
            
            if i == 0 {
                frame = CGRect(x: rangeRect.minX, y: 0, width: size.width, height: itemHeight)
            } else {
                if frontRect.maxX + itemSpace + size.width <= rangeRect.maxX {
                    frame = CGRect(x: frontRect.maxX + itemSpace, y: frontRect.minY, width: size.width, height: itemHeight)
                } else {
                    frame = CGRect(x: rangeRect.minX, y: frontRect.maxY + lineSpace, width: size.width, height: itemHeight)
                }
            }
            
            button.frame = frame
            mnemonicContentView.addSubview(button)
            frontRect = button.frame
            totalButtons.append(button)
        }
        //var rect = mnemonicContentView.frame
        //rect.size.height = (frontRect.maxY + 15) <= 65 ? 65 : (frontRect.maxY + 15)
        //mnemonicContentView.frame = rect
        return (frontRect.maxY + 15) <= 28 ? 28 : (frontRect.maxY + 15)
    }
    func calculate(text: String, width: CGFloat, fontSize: CGFloat, lineSpace: CGFloat = -1) -> CGSize {
        
        if text.isEmpty {
            return CGSize()
        }
        
        var attributes : Dictionary<NSAttributedString.Key, Any>
        let paragraph = NSMutableParagraphStyle.init()
        paragraph.lineSpacing = lineSpace
        
        if lineSpace < 0 {
            attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize)]
        }else{
            attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize),NSAttributedString.Key.paragraphStyle:paragraph]
        }
        let rect = text.boundingRect(with: CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: attributes, context: nil)
        
        let height : CGFloat
        if rect.origin.x < 0 {
            height = abs(rect.origin.x) + rect.height
        }else{
            height = rect.height
        }
        
        return CGSize(width: rect.width + 20, height: height)
    }
    
    @objc func selectAction(button: UIButton) {
        
        
        if button.isSelected == false {
            self.actions.append(button.currentTitle ?? "")
        } else {
            let index = self.actions.firstIndex(of: button.currentTitle ?? "")
            self.actions.remove(at: index ?? 0)
            print(index)
        }
        button.isSelected = !button.isSelected
        
        self.totalButtons.forEach { (btn) in
            if btn.isSelected == true {
                btn.backgroundColor = JXMainColor
            } else {
                btn.backgroundColor = UIColor.rgbColor(from: 249, 249, 249)
            }
        }
        
        
        self.tableView?.reloadData()
        self.tableView?.scrollToRow(at: IndexPath(row: self.actions.count - 1, section: 0), at: .bottom, animated: true)
    }
}
extension ActionListController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let s = self.actions[textField.tag]
        if s != textField.text, textField.text?.isEmpty == false {
            self.actions[textField.tag] = textField.text ?? ""
            
            let index = UserManager.shareInstance.userModel.totalTrainActions.index(of: s)
            
            let btn = self.totalButtons[index ?? 0]
            btn.setTitle(textField.text ?? "", for: .normal)
            
            UserManager.shareInstance.userModel.totalTrainActions[index ?? 0] = textField.text ?? ""
            
            UserManager.shareInstance.userModel.totalTrainActionsStr = UserManager.shareInstance.splice(arr: UserManager.shareInstance.userModel.totalTrainActions)
            UserManager.shareInstance.updateUserInfo()
              
            return textField.resignFirstResponder()
        } else {
            return false
        }
    }
}
