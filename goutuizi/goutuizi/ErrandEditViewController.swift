import UIKit

/// 新建 / 编辑跑腿任务
final class ErrandEditViewController: UIViewController {
    private var errand: Errand
    private let isNew: Bool
    private let onSave: (Errand) -> Void

    private let titleField = UITextField()
    private let addressField = UITextField()
    private let feeField = UITextField()

    init(errand: Errand?, onSave: @escaping (Errand) -> Void) {
        self.errand = errand ?? Errand(title: "", address: "", fee: 0)
        self.isNew = errand == nil
        self.onSave = onSave
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = isNew ? "接一单" : "编辑任务"
        view.backgroundColor = .systemGroupedBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))

        setup(titleField, placeholder: "要办什么事，如：取快递", text: errand.title)
        setup(addressField, placeholder: "地址（可选）", text: errand.address)
        setup(feeField, placeholder: "跑腿费（元）", text: isNew ? "" : String(format: "%.2f", errand.fee))
        feeField.keyboardType = .decimalPad

        let stack = UIStackView(arrangedSubviews: [titleField, addressField, feeField])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
        titleField.becomeFirstResponder()
    }

    private func setup(_ field: UITextField, placeholder: String, text: String) {
        field.placeholder = placeholder
        field.accessibilityLabel = placeholder
        field.text = text
        field.backgroundColor = .secondarySystemGroupedBackground
        field.layer.cornerRadius = 10
        field.font = .preferredFont(forTextStyle: .body)
        field.adjustsFontForContentSizeCategory = true
        field.clearButtonMode = .whileEditing
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        field.leftViewMode = .always
        field.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
    }

    @objc private func cancelTapped() { dismiss(animated: true) }

    @objc private func saveTapped() {
        let title = titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !title.isEmpty else {
            let alert = UIAlertController(title: "请填写要办的事", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好", style: .default))
            present(alert, animated: true)
            return
        }
        errand.title = title
        errand.address = addressField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        errand.fee = Double(feeField.text?.replacingOccurrences(of: ",", with: ".") ?? "") ?? 0
        onSave(errand)
        dismiss(animated: true)
    }
}
