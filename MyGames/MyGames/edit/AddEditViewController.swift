//
//  AddEditViewController.swift
//  MyGames
//
//  Created by Beatriz Castro on 27/04/21.
//

import UIKit
import Photos

class AddEditViewController: UIViewController {
    
    var game: Game!
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfConsole: UITextField!
    @IBOutlet weak var dpReleaseDate: UIDatePicker!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var btCover: UIButton!
    @IBOutlet weak var ivCover: UIImageView!
    
    lazy var pickerView: UIPickerView = {
           let pickerView = UIPickerView()
           pickerView.delegate = self
           pickerView.dataSource = self
           pickerView.backgroundColor = .white
           return pickerView
       }()
    
   var consolesManager = ConsolesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        consolesManager.loadConsoles(with: context)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareDataLayout()
    }
    
    ///
    /// - returns irá setar os dados do game caso a tela seja aberta em modo de ediçao, e criar um ToolBar para escolher o console
    func prepareDataLayout() {
        if game != nil {
            title = "Editar jogo"
            btAddEdit.setTitle("ALTERAR", for: .normal)
            tfTitle.text = game.title
            
            // tip. alem do console pegamos o indice atual para setar o picker view
            if let console = game.console, let index = consolesManager.consoles.index(of: console) {
                tfConsole.text = console.name
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            ivCover.image = game.cover as? UIImage
            if let releaseDate = game.releaseDate {
                dpReleaseDate.date = releaseDate
            }
            if game.cover != nil {
                btCover.setTitle(nil, for: .normal)
            }
        }
        
        setPickerViewOnConsoleField()
       
    }
    
    
    ///
    /// - returns criar Toolbar com pickerView para escolher o console do game e setar ele no layout do campo de console
    func setPickerViewOnConsoleField(){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [btCancel, btFlexibleSpace, btDone]
        
        // tip. faz o text field exibir os dados predefinidos pela picker view
        tfConsole.inputView = pickerView
        tfConsole.inputAccessoryView = toolbar
    }
    
    
    /// metodo de apoio que fecha todas as toolbars e elementos afins da viewController ao cancelar escolha do console
    @objc func cancel() {
        tfConsole.resignFirstResponder()
    }
    
    /// metodo de apoio que seta o texto do console com a linha escolhida na pickeView
    @objc func done() {
        tfConsole.text = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)].name
        cancel()
    }
   
    /// action para montar e apresentar alert com opcoes de escolha da imagem do game
    @IBAction func addEditCover(_ sender: Any) {
        
        let alert = UIAlertController(title: "Selecinar capa", message: "De onde você quer escolher a capa?", preferredStyle: .actionSheet)
    
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        })
        alert.addAction(libraryAction)
        
        
        let photosAction = UIAlertAction(title: "Album de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        })
        alert.addAction(photosAction)
        
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    /// Metodo para abrir as fotos e requerir autorizacao do usuario
    /// - warning para este metodo funcionar é preciso setar as permissoes de 'Privacy - Media Library Usage Description' e 'Privacy - Photo Library Usage Description' no info.plist
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    
                    self.chooseImageFromLibrary(sourceType: sourceType)
                    
                } else {
                    
                    print("unauthorized -- TODO message")
                }
            })
        } else if photos == .authorized {
            
            self.chooseImageFromLibrary(sourceType: sourceType)
        }
    }
    
    /// Metodo para apresentar galeria e captar a escolha da imagem
    func chooseImageFromLibrary(sourceType: UIImagePickerController.SourceType) {
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.navigationBar.tintColor = UIColor(named: "main")
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    /// Metodo para salvar o novo game ou edicoes de um já existente
    @IBAction func addEditGame(_ sender: Any) {
        
        if game == nil {
          game = Game(context: context)
        }
        game.title = tfTitle.text
        game.releaseDate = dpReleaseDate.date
        
        if !tfConsole.text!.isEmpty {
              let console = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)]
              game.console = console
        }
        game.cover = ivCover.image
        
        do {
          try context.save()
        } catch {
          print(error.localizedDescription)
        }
        // Back na navigation
        navigationController?.popViewController(animated: true)
    }
    
}


extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    /// Metodo para setar o numero de informacoes que o pickerView vai ter, exemplo um pickerView com mês e ano teria dois componentes
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
 
    /// Metodo para setar o numero de elementos do pickerView de consoles
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return consolesManager.consoles.count
    }
    
    /// Bind da lista de consoles em cada linha do PickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = consolesManager.consoles[row]
        return console.name
    }
}


extension AddEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    // tip. implementando os 2 protocols o evento sera notificando apos user selecionar a imagem
   
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           
            // ImageView won't update with new image
            // bug fixed: https://stackoverflow.com/questions/42703795/imageview-wont-update-with-new-image
            DispatchQueue.main.async {
                self.ivCover.image = pickedImage
                self.ivCover.setNeedsDisplay()
                self.btCover.setTitle(nil, for: .normal)
                self.btCover.setNeedsDisplay()
            }
        }
       
        dismiss(animated: true, completion: nil)
       
    }
   
}
