

import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//login
  Future loginUserWithEmailandPass(String email,
      String password) async {
    try{
      User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password))
          .user!;
      if(user!=null){
        return true;
      }
    } on FirebaseAuthException catch(e){

      return e.message;
    }
  }


  Future registerUserWithEmailandPass(String fullName, String email,
      String password) async{
    try{
        User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password))
            .user!;
        if(user!=null){
          //call database service
        await  DatabaseService(uid: user.uid).savingUserData(fullName, email);
          return true;
        }
    } on FirebaseAuthException catch(e){

      return e.message;
    }
  }

  Future signOut () async{
    await HelperFunctions.saveUserLoggedInStatus(false);
    await HelperFunctions.saveUserEmailSF("");
    await HelperFunctions.saveUserNameSF("");
    await firebaseAuth.signOut();
    try{
    }catch (e){
      return null;
    }
  }
}