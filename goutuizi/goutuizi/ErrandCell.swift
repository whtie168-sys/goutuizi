import UIKit

/// 列表单元格：标题 / 地址 / 跑腿费 / 完成状态
final class ErrandCell: UITableViewCell {
    static let reuseID = "ErrandCell"

    private let checkView = UIImageView()
    private let titleLabel = UILabel()
    private let addressLabel = UILabel()
    private let feeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        addressLabel.font = .preferredFont(forTextStyle: .subheadline)
        addressLabel.textColor = .secondaryLabel
        addressLabel.adjustsFontForContentSizeCategory = true
        feeLabel.font = .monospacedDigitSystemFont(ofSize: 17, weight: .semibold)
        feeLabel.textColor = .systemOrange
        feeLabel.setContentHuggingPriority(.required, for: .horizontal)
        checkView.contentMode = .scaleAspectFit

        let textStack = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        let row = UIStackView(arrangedSubviews: [checkView, textStack, feeLabel])
        row.spacing = 12
        row.alignment = .center
        row.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(row)
        NSLayoutConstraint.activate([
            checkView.widthAnchor.constraint(equalToConstant: 26),
            checkView.heightAnchor.constraint(equalToConstant: 26),
            row.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            row.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            row.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            row.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with errand: Errand) {
        titleLabel.text = errand.title
        addressLabel.text = errand.address.isEmpty ? "未填写地址" : errand.address
        feeLabel.text = String(format: "¥%.2f", errand.fee)
        checkView.image = UIImage(systemName: errand.isDone ? "checkmark.circle.fill" : "circle")
        checkView.tintColor = errand.isDone ? .systemGreen : .tertiaryLabel
        titleLabel.textColor = errand.isDone ? .secondaryLabel : .label
        accessibilityLabel = "\(errand.title)，\(feeLabel.text ?? "")，\(errand.isDone ? "已完成" : "待完成")"
    }
}
