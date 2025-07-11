import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class ToMobileMoneyTransferPage extends StatefulWidget {
  const ToMobileMoneyTransferPage({super.key});

  @override
  State<ToMobileMoneyTransferPage> createState() =>
      _ToMobileMoneyTransferPageState();
}

class _ToMobileMoneyTransferPageState extends State<ToMobileMoneyTransferPage> {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  String searchQuery = '';
  bool permissionDenied = false;

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    if (await Permission.contacts.request().isGranted) {
      final fetched = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        contacts = fetched;
        filteredContacts = contacts;
        permissionDenied = false;
      });
    } else {
      setState(() => permissionDenied = true);
    }
  }

  void filterContacts(String input) {
    setState(() {
      searchQuery = input;
      filteredContacts =
          contacts
              .where(
                (c) =>
                    c.displayName.toLowerCase().contains(input.toLowerCase()) ||
                    (c.phones.isNotEmpty &&
                        c.phones.first.number.contains(input)),
              )
              .toList();
    });
  }

  Widget buildContactTile(String name, String number) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFB8D8C1),
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(name, style: GoogleFonts.poppins(color: Colors.white)),
      subtitle: Text(number, style: GoogleFonts.poppins(color: Colors.white70)),
      onTap: () {
        debugPrint('Selected: $name ($number)');
      },
    );
  }

  Widget buildUnknownEntryTile(String number) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.grey,
        child: Icon(Icons.person_outline, color: Colors.black),
      ),
      title: Text(
        "New Number",
        style: GoogleFonts.poppins(color: Colors.white),
      ),
      subtitle: Text(number, style: GoogleFonts.poppins(color: Colors.white70)),
      onTap: () {
        debugPrint('New number: $number');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPhoneEntry = RegExp(r'^[6789]\d{5,}$').hasMatch(searchQuery);
    final isUnknownNumber =
        isPhoneEntry &&
        !contacts.any(
          (c) => c.phones.any(
            (p) => p.number.replaceAll(' ', '').contains(searchQuery),
          ),
        );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Select Contact", style: GoogleFonts.poppins()),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          permissionDenied
              ? Center(
                child: Text(
                  "Permission denied to read contacts",
                  style: GoogleFonts.poppins(color: Colors.white54),
                ),
              )
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      onChanged: filterContacts,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.poppins(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search any mobile number',
                        hintStyle: GoogleFonts.poppins(color: Colors.white60),
                        prefixIcon: const Icon(
                          HugeIcons.strokeRoundedSearch01,
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade900,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      HugeIcons.strokeRoundedCall,
                      color: Color(0xFFB8D8C1),
                    ),
                    title: Text(
                      "New Mobile Number",
                      style: GoogleFonts.poppins(color: Color(0xFFB8D8C1)),
                    ),
                    onTap: () {
                      debugPrint('Tapped New Mobile Number');
                    },
                  ),
                  const Divider(color: Colors.white12),
                  if (isUnknownNumber) buildUnknownEntryTile(searchQuery),
                  if (!isUnknownNumber && filteredContacts.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "No matching contacts",
                        style: GoogleFonts.poppins(color: Colors.white54),
                      ),
                    ),
                  if (filteredContacts.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredContacts.length,
                        itemBuilder: (_, index) {
                          final contact = filteredContacts[index];
                          final phone =
                              contact.phones.isNotEmpty
                                  ? contact.phones.first.number
                                  : 'No number';
                          return buildContactTile(contact.displayName, phone);
                        },
                      ),
                    ),
                ],
              ),
    );
  }
}
