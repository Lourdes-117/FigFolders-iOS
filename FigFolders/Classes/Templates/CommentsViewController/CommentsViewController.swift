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
    var figFileModel: FigFileModel? {
        didSet {
            viewModel.figFileModel = figFileModel
        }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = viewModel.pageTitle
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.pagination = 0
        viewModel.comments = []
        initiageAPICall()
    }
    
    private func setupView() {
        showLoadingIndicator()
        addCommentButton.setRoundedCorners()
        addCommentButton.addShadow(location: .all)
        registerCells()
        setupDatasourceDelegate()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
    }
    
    private func registerCells() {
        let profileNib = UINib(nibName: CommentsTableViewCell.kCellId, bundle: Bundle.main)
        tableView.register(profileNib, forCellReuseIdentifier: CommentsTableViewCell.kCellId)
    }
    
    private func setupDatasourceDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func initiageAPICall() {
        viewModel.getCommentsWithPagination { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.hideLoadingIndicatorView()
            strongSelf.tableView.reloadData()
            if strongSelf.viewModel.pagination == 0 && strongSelf.viewModel.numberOfCells == 0 {
                strongSelf.tableView.isHidden = true
            } else {
                strongSelf.tableView.isHidden = false
            }
        }
    }
    
    // MARK: - Button Tap Actions
    @IBAction func onTapAddCommentButton(_ sender: Any) {
        guard let addCommentViewController = AddCommentViewController.initiateVC() else { return }
        addCommentViewController.fileUrl = viewModel.figFileModel?.fileUrl
        addCommentViewController.fileOwner = viewModel.figFileModel?.ownerUsername
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
              let commentToShow = viewModel.getCommentModelAtIndexpath(indexPath: indexPath) else {
            return UITableViewCell()
        }
        commentsTableViewCell.delegate = self
        commentsTableViewCell.setupCell(comment: commentToShow, indexPath: indexPath)
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.isCommentFromCurrentUser(row: indexPath.row) { //Edit only if it's your comment
            presentEditCommentViewControllerWithCommentAt(indexPath: indexPath)
        } else { return }
    }
    
    private func presentEditCommentViewControllerWithCommentAt(indexPath: IndexPath) {
        guard let addCommentViewController = AddCommentViewController.initiateVC(),
        let commentToEdit = viewModel.getCommentModelAtIndexpath(indexPath: indexPath) else { return }
        addCommentViewController.comment = commentToEdit
        addCommentViewController.fileUrl = viewModel.figFileModel?.fileUrl
        addCommentViewController.fileOwner = viewModel.figFileModel?.ownerUsername
        addCommentViewController.indexPath = indexPath
        self.navigationController?.pushViewController(addCommentViewController, animated: true)
    }
}

// MARK: - Comment ViewController Delegate
extension CommentsViewController: CommentTableViewDelegate {
    func didBeginEdittingCommentAtIndexpath(indexPath: IndexPath) {
        presentEditCommentViewControllerWithCommentAt(indexPath: indexPath)
    }
    
    func deselectSelectedText() {
        view.endEditing(true)
    }
    
    func editCommentWithCommentId(commentId: String) {
        guard let indexOfComment = viewModel.getIndexOfComment(commentId: commentId) else { return }
        presentEditCommentViewControllerWithCommentAt(indexPath: IndexPath(row: indexOfComment, section: 0))
    }
}
