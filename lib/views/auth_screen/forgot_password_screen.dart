import 'package:firebase_auth/firebase_auth.dart';
import '../../consts/consts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  var emcontroller = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  forgetPassword({email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Change Password"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "Enter Your Account Email Down Here".text.color(redColor).make(),
            10.heightBox,
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: emcontroller,
                decoration: const InputDecoration(
                  isDense: true,
                  alignLabelWithHint: true,
                  labelText: "Email",
                  hintText: "example@abc.com",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await forgetPassword(email: emcontroller.text);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              child: const Text("Send Request"),
            ),
          ],
        ),
      ),
    );
  }
}
