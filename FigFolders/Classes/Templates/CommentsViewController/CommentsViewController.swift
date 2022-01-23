//
//  CommentsViewControllerViewController.swift
//  FigFolders
//
//  Created by Lourdes on 1/23/22.
//

import UIKit

class CommentsViewController: UIViewController {

    let viewModel = CommentsViewModel()
    var figFileModel: FigFileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = viewModel.pageTitle
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
