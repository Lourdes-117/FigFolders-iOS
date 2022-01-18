//
//  PdfViewerViewController.swift
//  FigFolders
//
//  Created by Lourdes on 1/18/22.
//

import UIKit
import PDFKit

class PDFViewerViewController: ViewControllerWithLoading {
    var fileUrl: URL? {
        didSet {
            setupPdfViewer()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func setupPdfViewer() {
        showLoadingIndicator()
        let pdfView = PDFView(frame: self.view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(pdfView)
        
        // Fit content in PDFView.
        pdfView.autoScales = true
        
        guard let fileUrl = fileUrl else { return }
        StorageManager.shared.downloadFileWithUrl(fileUrl) { [weak self] data, error in
            self?.hideLoadingIndicatorView()
            guard let data = data else { return }
            pdfView.document = PDFDocument(data: data)
        }
    }
}
