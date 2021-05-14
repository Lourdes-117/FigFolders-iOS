//
//  OnboardingCollectionView.swift
//  FigFolders
//
//  Created by Lourdes on 5/10/21.
//

import UIKit

protocol OnboardingCollectionViewDelegate: NSObjectProtocol {
    func didFinishOnboarding()
}

class OnboardingCollectionView: UIView {
    static let kIdentifier = "OnboardingCollectionView"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    weak var delegate: OnboardingCollectionViewDelegate?
    
    let viewModel = OnboardingCollectionViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit(OnboardingCollectionView.kIdentifier)
        initialSetup()
    }
    
    fileprivate func initialSetup() {
        setupDatasourceDelegate()
        setupUI()
        registerCells()
    }
    
    fileprivate func setupDatasourceDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    fileprivate func setupUI() {
        pageControl.numberOfPages = viewModel.numberOfCells
        pageControl.currentPage = viewModel.currentIndex
    }
    
    fileprivate func registerCells() {
        collectionView.register(UINib(nibName: OnboardingCollectionViewCell.kIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: OnboardingCollectionViewCell.kIdentifier)
    }
    
    @IBAction func onTapNextButton(_ sender: Any) {
        guard let nextIndex = viewModel.nextIndex else {
            delegate?.didFinishOnboarding()
            return
        }
        pageControl.currentPage = viewModel.currentIndex
        collectionView.scrollToItem(at: nextIndex, at: .right, animated: true)
    }
    
    @IBAction func onTapSkipButton(_ sender: Any) {
        delegate?.didFinishOnboarding()
    }
}

// MARK :- CollectionView Datasource And Delegate

extension OnboardingCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.kIdentifier, for: indexPath) as? OnboardingCollectionViewCell else { return UICollectionViewCell() }
        let title = viewModel.getTitleAtIndex(indexPath.row)
        let firstLine = viewModel.getContentFirstLineAtIndex(indexPath.row)
        let secondLine = viewModel.getContentSecondLineAtIndex(indexPath.row)
        cell.setupCell(title: title, firstLine: firstLine, secondLine: secondLine)
        
        return cell
    }
}

extension OnboardingCollectionView: UICollectionViewDelegate {
    
}

extension OnboardingCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
}
