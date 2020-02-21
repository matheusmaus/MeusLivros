import Firebase

class UserAPI {

  static let db = Firestore.firestore().collection("users")
  
  static func createUser(user: User) {
    db.addDocument(data: [
      "name": user.name,
      "email": user.email
    ])
  }

  static func saveUser(user: User) {
    db.document(user.id)
      .setData([
        "name": user.name,
        "email": user.email
      ])
  }

  static func getUser(by userId: String,
                      completion: @escaping (User) -> (),
                      error: @escaping (Error?) -> ()) {
    db.document(userId).addSnapshotListener { (snapshot, _) in
      guard let data = snapshot?.data() else {
        error(nil)
        return
      }

      guard
        let name = data["name"] as? String,
        let email = data["email"] as? String
      else {
        error(nil)
        return
      }

      let user = User(id: userId, email: email, name: name)

      completion(user)
    }
  }
}
