import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BankAccountsScreen extends StatefulWidget {
  const BankAccountsScreen({super.key});
  @override
  _BankAccountsScreenState createState() => _BankAccountsScreenState();
}

class _BankAccountsScreenState extends State<BankAccountsScreen> {
  List<Map<String, String>> accounts = [
    {
      'holder': 'Naveen Kumar',
      'number': 'XXXXXX1234',
      'ifsc': 'SBIN0000123',
      'primary': 'true',
    },
  ];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _holderController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();

  void _addAccountDialog() {
    _holderController.clear();
    _numberController.clear();
    _ifscController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Form(
              key: _formKey,
              child: Wrap(
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 50,
                      margin: EdgeInsets.only(bottom: 20),
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    "Add Bank Account",
                    style: GoogleFonts.poppins(color: Colors.red, fontSize: 18),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _holderController,
                    style: GoogleFonts.poppins(color: Colors.white),
                    decoration: inputStyle("Account Holder Name"),
                    validator:
                        (value) =>
                            value!.isEmpty ? "Enter account holder name" : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.poppins(color: Colors.white),
                    decoration: inputStyle("Account Number"),
                    validator:
                        (value) =>
                            value!.length < 9
                                ? "Enter valid account number"
                                : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _ifscController,
                    textCapitalization: TextCapitalization.characters,
                    style: GoogleFonts.poppins(color: Colors.white),
                    decoration: inputStyle("IFSC Code"),
                    validator:
                        (value) =>
                            value!.length != 11 ? "Invalid IFSC code" : null,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(double.infinity, 45),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          accounts.add({
                            'holder': _holderController.text,
                            'number':
                                'XXXXXX' +
                                _numberController.text.substring(
                                  _numberController.text.length - 4,
                                ),
                            'ifsc': _ifscController.text,
                            'primary': 'false',
                          });
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "Add Account",
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
    );
  }

  InputDecoration inputStyle(String label) => InputDecoration(
    labelText: label,
    labelStyle: GoogleFonts.poppins(color: Colors.grey),
    filled: true,
    fillColor: Colors.grey[900],
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(12),
    ),
  );

  void _removeAccount(int index) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              "Remove Account",
              style: GoogleFonts.poppins(color: Colors.red),
            ),
            content: Text(
              "Are you sure you want to remove this account?",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            actions: [
              TextButton(
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text(
                  "Remove",
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
                onPressed: () {
                  setState(() {
                    accounts.removeAt(index);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  void _setPrimary(int index) {
    setState(() {
      for (int i = 0; i < accounts.length; i++) {
        accounts[i]['primary'] = i == index ? 'true' : 'false';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Bank Accounts"),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.red),
            onPressed: _addAccountDialog,
          ),
        ],
      ),
      body:
          accounts.isEmpty
              ? Center(
                child: Text(
                  "No linked bank accounts yet.",
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
              )
              : ListView.builder(
                itemCount: accounts.length,
                itemBuilder: (_, index) {
                  final acc = accounts[index];
                  return Card(
                    color: Colors.grey[850],
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.account_balance, color: Colors.red),
                      title: Text(
                        acc['holder']!,
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      subtitle: Text(
                        "${acc['number']} | IFSC: ${acc['ifsc']}",
                        style: GoogleFonts.poppins(color: Colors.grey[400]),
                      ),
                      trailing: PopupMenuButton<String>(
                        color: Colors.grey[800],
                        icon: Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (value) {
                          if (value == 'primary') _setPrimary(index);
                          if (value == 'remove') _removeAccount(index);
                        },
                        itemBuilder:
                            (_) => [
                              PopupMenuItem(
                                value: 'primary',
                                child: Text(
                                  'Set as Primary',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'remove',
                                child: Text(
                                  'Remove',
                                  style: GoogleFonts.poppins(color: Colors.red),
                                ),
                              ),
                            ],
                      ),
                      tileColor:
                          acc['primary'] == 'true'
                              ? Colors.green.withOpacity(0.2)
                              : null,
                    ),
                  );
                },
              ),
    );
  }
}
