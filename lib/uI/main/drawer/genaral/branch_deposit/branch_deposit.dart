import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/widget/diloag_button.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../app_details/color.dart';
import '../../../../../class/class.dart';
import '../../../../widget/custom_textField.dart';
import '../../../../widget/nothig_found.dart';
import '../../../navigation/navigation.dart';
import '../../darwer_clz.dart';
import 'remark_histry.dart';

class BranchDeposit extends StatefulWidget {
  const BranchDeposit({super.key});

  @override
  State<BranchDeposit> createState() => _BranchDepositState();
}

class _BranchDepositState extends State<BranchDeposit> {
  int accessGroupId = 1;
  TextEditingController dateController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  DateTime selectedDate = DateTime.now();
  String? selectval;
  List<File> loadImages = [];
  List userBranchList = [
    {'dname': 'All', 'did': '10000'}
  ];
  String visitBranchId = '';
  String riderId = '';
  String newImage = '';
  File? myImage;
  late ScrollController mycontroller = ScrollController();
  List dataList = [];
  List dataListTemp = [];
  bool isLoading = false;
  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRuning = false;
  int _page = 0;
  int x = 0;
  String branchListID = '';
  int _current = 0;
  final CarouselController _controller = CarouselController();
  void initState() {
    getUserBranch();
    // getData('');
    // TODO: implement initState
    super.initState();
    mycontroller.addListener(() {
      if (mycontroller.position.maxScrollExtent ==
          mycontroller.position.pixels) {
        log('hhhhhhhh');
        _loadeMore();
      }
    });
  }

  void _loadeMore() async {
    if (_hasNextPage == true &&
        isLoading == false &&
        _isLoadMoreRuning == false) {
      setState(() {
        _isLoadMoreRuning = true;
      });
      _page += 20;

      var res = await CustomApi().branchDeposit(
          context, _page.toString(), '10', branchListID, '', '', '');

      List data = res;
      if (data.isNotEmpty) {
        setState(() {
          dataList.addAll(data);
          dataListTemp.addAll(res);
        });
      } else {
        setState(() {
          _hasNextPage = false;
        });
      }
      setState(() {
        _isLoadMoreRuning = false;
      });
    }
  }

  getUserBranch() async {
    setState(() {
      isLoading = true;
    });
    List brancheList = await CustomApi().userActiveBranches(context);
    log(brancheList.toString());
    getData('');

    setState(() {
      userBranchList.addAll(brancheList);

      // isLoading = false;
    });
  }

  getData(String branch) async {
    print('ddddddddddddddddddddddddd');
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = await prefs.getInt(
      'accessesKey',
    );
    print('dddddddddddddddddddddddddddaaaaaaaaaaaddd');
    var res = await CustomApi().branchDeposit(
        context, '10', _page.toString(), branchListID, '', '', '');
    setState(() {
      if (id != null) {
        accessGroupId = id!;
      }
      log(res.toString());

      dataList = res;
      dataListTemp = res;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: appliteBlue,
          bottom: PreferredSize(
            preferredSize: Size(w, h / 12),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                child: Container(
                  height: h / 17,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.centerRight,
                  width: w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        color: black3, style: BorderStyle.solid, width: 0.80),
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    alignment: AlignmentDirectional.centerEnd,
                    hint: Container(
                      //and here
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select branch",
                        style: TextStyle(color: black1),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    value:
                        selectval, //implement initial value or selected value
                    onChanged: (value) {
                      setState(() {
                        // _runFilter(value.toString());
                        //set state will update UI and State of your App
                        selectval =
                            value.toString(); //change selectval to new value
                      });
                    },
                    items: userBranchList.map((itemone) {
                      return DropdownMenuItem(
                          onTap: () {
                            setState(() {
                              visitBranchId = itemone['did'];
                              branchListID = visitBranchId;
                            });

                            log(itemone.toString());
                            if (visitBranchId == '10000') {
                              print('fffffffffffffffffffff');
                              getData('');
                            } else {
                              print('ffffffffdddddddddddddddfffffffffffff');
                              getData(branchListID);
                            }
                          },
                          value: itemone['dname'],
                          child: Text(
                            itemone['dname'],
                            style: TextStyle(color: black2),
                          ));
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            'Branch Deposit',
            style: TextStyle(
              fontSize: 18.dp,
              color: white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: white,
              )),
        ),
        backgroundColor: white,
        body: Stack(
          children: [
            dataList.isEmpty && isLoading == false
                ? SizedBox(
                    height: h,
                    width: w,
                    child: Column(
                      children: [
                        Center(child: NoData()),
                      ],
                    ))
                : ListView.builder(
                    itemCount: dataList.length,
                    controller: mycontroller,
                    itemBuilder: (context, index) {
                      String sts = dataList[index]['status'];
                      double deposit = double.parse(dataList[index]['diposit']);
                      double baseCod =
                          double.parse(dataList[index]['base_cod']);
                      double expenses =
                          double.parse(dataList[index]['expences']);
                      double toBeDepo = deposit - expenses;
                      double veriance = (baseCod - expenses) - deposit;
//
                      double cashRece =
                          double.parse(dataList[index]['cash_rece']);
                      double fromUpdates =
                          double.parse(dataList[index]['from_updates']);
                      double bankDp = double.parse(dataList[index]['bank_dp']);
                      double supVeriance =
                          ((cashRece + fromUpdates) - bankDp + expenses);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 30,
                          borderOnForeground: true,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 166, 196, 219),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Card(
                                      elevation: 20,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color:
                                                  Color.fromARGB(255, 9, 3, 97)
                                                      .withOpacity(0.2)),
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      color: sts == 'P'
                                          ? Color.fromARGB(255, 185, 170, 32)
                                          : sts == 'A'
                                              ? Color.fromARGB(255, 7, 178, 33)
                                              : sts == 'R'
                                                  ? Color.fromARGB(
                                                      255, 129, 20, 55)
                                                  : sts == 'C'
                                                      ? Color.fromARGB(
                                                          255, 8, 91, 164)
                                                      : Color.fromARGB(
                                                          255, 179, 217, 53),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        child: Text(
                                          sts == 'P'
                                              ? "Pending"
                                              : sts == 'A'
                                                  ? "Approved"
                                                  : sts == 'R'
                                                      ? "Rejected"
                                                      : sts == 'C'
                                                          ? "Created"
                                                          : '',
                                          style: TextStyle(
                                            fontSize: 14.dp,
                                            color: white,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              Provider.of<ProviderS>(context,
                                                      listen: false)
                                                  .dImages64 = [];
                                              imageView();
                                              await getImages(
                                                  dataList[index]['dpst_id']);
                                            },
                                            icon: Icon(Icons.photo,
                                                color: Color.fromARGB(
                                                    255, 9, 3, 97))),
                                        DrawerClz().branchDepositaddData(
                                                accessGroupId)
                                            ? IconButton(
                                                onPressed: () async {
                                                  Provider.of<ProviderS>(
                                                          context,
                                                          listen: false)
                                                      .dRiderList = [];
                                                  addData(
                                                      dataList[index]
                                                              ['gen_date']
                                                          .toString(),
                                                      dataList[index]
                                                          ['dpst_id']);
                                                  await riderListLoad(
                                                      dataList[index]['did'],
                                                      dataList[index]
                                                              ['gen_date']
                                                          .toString());
                                                },
                                                icon: Icon(
                                                  Icons.add,
                                                  color: Color.fromARGB(
                                                      255, 9, 3, 97),
                                                ))
                                            : SizedBox(),
                                        DrawerClz().branchDepositaddData(
                                                accessGroupId)
                                            ? IconButton(
                                                onPressed: () {
                                                  addRemark(dataList[index]
                                                      ['dpst_id']);
                                                },
                                                icon: Icon(
                                                  Icons.mode_edit_outlined,
                                                  color: Color.fromARGB(
                                                      255, 9, 3, 97),
                                                ))
                                            : SizedBox(),
                                        IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        StudentChats(
                                                            dpId: dataList[
                                                                    index]
                                                                ['dpst_id']),
                                                  ));
                                            },
                                            icon: Icon(
                                              Icons.disabled_visible_sharp,
                                              color:
                                                  Color.fromARGB(255, 9, 3, 97),
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    border: Border.all(color: bacground)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: w / 2.3,
                                          child: Text(
                                            'Date',
                                            style: TextStyle(
                                              fontSize: 14.dp,
                                              color: black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: w / 2.3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                dataList[index]['gen_date'],
                                                style: TextStyle(
                                                  fontSize: 12.dp,
                                                  color: black2,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: w / 2.3,
                                          child: Text(
                                            'Branch',
                                            style: TextStyle(
                                              fontSize: 14.dp,
                                              color: black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: w / 2.3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                dataList[index]['dname'],
                                                style: TextStyle(
                                                  fontSize: 12.dp,
                                                  color: black2,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    qntRow(
                                      'COD From Updates',
                                      dataList[index]['cod'],
                                    ),
                                    qntRow(
                                      'Domestic Cash',
                                      '0',
                                    ),
                                    qntRow('Commission',
                                        dataList[index]['rider_charge']),
                                    qntRow('Branch Expenses',
                                        dataList[index]['expences']),
                                    qntRow(
                                        'To Be Deposited', toBeDepo.toString()),
                                    qntRow(
                                      'Deposited Amount',
                                      dataList[index]['diposit'],
                                    ),
                                    qntRow('Variance', veriance.toString()),
                                    qntRow('Sup. Variance',
                                        supVeriance.toString()),
                                    qntRow('Cash From Riders',
                                        dataList[index]['tobranch']),
                                    qntRow('Today Deposited',
                                        dataList[index]['bankdeposit']),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Container(
                                            child: Text(
                                              'HO Remark ',
                                              style: TextStyle(
                                                fontSize: 14.dp,
                                                color: black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all()),
                                            width: w / 1.5,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 4),
                                                  child: Text(
                                                    dataList[index]['remarks'],
                                                    style: TextStyle(
                                                      fontSize: 14.dp,
                                                      color: black2,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Container(
                                            child: Text(
                                              'Branch Remark',
                                              style: TextStyle(
                                                fontSize: 14.dp,
                                                color: black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all()),
                                            width: w / 1.5,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 4),
                                                  child: Text(
                                                    dataList[index]
                                                        ['branch_remark'],
                                                    style: TextStyle(
                                                      fontSize: 14.dp,
                                                      color: black2,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            if (_isLoadMoreRuning)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            isLoading
                ? Center(
                    child: Loader().loader(context),
                  )
                : SizedBox(),
            provider.isanotherUserLog ? UserLoginCheck() : SizedBox()
          ],
        ),
      ),
    );
  }

  addRemark(String dpId) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
            insetPadding: EdgeInsets.all(12),
            content: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: () {
                              remarkController.clear();
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close))),
                    Text(
                      'Add your remark',
                      style: TextStyle(
                        fontSize: 18.dp,
                        color: black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 20,
                    ),
                    isLoading
                        ? SizedBox(
                            width: w,
                            height: 150,
                            child: Loader().loader(context),
                          )
                        : SizedBox(
                            width: w,
                            child: CustomTextField3(
                              controller: remarkController,
                            ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    DialogButton(
                      text: 'Save',
                      onTap: () async {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          text: 'Do you want to add remark',
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          onConfirmBtnTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            Navigator.pop(context);
                            var res = await CustomApi().newDepositRemark(
                                context, dpId, '2', remarkController.text);
                            if (res == 1) {
                              remarkController.clear();
                              getData(visitBranchId);
                              Navigator.pop(context);
                            }
                            setState(() {
                              isLoading = false;
                            });
                          },
                          confirmBtnColor: Colors.green,
                        );
                      },
                      buttonHeight: h / 17,
                      width: w / 1.5,
                      color: Colors.blue,
                    )
                  ],
                ),
              ],
            ));
      }),
    );
  }

  imageView() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, Setstate) {
        return Consumer<ProviderS>(
          builder: (context, pValue, child) => AlertDialog(
            insetPadding: EdgeInsets.all(12),
            content: Stack(
              children: [
                SizedBox(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.close))),
                        Text(
                          'Images',
                          style: TextStyle(
                            fontSize: 18.dp,
                            color: black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        Provider.of<ProviderS>(context, listen: false)
                                    .dImages64
                                    .isEmpty &&
                                Provider.of<ProviderS>(context, listen: false)
                                        .dataLoad ==
                                    false
                            ? Container(
                                height: h / 1.5,
                                width: w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported_sharp,
                                      size: 100,
                                      color:
                                          const Color.fromARGB(96, 77, 76, 76),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('empty image')
                                  ],
                                ),
                              )
                            : Container(
                                height: h / 1.5,
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    onPageChanged: (index, reason) {
                                      Setstate(() {
                                        _current = index;
                                      });
                                    },
                                    enableInfiniteScroll: false,
                                    animateToClosest: false,
                                    autoPlay: true,
                                    aspectRatio: 1.0,
                                    enlargeCenterPage: true,
                                    enlargeStrategy:
                                        CenterPageEnlargeStrategy.height,
                                  ),
                                  items: pValue.dImages64
                                      .map((item) => ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              height: h / 1.5,
                                              width: w,
                                              child: Image.memory(
                                                  base64Decode(
                                                      item['dslip_image']),
                                                  fit: BoxFit.fitHeight),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              pValue.dImages64.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => _controller.animateToPage(entry.key),
                              child: Container(
                                width: 12.0,
                                height: 12.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 4.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black)
                                        .withOpacity(
                                            _current == entry.key ? 0.9 : 0.4)),
                              ),
                            );
                          }).toList(),
                        ),
                      ]),
                ),
                pValue.dataLoad
                    ? SizedBox(
                        height: h / 1.5,
                        child: Center(
                          child: Loader().loader(context),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        );
      }),
    );
  }

  getImages(String dId) async {
    setState(() {});
    Provider.of<ProviderS>(context, listen: false).dataLoad = true;
    var res = await CustomApi().depositSlipImages(context, dId);
    log(res.toString());
    Provider.of<ProviderS>(context, listen: false).dImages64 = res;
    Provider.of<ProviderS>(context, listen: false).dataLoad = false;
  }

  Widget qntRow(String title, String price) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
          width: w / 2.3,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.dp,
              color: black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: w / 2.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: 14.dp,
                  color: black2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                height: 8,
                color: black3,
              ),
            ],
          ),
        ),
      ],
    );
  }

  riderListLoad(String branchId, String date) async {
    log(date.toString());
    var res = await CustomApi().depositRiderList(context, branchId, date);

    Provider.of<ProviderS>(context, listen: false).dRiderList = res;
  }

  addData(
    String date,
    String dId,
  ) async {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    String? riderList;
    String base64Image = '';
    newImage = '';
    riderId = '';
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setstate) {
        return Consumer<ProviderS>(
          builder: (context, Pvalue, child) => AlertDialog(
            actions: [
              DialogButton(
                  text: 'SAVE',
                  onTap: () async {
                    if (newImage != '') {
                      if (riderId.isNotEmpty) {
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            text: 'Do you want to update slip details',
                            confirmBtnText: 'Yes',
                            cancelBtnText: 'No',
                            onConfirmBtnTap: () async {
                              Navigator.pop(context);
                              setstate(() {
                                isLoading = true;
                              });

                              var res = await CustomApi().depositAgentslip(
                                  context,
                                  dId,
                                  riderId,
                                  Provider.of<ProviderS>(context, listen: false)
                                      .bId,
                                  base64Image);

                              if (res == 1) {
                                setstate(() {
                                  newImage = '';
                                });
                                getData(visitBranchId);

                                Navigator.pop(context);
                              }
                            });
                      } else {
                        notification().warning(context, 'Please select rider');
                      }
                    } else {
                      notification()
                          .warning(context, 'Please Upload the image');
                    }

                    setstate(() {
                      isLoading = false;
                    });
                  },
                  buttonHeight: h / 17,
                  width: w,
                  color: Colors.blue)
            ],
            scrollable: true,
            content: SizedBox(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              onPressed: () {
                                setstate(() {});
                                Provider.of<ProviderS>(context, listen: false)
                                    .dRiderList = [];
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close))),
                      Container(
                        alignment: Alignment.center,
                        child: Text('Update Slip detail',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: black1,
                              fontSize: 18.dp,
                            )),
                      ),
                      Divider(),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 12.dp,
                          color: black2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 12),
                        height: h / 17,
                        width: w,
                        child: Row(children: [
                          Icon(Icons.calendar_month),
                          SizedBox(
                            width: 12,
                          ),
                          Text(date)
                        ]),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black12)),
                      ),
                      // serchBarr(context),
                      Text(
                        'Agent',
                        style: TextStyle(
                          fontSize: 12.dp,
                          color: black2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Card(
                        child: Container(
                          height: h / 17,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          alignment: Alignment.centerRight,
                          width: w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: Colors.black12,
                                style: BorderStyle.solid,
                                width: 0.80),
                          ),
                          child: DropdownButton(
                            focusColor: white1,
                            dropdownColor: white1,
                            isExpanded: true,
                            alignment: AlignmentDirectional.centerEnd,
                            hint: Container(
                              //and here
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Select agent",
                                style: TextStyle(color: black1),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            value:
                                riderList, //implement initial value or selected value
                            onChanged: (value) {
                              print(value.toString());
                              setstate(() {
                                // _runFilter(value.toString());
                                //set state will update UI and State of your App
                                riderList = value
                                    .toString(); //change selectval to new value
                              });
                            },
                            items:
                                Provider.of<ProviderS>(context, listen: false)
                                    .dRiderList
                                    .map((itemone) {
                              return DropdownMenuItem(
                                  onTap: () {
                                    setstate(() {
                                      riderId = itemone['rider_id'];
                                      log(riderId);
                                    });
                                    // getData(itemone['did']);
                                  },
                                  value: itemone['staff_name'],
                                  child: Text(
                                    itemone['staff_name'],
                                    style: TextStyle(color: black2),
                                  ));
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () async {
                            final pickedFile = await _picker.pickImage(
                                source: ImageSource.camera);

                            if (pickedFile != null) {
                              setstate(() {
                                newImage = pickedFile.path;
                                final bytes =
                                    File(pickedFile!.path).readAsBytesSync();
                                base64Image = base64Encode(bytes);
                              });
                            }
                          },
                          child: isLoading || Pvalue.dRiderList.isEmpty
                              ? SizedBox(
                                  width: w,
                                  height: 150,
                                  child: Loader().loader(context),
                                )
                              : Stack(
                                  children: [
                                    Center(
                                      child: DottedBorder(
                                        color: Colors.black38,
                                        borderType: BorderType.RRect,
                                        radius: Radius.circular(12),
                                        padding: EdgeInsets.all(6),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: h / 7,
                                            width: w / 2,
                                            child: newImage != ''
                                                ? Image.file(
                                                    height: h / 7,
                                                    width: w / 2,
                                                    File(
                                                      newImage,
                                                    ),
                                                    fit: BoxFit.fill,
                                                  )
                                                : Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .cloud_upload_outlined,
                                                        size: 40,
                                                        color: const Color
                                                            .fromARGB(
                                                            96, 77, 76, 76),
                                                      ),
                                                      Text(
                                                          'Please upload \nyour image \n -Click here-',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black38,
                                                            fontSize: 11.dp,
                                                          )),
                                                      x == 2
                                                          ? Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                'image required',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            )
                                                          : SizedBox()
                                                    ],
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      newImage == ""
                          ? Container(
                              alignment: Alignment.center,
                              child: Text(
                                'No any Image ',
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox()
                    ]),
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // imagesList.add(File(pickedFile.path));
    }
  }
}
