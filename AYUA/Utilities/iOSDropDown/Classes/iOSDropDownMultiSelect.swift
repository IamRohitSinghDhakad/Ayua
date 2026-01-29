import UIKit

@objc(JRMultiSelectDropDown)
open class MultiSelectDropDown: UITextField {

    // MARK: - Selection Mode
    public enum SelectionMode {
        case single
        case multiple
    }

    public var selectionMode: SelectionMode = .multiple
    
    

    // MARK: - Data
    public var optionArray: [String] = [] {
        didSet {
            selectedIndexes.removeAll()
            tableView?.reloadData()
        }
    }

    public var optionIds: [Int] = [] {
        didSet {
            tableView?.reloadData()
        }
    }

    private var selectedIndexes = Set<Int>()

    // MARK: - UI
    private var blurView: UIVisualEffectView?
    private var containerView: UIView?
    private var tableView: UITableView?
    private var doneButton: UIButton?
    private var titleLabel: UILabel?

    // MARK: - Callback
    public var didSelectCompletion: (([String], [Int]) -> Void)?

    // MARK: - Init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        delegate = self
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openDropdown)))
    }

    // MARK: - Open
    @objc private func openDropdown() {
        guard let parent = parentViewController else { return }

        tableView?.reloadData()
        
        // 🔹 Blur Background (20%)
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
        blur.frame = parent.view.bounds
        blur.alpha = 0.5
        parent.view.addSubview(blur)
        blurView = blur

        blur.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(closeDropdown))
        )

        // 🔹 Center Card
        let container = UIView()
        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = 16
        container.translatesAutoresizingMaskIntoConstraints = false
        parent.view.addSubview(container)
        containerView = container

        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: parent.view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: parent.view.centerYAnchor),
            container.widthAnchor.constraint(equalTo: parent.view.widthAnchor, multiplier: 0.85),
            container.heightAnchor.constraint(equalToConstant: 420)
        ])

        // 🔹 Title
        let title = UILabel()
        title.text = placeholder ?? "Select Options"
        title.font = .boldSystemFont(ofSize: 18)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(title)
        titleLabel = title

        // 🔹 Table
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 48
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(table)
        tableView = table

        // 🔹 Done Button
        let done = UIButton(type: .system)
        done.setTitle("Done", for: .normal)
        done.backgroundColor = .systemBlue
        done.setTitleColor(.white, for: .normal)
        done.layer.cornerRadius = 12
        done.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        done.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(done)
        doneButton = done

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            table.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12),
            table.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: done.topAnchor, constant: -12),

            done.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            done.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            done.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
            done.heightAnchor.constraint(equalToConstant: 44)
        ])

        if selectionMode == .single {
            done.isHidden = true
        }

        animateIn()
    }

    // MARK: - Close
    @objc private func closeDropdown() {
        animateOut {
            self.blurView?.removeFromSuperview()
            self.containerView?.removeFromSuperview()
            self.blurView = nil
            self.containerView = nil
        }
    }

    // MARK: - Done
    @objc private func doneTapped() {
        let titles = selectedIndexes.map { optionArray[$0] }
        let ids = selectedIndexes.map { optionIds[safe: $0] ?? 0 }

        text = titles.joined(separator: ", ")
        didSelectCompletion?(titles, ids)
        closeDropdown()
    }

    // MARK: - Animations
    private func animateIn() {
        containerView?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        containerView?.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.containerView?.transform = .identity
            self.containerView?.alpha = 1
        }
    }

    private func animateOut(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            self.containerView?.alpha = 0
        }) { _ in completion() }
    }
}

// MARK: - Table
extension MultiSelectDropDown: UITableViewDelegate, UITableViewDataSource {
    
    public func reloadData() {
        selectedIndexes.removeAll()
        tableView?.reloadData()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        optionArray.count
    }

    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = optionArray[indexPath.row]
        cell.selectionStyle = .none
        cell.accessoryType = selectedIndexes.contains(indexPath.row) ? .checkmark : .none
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if selectionMode == .single {
            selectedIndexes = [indexPath.row]
            doneTapped()
            return
        }

        if selectedIndexes.contains(indexPath.row) {
            selectedIndexes.remove(indexPath.row)
        } else {
            selectedIndexes.insert(indexPath.row)
        }

        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

// MARK: - UITextField
extension MultiSelectDropDown: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        false
    }
}

// MARK: - Helpers
extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
