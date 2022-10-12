import 'package:flutter/material.dart';
import 'package:invoice_maker/main.dart';
import 'package:invoice_maker/models/save_data.dart';
import 'package:invoice_maker/services/gsheets_services.dart';
import 'package:invoice_maker/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

class AddUserDetailsScreen extends StatefulWidget {
  @override
  _AddUserDetailsScreenState createState() => _AddUserDetailsScreenState();
}

class _AddUserDetailsScreenState extends State<AddUserDetailsScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController ageCont = TextEditingController();
  TextEditingController genderCont = TextEditingController();
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      showConfirmDialogCustom(
        context,
        dialogType: DialogType.ADD,
        dialogAnimation: DialogAnimation.SCALE,
        onAccept: (c) async {
          hideKeyboard(context);
          appStore.setLoading(true);
          SaveData tempSaveData = SaveData()
            ..age = ageCont.text.trim()
            ..lastName = lNameCont.text.trim()
            ..firstName = fNameCont.text.trim()
            ..gender = selectedGender.capitalizeFirstLetter()
            ..createdAt = DateTime.now().microsecondsSinceEpoch.toString()
            ..updatedAt = DateTime.now().microsecondsSinceEpoch.toString()
            ..userName = userNameCont.text.trim();

          await GSheetsServices.addEntry(saveData: tempSaveData).then((value) {
            finish(context);
          });

          appStore.setLoading(false);
        },
      );
    }
  }

  Widget _buildBodyWidget() {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                AppTextField(
                  textFieldType: TextFieldType.NAME,
                  controller: fNameCont,
                  decoration: inputDecoration(context, label: "First Name", prefixIcon: Icon(LineIcons.address_card)),
                ),
                16.height,
                AppTextField(
                  textFieldType: TextFieldType.NAME,
                  controller: lNameCont,
                  decoration: inputDecoration(context, label: "Last Name", prefixIcon: Icon(LineIcons.address_card)),
                ),
                16.height,
                AppTextField(
                  textFieldType: TextFieldType.USERNAME,
                  controller: userNameCont,
                  decoration: inputDecoration(context, label: "UserName", prefixIcon: Icon(LineIcons.user_ninja)),
                ),
                16.height,
                AppTextField(
                  textFieldType: TextFieldType.PHONE,
                  controller: ageCont,
                  decoration: inputDecoration(context, label: "Age", prefixIcon: Icon(LineIcons.sign_language)),
                ),
                16.height,
                DropdownButtonFormField<String>(
                  items: [
                    DropdownMenuItem(
                      child: Text("Male", style: primaryTextStyle()),
                      value: 'male',
                    ),
                    DropdownMenuItem(
                      child: Text("Female", style: primaryTextStyle()),
                      value: 'female',
                    )
                  ],
                  decoration: inputDecoration(context, label: 'Gender'),
                  value: selectedGender,
                  onChanged: (c) {
                    selectedGender = c;
                    setState(() {});
                  },
                ),
                16.height,
              ],
            ),
          ),
        ),
        loaderWidgetWithObserver()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("User Detail", elevation: 0),
      body: _buildBodyWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: _submitForm,
      ),
    );
  }
}
