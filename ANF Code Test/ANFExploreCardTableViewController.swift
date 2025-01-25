//
//  ANFExploreCardTableViewController.swift
//  ANF Code Test
//

import UIKit

class ANFExploreCardTableViewController: UITableViewController {
    public var exploreData: [ANFExploreData] = []
    public var exploreService: ANFExploreServiceProtocol = ANFExploreService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = nil
        fetchData()
    }

    private func fetchData() {
        exploreService.fetchExploreData { [weak self] data in
            DispatchQueue.main.async {
                self?.exploreData = data ?? []
                self?.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exploreData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "exploreContentCell", for: indexPath) as? ExploreContentCell else {
            return UITableViewCell()
        }

        let item = exploreData[indexPath.row]

        configureTitle(for: cell, with: item)
        configureImage(for: cell, with: item)
        configureTopDescription(for: cell, with: item)
        configurePromoMessage(for: cell, with: item)
        configureBottomDescription(for: cell, with: item)
        configureButtons(for: cell, with: item, at: indexPath)

        return cell
    }
    
    private func configureTitle(for cell: UITableViewCell, with item: ANFExploreData) {
        if let titleLabel = cell.viewWithTag(1) as? UILabel {
            titleLabel.text = item.title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        }
    }
    
    private func configureImage(for cell: UITableViewCell, with item: ANFExploreData) {
        if let imageView = cell.viewWithTag(2) as? UIImageView,
           let activityIndicator = cell.viewWithTag(7) as? UIActivityIndicatorView {

            activityIndicator.startAnimating()
            imageView.image = nil

            if let url = URL(string: item.backgroundImage) {
                ImageLoader.shared.loadImage(from: url) { image in
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating()
                        activityIndicator.isHidden = true

                        guard let image = image else { return }
                        imageView.image = image

                        let aspectRatio = image.size.height / image.size.width
                        if let superviewWidth = imageView.superview?.frame.width {
                            let dynamicHeight = superviewWidth * aspectRatio

                            if let heightConstraint = imageView.constraints.first(where: { $0.firstAttribute == .height }) {
                                heightConstraint.constant = dynamicHeight
                            } else {
                                let newHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: dynamicHeight)
                                newHeightConstraint.isActive = true
                            }

                            self.tableView.beginUpdates()
                            self.tableView.endUpdates()
                        }
                    }
                }
            }
        }
    }

    private func configureImage(for cell: ExploreContentCell, with item: ANFExploreData) {
        cell.backgroundImage.image = nil

        if let imageView = cell.viewWithTag(2) as? UIImageView,
           let activityIndicator = cell.viewWithTag(7) as? UIActivityIndicatorView {
            
            if let url = URL(string: item.backgroundImage) {
                ImageLoader.shared.loadImage(from: url) { image in
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating()
                        guard let image = image else { return }
                        imageView.image = image
                        
                        let aspectRatio = image.size.height / image.size.width
                        cell.imageHeightConstraint.constant = cell.contentView.frame.width * aspectRatio
                        
                        UIView.animate(withDuration: 0.3) {
                            cell.layoutIfNeeded()
                        }
                        
                        self.tableView.beginUpdates()
                        self.tableView.endUpdates()
                    }
                }
            }
        }
    }
    
    private func configureTopDescription(for cell: UITableViewCell, with item: ANFExploreData) {
        if let topDescriptionLabel = cell.viewWithTag(3) as? UILabel {
            topDescriptionLabel.text = item.topDescription
            topDescriptionLabel.font = UIFont.systemFont(ofSize: 13)
            topDescriptionLabel.isHidden = item.topDescription?.isEmpty ?? true
        }
    }

    private func configurePromoMessage(for cell: UITableViewCell, with item: ANFExploreData) {
        if let promoLabel = cell.viewWithTag(4) as? UILabel {
            promoLabel.text = item.promoMessage
            promoLabel.font = UIFont.systemFont(ofSize: 11)
            promoLabel.isHidden = item.promoMessage?.isEmpty ?? true
        }
    }

    private func configureBottomDescription(for cell: UITableViewCell, with item: ANFExploreData) {
        if let bottomDescriptionLabel = cell.viewWithTag(5) as? UILabel {
            let sanitizedDescription = item.bottomDescription?.sanitizedHTMLString ?? ""
            bottomDescriptionLabel.attributedText = sanitizedDescription.htmlToAttributedString
            bottomDescriptionLabel.textAlignment = .center
            bottomDescriptionLabel.font = UIFont.systemFont(ofSize: 13)
            bottomDescriptionLabel.isHidden = sanitizedDescription.isEmpty

            bottomDescriptionLabel.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBottomDescriptionTap(_:)))
            bottomDescriptionLabel.addGestureRecognizer(tapGesture)
        }
    }

    
    private func configureButtons(for cell: UITableViewCell, with item: ANFExploreData, at indexPath: IndexPath) {
        if let buttonContainer = cell.viewWithTag(6) as? UIStackView {
            buttonContainer.arrangedSubviews.forEach { $0.removeFromSuperview() } // Clear existing buttons

            item.content?.forEach { contentItem in
                let button = UIButton(type: .system)
                button.setTitle(contentItem.title, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = .white
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.lightGray.cgColor

                button.translatesAutoresizingMaskIntoConstraints = false
                button.heightAnchor.constraint(equalToConstant: 48).isActive = true

                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                button.restorationIdentifier = contentItem.target

                buttonContainer.addArrangedSubview(button)

                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor),
                    button.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor),
                ])
            }

            buttonContainer.isHidden = item.content?.isEmpty ?? true
        }
    }


    @objc private func buttonTapped(_ sender: UIButton) {
        if let target = sender.restorationIdentifier  {
            guard let url = URL(string: target) else { return }
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func handleBottomDescriptionTap(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel,
              let attributedText = label.attributedText else { return }
        
        attributedText.enumerateAttribute(.link, in: NSRange(location: 0, length: attributedText.length)) { value, range, _ in
            if let url = value as? URL {
                UIApplication.shared.open(url)
            }
        }
    }
}
