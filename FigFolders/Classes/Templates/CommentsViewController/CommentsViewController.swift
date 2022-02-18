//
//  CommentsViewControllerViewController.swift
//  FigFolders
//
//  Created by Lourdes on 1/23/22.
//

import UIKit

class CommentsViewController: ViewControllerWithLoading {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCommentButton: UIButton!
    
    let viewModel = CommentsViewModel()
    var figFileModel: FigFileModel?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = viewModel.pageTitle
        setupView()
    }
    
    private func setupView() {
        addCommentButton.setRoundedCorners()
        registerCells()
        setupDatasourceDelegate()
    }
    
    private func registerCells() {
        let profileNib = UINib(nibName: CommentsTableViewCell.kCellId, bundle: Bundle.main)
        tableView.register(profileNib, forCellReuseIdentifier: CommentsTableViewCell.kCellId)
    }
    
    private func setupDatasourceDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Button Tap Actions
    @IBAction func onTapAddCommentButton(_ sender: Any) {
        guard let addCommentViewController = AddCommentViewController.initiateVC() else { return }
        self.navigationController?.pushViewController(addCommentViewController, animated: true)
    }
}


// MARK: - TableView Datasource
extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let commentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: CommentsTableViewCell.kCellId) as? CommentsTableViewCell,
              indexPath.section == 0 else {
            return UITableViewCell()
        }
        commentsTableViewCell.delegate = self
        
        if (indexPath.row % 2) == 0 {
            let comment = FigFilesCommentsModel(userName: "bhjhfhvxbgh", commentString: "fdsfdsfdsfdsfdsfds", commentAddedDate: "", commentId: "")
            commentsTableViewCell.setupCell(comment: comment, indexPath: indexPath)
        } else {
            let comment = FigFilesCommentsModel(userName: "bhjhfhvxbgh", commentString: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown pr PageMaker including versions of Lorem Ipsum.", commentAddedDate: "", commentId: "")
            commentsTableViewCell.setupCell(comment: comment, indexPath: indexPath)
        }
        
        return commentsTableViewCell
    }
}

// MARK: - TableView Delegate
extension CommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - Comment ViewController Delegate
extension CommentsViewController: CommentTableViewDelegate {
    func didBeginEdittingCommentAtIndexpath(indexPath: IndexPath) {
        guard let addCommentViewController = AddCommentViewController.initiateVC() else { return }
        addCommentViewController.comment = viewModel.getCommentModelAtIndexpath(indexPath: indexPath)
        self.navigationController?.pushViewController(addCommentViewController, animated: true)
    }
    
    func didEndEdittingCommentAtIndexpath(indexPath: IndexPath) {
    }
}
