//
//  TableViewController2.swift
//  Ntwrk
//
import UIKit


class TableViewController2: UITableViewController {
    
    var RefArray:[Ref] = [Ref]()
    var RefData = ["Michayal","Hayley","Billy","Cyrus","ElonMusk","MichaelScott","KobeBryant","EKingGill","JeffZhao"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let Michayal = Ref(imageName: "Michayal.jpg", description: "Michayal Mathew", position:  "Intern at NASA", location: "College Station, TX")
        let Hayley = Ref(imageName: "Hayley.jpg", description: "Hayley Eckert", position: "Intern at Google", location: "College Station, TX")
        let Billy = Ref(imageName: "Billy.jpg", description: "Bill Newman", position: "Intern at AT&T", location: "College Station, TX")
        let Cyrus = Ref(imageName: "Cyrus.jpg", description: "Cyrus Roshan", position: "Intern at LinkedIn", location: "Dallas, TX")
        let ElonMusk = Ref(imageName: "ElonMusk.jpg", description: "Elon Musk", position: "CEO of Tesla/SpaceX", location: "Mars")
        let MichaelScott = Ref(imageName: "MichaelScott.JPEG", description: "Michael Scott", position: "Dunder Mifflin, Inc.", location: "Scranton, PA")
        let EKingGill = Ref(imageName: "EKingGill.JPEG", description: "E King Gill", position: "12th Man", location: "College Station, TX")

        RefArray.append(Michayal)
        RefArray.append(Hayley)
        RefArray.append(Billy)
        RefArray.append(Cyrus)
        RefArray.append(ElonMusk)
        RefArray.append(MichaelScott)
        RefArray.append(EKingGill)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RefArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath as IndexPath) as! myCell2
        
        let RefItem = RefArray[indexPath.row]
        
        cell2.myImageView.image = UIImage(named: RefItem.imageName)
        cell2.NameLabel.text = RefItem.description
        cell2.PosLabel.text = RefItem.position
        
        return cell2
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let RefSelected = RefArray[indexPath.row]
        
        let DetailVC:DetailViewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewcontroller
        
        
        DetailVC.RefImage = RefSelected.imageName
        DetailVC.RefName = RefSelected.description
        DetailVC.RefPos = RefSelected.position
        DetailVC.RefLoc = RefSelected.location

        self.present(DetailVC, animated: true, completion: nil)
    }
    
    
    
}
