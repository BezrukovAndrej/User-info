import UIKit

extension UIViewController {
    
    func presentSimpleAlert(title: String, message: String?) {
        
        let alertController = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let oKaction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(oKaction)
        present(alertController, animated: true)
    }
    
    func presentChangeAlert(complitionHandler: @escaping(Bool) -> Void) {
        
        let alertController = UIAlertController(title: "Данные были изменены",
                                      message: """
                                              Вы жедаете сохранить изменения, в противном случай
                                              внесенные правки будут отменены
                                              """,
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Созранить", style: .default) { _ in
            complitionHandler(true)
        }
        let scipAction = UIAlertAction(title: "Пропустить", style: .default) { _ in
            complitionHandler(false)
        }
        alertController.addAction(saveAction)
        alertController.addAction(scipAction)
        present(alertController, animated: true)
    }
}
