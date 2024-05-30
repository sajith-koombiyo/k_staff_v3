import 'dart:convert';
import 'dart:io';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as https;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/main/drawer/genaral/add_employe/dropdown.dart';
import 'package:flutter_application_2/uI/widget/add_user_textfeald/add_user_textfeald.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../widget/diloag_button.dart';
import '../../../../widget/dropDown/dropDwon.dart';

class WorkDetails extends StatefulWidget {
  const WorkDetails(
      {super.key,
      required this.name,
      required this.addres,
      required this.birthday,
      required this.eConNumber,
      required this.gender,
      required this.nFront,
      required this.nbacke,
      required this.nic,
      required this.oConnumber,
      required this.pConNumber,
      required this.branchId});
  final String name;
  final String addres;
  final String pConNumber;
  final String oConnumber;
  final String eConNumber;
  final String birthday;
  final String nic;
  final String gender;
  final String nFront;
  final String nbacke;
  final String branchId;

  @override
  State<WorkDetails> createState() => _WorkDetailsState();
}

class _WorkDetailsState extends State<WorkDetails> {
  ScrollController _scrollController = ScrollController();

  final TextEditingController regDate = TextEditingController();
  final TextEditingController sAmount = TextEditingController();
  final TextEditingController vehicleNumber = TextEditingController();
  final TextEditingController valuationAmount = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final ImagePicker _picker = ImagePicker();
  String selectedValue = '';
  String newImage = '';
  String newImage2 = '';
  String newImage3 = '';
  String newImage4 = '';
  String newImage5 = '';
  String newImage6 = '';
  String newImage_64 = '';
  String newImage2_64 = '';
  String newImage3_64 = '';
  String newImage4_64 = '';
  String newImage5_64 = '';
  String newImage6_64 = '';
  String designation = "";
  bool isLoading = false;
  final List<String> items = [
    'Delivery Agent',
    'MDC',
    'Supervisor',
  ];
  final List<String> empTyp = [
    'Permanent',
    'Casual',
    'Probation',
    'Freelancer',
  ];
  final List<String> salaryTyp = [
    'Monthly',
    'Daily',
    'Monthly Non EPF',
  ];

  final List<String> vehicleTyp = [
    'Lorry',
    'Three Wheeler',
    'Motorcycle',
    'Van',
    'Car',
    'Bus'
  ];
  final List<String> bondTyp = [
    'Vehicle Book',
    'Cache Deposit',
  ];

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 200)).then((value) {
      Provider.of<ProviderDropDown>(context, listen: false).designation = '';
      Provider.of<ProviderDropDown>(context, listen: false).branch = '';
      Provider.of<ProviderDropDown>(context, listen: false).emp_Type = '';
      Provider.of<ProviderDropDown>(context, listen: false).formattedDate = '';
      Provider.of<ProviderDropDown>(context, listen: false).salaryType = '';
      Provider.of<ProviderDropDown>(context, listen: false).vehicle_type = '';
      Provider.of<ProviderDropDown>(context, listen: false).bondType = '';
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Consumer<ProviderDropDown>(
      builder: (context, provider, child) => Scaffold(
        persistentFooterButtons: [
          DialogButton(
              text: 'Save',
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                if (provider.designation.isNotEmpty &&
                    provider.emp_Type.isNotEmpty &&
                    regDate.text.isNotEmpty &&
                    provider.salaryType.isNotEmpty &&
                    sAmount.text.isNotEmpty &&
                    provider.salaryType.isNotEmpty) {
                  if (provider.designation != '55') {
                    var res = await CustomApi().addUser(
                      widget.name,
                      widget.addres,
                      widget.pConNumber,
                      widget.oConnumber,
                      widget.eConNumber,
                      widget.gender,
                      widget.birthday,
                      widget.nic,
                      regDate.text,
                      provider.designation,
                      widget.branchId,
                      provider.emp_Type,
                      provider.salaryType,
                      sAmount.text,
                      '', // bondtype
                      '', // vehicle type
                      '', //vehicle number
                      '', // valuation amount
                    );

                    var respp = jsonDecode(res);

                    if (respp['msg'] == 'Data inserted success') {
                      var resp = await CustomApi().addUserImages(
                          respp['temp_id'].toString(),
                          '', //bond_type,
                          '0', // idFrontIsEmpty,
                          '0', // idBackIsEmpty,
                          '1', // vBkIsEmpty,
                          '1', // vhCHIsEmpty,
                          '1', // vhLicenceIsEmpty,
                          '1', // vhFrontIsEmpty,
                          '1', // vhLeftIsEmpty,
                          '1', // vhRightIsEmpty,
                          '1', // vhBackIsEmpty,
                          widget.nFront, // id_front,
                          widget.nFront, // id_front_thumb,
                          widget.nbacke, // id_back,
                          widget.nbacke, // id_back_thumb,
                          '', // vehicle_book,
                          '', // vchassis,
                          '', // vehicle_license,
                          '', // vehicle_front,
                          '', // vehicle_right,
                          '' // vehicle_back,
                          );

                      var response = jsonDecode(resp);
                      // var document = parse(response['msg']);

                      notification().info(context, response['msg'].toString());
                      if (response['msg'] == 'Data inserted success') {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    } else {
                      notification().warning(context, "Something went wrong");
                    }
                  } else {
                    if (provider.bondType == '1') {
                      if (newImage.isNotEmpty &&
                          newImage2.isNotEmpty &&
                          newImage3.isNotEmpty &&
                          newImage4.isNotEmpty &&
                          newImage5.isNotEmpty &&
                          newImage6.isNotEmpty) {
                        var res = await CustomApi().addUser(
                          widget.name, widget.addres,
                          widget.pConNumber,
                          widget.oConnumber,
                          widget.eConNumber,
                          widget.gender,
                          widget.birthday,
                          widget.nic,
                          regDate.text,
                          provider.designation,
                          widget.branchId,
                          provider.emp_Type,
                          provider.salaryType,
                          sAmount.text,
                          provider.bondType,
                          provider.vehicle_type,
                          vehicleNumber.text, //aaaaaaaaaaaaaaaaa
                          valuationAmount.text,
                        );

                        var respp = jsonDecode(res);

                        if (respp['msg'] == 'Data inserted success') {
                          var resp = await CustomApi().addUserImages(
                              respp['temp_id'].toString(),
                              '1', //bond_type,
                              '0', // idFrontIsEmpty,
                              '0', // idBackIsEmpty,
                              '0', // vBkIsEmpty,
                              '0', // vhCHIsEmpty,
                              '0', // vhLicenceIsEmpty,
                              '0', // vhFrontIsEmpty,
                              '0', // vhLeftIsEmpty,
                              '0', // vhRightIsEmpty,
                              '0', // vhBackIsEmpty,
                              widget.nFront, // id_front,
                              widget.nFront, // id_front_thumb,
                              widget.nbacke, // id_back,
                              widget.nbacke, // id_back_thumb,
                              newImage_64, // vehicle_book,
                              newImage2_64, // vchassis,
                              newImage3_64, // vehicle_license,
                              newImage4_64, // vehicle_front,
                              newImage5_64, // vehicle_right,
                              newImage6_64 // vehicle_back,
                              );

                          var response = jsonDecode(resp);
                          notification()
                              .info(context, response['msg'].toString());

                          if (response['msg'] == 'Data inserted success') {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        } else {
                          notification()
                              .warning(context, "Something went wrong");
                        }
                      } else {
                        notification()
                            .warning(context, "Images Can't Be Empty");
                      }
                    } else {
                      var res = await CustomApi().addUser(
                        widget.name,
                        widget.addres,
                        widget.pConNumber,
                        widget.oConnumber,
                        widget.eConNumber,
                        widget.gender,
                        widget.birthday,
                        widget.nic,
                        regDate.text,
                        provider.designation,
                        widget.branchId,
                        provider.emp_Type,
                        provider.salaryType,
                        sAmount.text,
                        provider.bondType,
                        provider.vehicle_type,
                        '', //aaaaaaaaaaaaaaaaa
                        valuationAmount.text,
                      );
                    }
                  }
                } else {
                  notification().warning(context, "Value Can't Be Empty");
                }
                setState(() {
                  isLoading = false;
                });
              },
              buttonHeight: h / 15,
              width: w,
              color: appButtonColorLite)
        ],
        appBar: AppBar(
          iconTheme: IconThemeData(color: white),
          backgroundColor: appliteBlue,
          title: Text('Working Details', style: TextStyle(color: white)),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: w,
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 0.7, color: Color.fromARGB(31, 24, 22, 22))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Designation',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          CustomDropDown(
                            items: items,
                            hint: 'Designation',
                          ),
                          Text(
                            'Branch',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          CustomDropDown(
                            items: ['Gampaha'],
                            hint: 'Branch',
                          ),
                          Text(
                            'Emp Type',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          CustomDropDown(
                            items: empTyp,
                            hint: 'Emp Type',
                          ),
                          Text(
                            'Reg.Date',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          AddUserTextFelid(
                            controller: regDate,
                            hint: 'Reg.Date',
                            icon: Icons.person,
                            type: TextInputType.number,
                          ),
                          Text(
                            'Salary Type',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          CustomDropDown(
                            items: salaryTyp, hint: 'Salary Type',

                            // items,
                          ),
                          Text(
                            'Salary amount',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          AddUserTextFelid(
                            controller: sAmount,
                            hint: 'Salary amount',
                            icon: Icons.person,
                            type: TextInputType.number,
                          ),
                          provider.designation == '55'
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Vehicle type',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    CustomDropDown(
                                      items: vehicleTyp, hint: 'Vehicle type',

                                      // items,
                                    ),
                                    Text(
                                      'Bond Type',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    CustomDropDown(
                                      items: bondTyp,
                                      hint: 'Bond Type',
                                    ),
                                    Text(
                                      'Valuation Amount',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    AddUserTextFelid(
                                      controller: valuationAmount,
                                      hint: 'Valuation Amount',
                                      icon: Icons.person,
                                      type: TextInputType.number,
                                    ),
                                    provider.bondType == '1'
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Vehicle Number',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              AddUserTextFelid(
                                                controller: vehicleNumber,
                                                hint: 'Vehicle Number',
                                                icon: Icons.person,
                                                type: TextInputType.number,
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                'Vehicle Book Image',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              imgCard(newImage,
                                                  'Please upload \nBook Image',
                                                  () {
                                                show(1);
                                              }),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                'Vehicle Chassis Image',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              imgCard(newImage2,
                                                  'Please upload \nVehicle Image',
                                                  () {
                                                show(2);
                                              }),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                'Vehicle License',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              imgCard(newImage3,
                                                  'Please upload \nVehicle License',
                                                  () {
                                                show(3);
                                              }),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                'Vehicle Front Image',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              imgCard(newImage4,
                                                  'Please upload \nVehicle License',
                                                  () {
                                                show(4);
                                              }),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                'Vehicle Left Image',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              imgCard(newImage5,
                                                  'Please upload \nVehicle License',
                                                  () {
                                                show(5);
                                              }),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                'Vehicle Right Image',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              imgCard(newImage6,
                                                  'Please upload \nVehicle License',
                                                  () {
                                                show(6);
                                              }),
                                            ],
                                          )
                                        : SizedBox()
                                  ],
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 120,
                )
              ]),
            ),
            isLoading ? Loader().loader(context) : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget imgCard(String img, String title, VoidCallback onTap) {
    var w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onTap,
      child: DottedBorder(
        color: Colors.black38,
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        padding: EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Container(
            alignment: Alignment.center,
            height: h / 7,
            width: w / 2.4,
            child: img.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    child: Container(
                        height: h / 7,
                        width: w / 2.4,
                        child: Image.file(
                          File(img),
                          fit: BoxFit.cover,
                        )))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 40,
                        color: const Color.fromARGB(96, 77, 76, 76),
                      ),
                      Text(title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black38,
                            fontSize: 12.dp,
                          )),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  cameraImage(int front) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    List<int> imageBytes = await image!.readAsBytes();
    // Encode the bytes to base64
    String base64Image = base64Encode(imageBytes);
    setState(() {
      if (front == 1) {
        newImage_64 = "data:image/jpeg;base64,$base64Image";
        newImage = image!.path;
      } else if (front == 2) {
        newImage2_64 = "data:image/jpeg;base64,$base64Image";
        newImage2 = image!.path;
      } else if (front == 3) {
        newImage3_64 = "data:image/jpeg;base64,$base64Image";
        newImage3 = image!.path;
      } else if (front == 4) {
        newImage4_64 = "data:image/jpeg;base64,$base64Image";
        newImage4 = image!.path;
      } else if (front == 5) {
        newImage5_64 = "data:image/jpeg;base64,$base64Image";
        newImage5 = image!.path;
      } else if (front == 6) {
        newImage6_64 = "data:image/jpeg;base64,$base64Image";
        newImage6 = image!.path;
      }
    });
  }

  galleryImage(int front) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    List<int> imageBytes = await image!.readAsBytes();
    // Encode the bytes to base64
    String base64Image = base64Encode(imageBytes);
    setState(() {
      if (front == 1) {
        newImage_64 = "data:image/jpeg;base64,$base64Image";
        newImage = image!.path;
      } else if (front == 2) {
        newImage2_64 = "data:image/jpeg;base64,$base64Image";
        newImage2 = image!.path;
      } else if (front == 3) {
        newImage3_64 = "data:image/jpeg;base64,$base64Image";
        newImage3 = image!.path;
      } else if (front == 4) {
        newImage4_64 = "data:image/jpeg;base64,$base64Image";
        newImage4 = image!.path;
      } else if (front == 5) {
        newImage5_64 = "data:image/jpeg;base64,$base64Image";
        newImage5 = image!.path;
      } else if (front == 6) {
        newImage6_64 = "data:image/jpeg;base64,$base64Image";
        newImage6 = image!.path;
      }
    });
  }

  void show(int isFront) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext cont) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  cameraImage(isFront);
                  Navigator.pop(context);
                },
                child: Text('Use Camera'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  galleryImage(isFront);
                  Navigator.pop(context);
                },
                child: Text('Upload from files'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          );
        });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        regDate.text = formattedDate.toString();
      });
    }
  }

  pasDropDownData(String value) {
    setState(() {
      designation = value;
    });
  }

  CustomDropdown(
    String hint,
    // List<String> items,
  ) {
    final List<String> itemss = [
      'A_Item1',
      'A_Item2',
      'A_Item3',
      'A_Item4',
      'B_Item1',
      'B_Item2',
      'B_Item3',
      'B_Item4',
    ];
    var w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black12, borderRadius: BorderRadius.circular(10)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              hint,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            value: selectedValue,
            onChanged: (value) async {
              // Provider.of<ProviderDropDown>(context).designation =
              //     value.toString();
              setState(() {
                selectedValue = value.toString();
              });
            },

            buttonStyleData: ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: h / 17,
              width: w,
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 500,
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
            // dropdownSearchData: DropdownSearchData(
            //   searchController: textEditingController,
            //   searchInnerWidgetHeight: 50,
            //   searchInnerWidget: Container(
            //     height: 50,
            //     padding: const EdgeInsets.only(
            //       top: 8,
            //       bottom: 4,
            //       right: 8,
            //       left: 8,
            //     ),
            //     child: TextFormField(
            //       expands: true,
            //       maxLines: null,
            //       controller: textEditingController,
            //       decoration: InputDecoration(
            //         isDense: true,
            //         contentPadding: const EdgeInsets.symmetric(
            //           horizontal: 10,
            //           vertical: 8,
            //         ),
            //         hintText: 'Search for an item...',
            //         hintStyle: const TextStyle(fontSize: 12),
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //       ),
            //     ),
            //   ),
            //   searchMatchFn: (item, searchValue) {
            //     return item.value.toString().contains(searchValue);
            //   },
            // ),
            //This to clear the search value when you close the menu
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                // textEditingController.clear();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget customTextField(String hint, IconData icon,
      TextEditingController controller, TextInputType type) {
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: h / 15,
        child: TextField(
          keyboardType: type,
          controller: controller,
          maxLines: 5,
          minLines: 1,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(17),
              // label: Text(
              //   hint,
              //   style: TextStyle(color: black3),
              // ),
              // labelText: hint,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 0.2, color: Colors.black12),
                borderRadius: BorderRadius.circular(10.0),
              ),
              filled: true,
              fillColor: Colors.black12,
              prefixIcon: Icon(icon),
              hintText: 'Type here'),
        ),
      ),
    );
  }

  Widget customTextFieldDate(
    String hint,
    TextEditingController controller,
  ) {
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: h / 15,
        child: TextField(
          controller: regDate,
          maxLines: 5,
          minLines: 1,
          onTap: () {
            _selectDate();
          },
          decoration: InputDecoration(
              // label: Text(
              //   hint,
              //   style: TextStyle(color: black3),
              // ),
              // labelText: hint,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 0.2, color: Colors.black12),
                borderRadius: BorderRadius.circular(10.0),
              ),
              filled: true,
              fillColor: Colors.black12,
              suffixIcon: Icon(Icons.calendar_month),
              hintText: 'dd/mm/yyy'),
        ),
      ),
    );
  }
}
