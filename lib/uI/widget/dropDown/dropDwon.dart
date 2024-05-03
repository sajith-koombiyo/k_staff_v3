import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:provider/provider.dart';

class CustomDropDown extends StatefulWidget {
  CustomDropDown({
    super.key,
    required this.items,
    required this.hint,
  });
  final List<String> items;
  final String hint;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? selectedValue;

  final TextEditingController textEditingController = TextEditingController();
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  String valueItem = '';
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        height: h / 10,
        // decoration: BoxDecoration(
        //     color: Colors.black12, borderRadius: BorderRadius.circular(10)),
        child: DropdownButtonFormField2<String>(
          isExpanded: true,

          decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.circular(10),
            ),
            errorText: valueItem.isEmpty ? "Value Can't Be Empty" : '',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.circular(10),
            ),
            // Add more decoration..
          ),
          hint: Text(
            widget.hint,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: widget.items
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
          onChanged: (value) {
          
            valueItem = value.toString();

            if (widget.hint == 'Designation') {
              // designation value
              if (value == 'Delivery Agent') {
                Provider.of<ProviderDropDown>(context, listen: false)
                    .designation = '55';
              } else if (value == 'MDC') {
                Provider.of<ProviderDropDown>(context, listen: false)
                    .designation = '40';
              } else if (value == 'Supervisor') {
                Provider.of<ProviderDropDown>(context, listen: false)
                    .designation = '45';
              }
            } else if (widget.hint == 'Branch') {
              Provider.of<ProviderDropDown>(context, listen: false).branch =
                  value.toString();
            } else if (widget.hint == 'Emp Type') {
              if (value == 'Permanent') {
                Provider.of<ProviderDropDown>(context, listen: false).emp_Type =
                    '1';
              } else if (value == 'Casual') {
                Provider.of<ProviderDropDown>(context, listen: false).emp_Type =
                    '2';
              } else if (value == 'Probation') {
                Provider.of<ProviderDropDown>(context, listen: false).emp_Type =
                    '3';
              } else if (value == 'Freelancer') {
                Provider.of<ProviderDropDown>(context, listen: false).emp_Type =
                    '4';
              }
            } else if (widget.hint == 'Salary Type') {
              Provider.of<ProviderDropDown>(context, listen: false).salaryType =
                  value.toString();
            } else if (widget.hint == 'Vehicle type') {
              Provider.of<ProviderDropDown>(context, listen: false)
                  .vehicle_type = value.toString();
            } else if (widget.hint == 'Bond Type') {
              if (value == 'Vehicle Book') {
                Provider.of<ProviderDropDown>(context, listen: false).bondType =
                    '1';
              } else if (value == 'Cache Deposit') {
                Provider.of<ProviderDropDown>(context, listen: false).bondType =
                    '2';
              }
            } else if (widget.hint == 'Valuation Amount') {
              // Provider.of<ProviderDropDown>(context, listen: false)
              //     .v = value.toString();
            }

            setState(() {
              selectedValue = value;
            });
          },
          buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: h / 14,
            width: w,
          ),
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 500,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),

          dropdownSearchData: DropdownSearchData(
            searchController: textEditingController,
            searchInnerWidgetHeight: 50,
            searchInnerWidget: Container(
              height: 50,
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 4,
                right: 8,
                left: 8,
              ),
              child: TextFormField(
                expands: true,
                maxLines: null,
                controller: textEditingController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: 'Search for an item...',
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return item.value.toString().contains(searchValue);
            },
          ),

          //This to clear the search value when you close the menu
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              textEditingController.clear();
            }
          },
        ),
      ),
    );
  }
}
