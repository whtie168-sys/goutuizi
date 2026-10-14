import UIKit

/// 首页：待完成 / 已完成 两组跑腿任务
final class ErrandListViewController: UITableViewController {
    private let store = ErrandStore.shared
    private let summaryLabel = UILabel()

    init() { super.init(style: .insetGrouped) }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "狗腿子"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        tableView.register(ErrandCell.self, forCellReuseIdentifier: ErrandCell.reuseID)

        summaryLabel.textAlignment = .center
        summaryLabel.font = .preferredFont(forTextStyle: .footnote)
        summaryLabel.textColor = .secondaryLabel
        summaryLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 44)
        tableView.tableFooterView = summaryLabel
        reload()
    }

    private func reload() {
        summaryLabel.text = String(format: "待跑 %d 单 · 已赚 ¥%.2f", store.pending.count, store.totalIncome)
        tableView.backgroundView = store.errands.isEmpty ? emptyLabel() : nil
        tableView.reloadData()
    }

    private func emptyLabel() -> UILabel {
        let label = UILabel()
        label.text = "还没有跑腿任务\n点右上角 + 接一单"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }

    private func items(in section: Int) -> [Errand] {
        section == 0 ? store.pending : store.finished
    }

    private func showEditor(_ errand: Errand?) {
        let editor = ErrandEditViewController(errand: errand) { [weak self] saved in
            self?.store.upsert(saved)
            self?.reload()
        }
        present(UINavigationController(rootViewController: editor), animated: true)
    }

    @objc private func addTapped() { showEditor(nil) }

    // MARK: - Table

    override func numberOfSections(in tableView: UITableView) -> Int { 2 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items(in: section).count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !items(in: section).isEmpty else { return nil }
        return section == 0 ? "待完成" : "已完成"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ErrandCell.reuseID, for: indexPath) as! ErrandCell
        cell.configure(with: items(in: indexPath.section)[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showEditor(items(in: indexPath.section)[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let errand = items(in: indexPath.section)[indexPath.row]
        let action = UIContextualAction(style: .normal, title: errand.isDone ? "撤回" : "完成") { [weak self] _, _, done in
            self?.store.toggle(errand.id)
            self?.reload()
            done(true)
        }
        action.backgroundColor = errand.isDone ? .systemGray : .systemGreen
        return UISwipeActionsConfiguration(actions: [action])
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let errand = items(in: indexPath.section)[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "删除") { [weak self] _, _, done in
            self?.store.delete(errand.id)
            self?.reload()
            done(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}
