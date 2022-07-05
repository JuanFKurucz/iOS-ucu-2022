import UIKit

class PatientsViewController: UIViewController {
    static let identifier: String = "PatientsViewController"

    @IBOutlet var patientsTableView: UITableView!
    @IBOutlet var searchBarField: UISearchBar!
    @IBOutlet var filterButton: UIButton!
    
    let patientBackgrounds: [CGColor] = [
        CGColor(red: 220/255, green: 237/255, blue: 249/255, alpha: 1.0),
        CGColor(red: 241/255, green: 230/255, blue: 234/255, alpha: 1.0),
        CGColor(red: 250/255, green: 240/255, blue: 219/255, alpha: 1.0)
    ]

    var patients: [PatientModel] = []
    var filterPatients: [PatientModel] = []

    var filterName: String?
    var filterGender: Gender?

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBarField.delegate = self
        patientsTableView.delegate = self
        patientsTableView.dataSource = self

        patientsTableView.register(UINib(nibName: PatientTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PatientTableViewCell.identifier)
    }

    func filterElements(name: String?, gender: Gender?) {
        filterName = name
        filterGender = gender

        if filterName == nil || filterName!.count == 0 {
            if filterGender != nil {
                filterPatients = []
                for patient in patients {
                    if patient.gender == filterGender {
                        filterPatients.append(patient)
                    }
                }
            } else {
                filterPatients = patients
            }
        } else {
            filterPatients = []
            for patient in patients {
                if patient.getInformation().lowercased().contains(filterName!.lowercased()) {
                    if filterGender == nil || patient.gender == filterGender {
                        filterPatients.append(patient)
                    }
                }
            }
        }
        patientsTableView.reloadData()
    }

    @IBAction func onTapFilter(_: Any) {
        let alertController = UIAlertController(title: "Filter patients", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "View all", style: .default, handler: { _ in
            self.filterGender = nil
            self.filterElements(name: self.filterName, gender: self.filterGender)
        }))
        alertController.addAction(UIAlertAction(title: "View male patients", style: .default, handler: { _ in
            self.filterGender = Gender.male
            self.filterElements(name: self.filterName, gender: self.filterGender)
        }))
        alertController.addAction(UIAlertAction(title: "View female patients", style: .default, handler: { _ in
            self.filterGender = Gender.female
            self.filterElements(name: self.filterName, gender: self.filterGender)
        }))
        alertController.addAction(UIAlertAction(title: "Filter", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        APIHealthAssitant.getPatients(onComplete: { p in
            self.patients = p
            self.filterPatients = p
            self.patientsTableView.reloadData()
        }, onFail: { _ in
            Alert.showAlertBox(currentViewController: self, title: "Invalid retrieve patients", message: "Could not retrieve patients")
        })
    }

    @IBAction func onTapNewPatient(_: Any) {
        _ = Navigation.jumpToView(currentViewController: self, nextViewController: NewPatientViewController.identifier)
    }
}

extension PatientsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        filterPatients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PatientTableViewCell.identifier) as! PatientTableViewCell
        let patient = filterPatients[indexPath.row]
        cell.nameLabel.text = "\(patient.identification) - \(patient.fullName)"
        cell.genderLabel.text = "Gender: \(patient.gender.text)"
        if let decodedImage = ImageUtils.base64ToImage(base64: patient.imageBase64) {
            cell.profileImageView.image = decodedImage
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 4
            cell.profileImageView.clipsToBounds = true
            cell.backgroundRectView.layer.backgroundColor = self.patientBackgrounds[indexPath.row % self.patientBackgrounds.count]
        }
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let patientProfile = Navigation.jumpToView(currentViewController: self, nextViewController: "PatientProfileViewController") as! PatientProfileViewController
        patientProfile.patient = filterPatients[indexPath.row]
    }
}

extension PatientsViewController: UISearchBarDelegate, UISearchDisplayDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        filterName = searchText
        filterElements(name: filterName, gender: filterGender)
    }
}
