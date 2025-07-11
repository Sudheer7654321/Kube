import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'mobile_recharge_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

class MobileRechargeAcessPage extends StatefulWidget {
  const MobileRechargeAcessPage({super.key});

  @override
  State<MobileRechargeAcessPage> createState() =>
      _MobileRechargeAcessPageState();
}

class _MobileRechargeAcessPageState extends State<MobileRechargeAcessPage> {
  List<Contact> allContacts = [];
  List<Contact> filteredContacts = [];
  List<Map<String, String>> recentContacts = [];
  String typedNumber = '';

  @override
  void initState() {
    super.initState();
    getContacts();
    loadRecentContacts();
  }

  Future<void> getContacts() async {
    var status = await Permission.contacts.status;
    if (!status.isGranted) {
      status = await Permission.contacts.request();
    }

    if (status.isGranted) {
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        allContacts = contacts.where((c) => c.phones.isNotEmpty).toList();
        filteredContacts = allContacts;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Contacts permission is denied',
            style: GoogleFonts.poppins(),
          ),
        ),
      );
    }
  }

  Future<void> loadRecentContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('recent_contacts') ?? [];
    setState(() {
      recentContacts =
          data.map((e) => Map<String, String>.from(jsonDecode(e))).toList();
    });
  }

  Future<void> saveRecentContact(String name, String number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    recentContacts.removeWhere((c) => c['number'] == number);
    recentContacts.insert(0, {
      'name': name,
      'number': number,
      'source': 'Recent Contact',
    });

    if (recentContacts.length > 5) {
      recentContacts = recentContacts.sublist(0, 5);
    }

    final encoded = recentContacts.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('recent_contacts', encoded);
    setState(() {});
  }

  void filterContacts(String query) {
    setState(() {
      typedNumber = query;
      if (query.isEmpty) {
        filteredContacts = allContacts;
      } else {
        filteredContacts =
            allContacts.where((contact) {
              final name = contact.displayName.toLowerCase();
              final phoneNumbers = contact.phones
                  .map((p) => p.number.replaceAll(RegExp(r'\s|-'), ''))
                  .join(' ');
              return name.contains(query.toLowerCase()) ||
                  phoneNumbers.contains(query);
            }).toList();
      }
    });
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    return parts.length == 1
        ? parts[0][0].toUpperCase()
        : (parts[0][0] + parts[1][0]).toUpperCase();
  }

  bool isValidIndianNumber(String number) {
    return RegExp(r'^[6-9]\d{9}$').hasMatch(number);
  }

  void showInvalidPopup() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              "Invalid Number",
              style: GoogleFonts.poppins(color: Colors.redAccent),
            ),
            content: Text(
              "Please enter a valid 10-digit Indian mobile number starting with 6, 7, 8, or 9.",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "OK",
                  style: GoogleFonts.poppins(color: Color(0xFFB8D8C1)),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUnknownNumber =
        typedNumber.isNotEmpty &&
        !allContacts.any(
          (c) => c.phones.any((p) => p.number.contains(typedNumber)),
        );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Mobile Recharge",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help_outline, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white),
            ),
            child: Row(
              children: [
                const Icon(Icons.flash_on, color: Color(0xFFB8D8C1)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Earn up to ₹50 Cashback",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "on Mobile Recharge with UPI Lite!",
                        style: GoogleFonts.poppins(
                          color: Colors.grey[300],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Activate Now",
                    style: GoogleFonts.poppins(color: Color(0xFFB8D8C1)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: filterContacts,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by Number or Name',
                hintStyle: GoogleFonts.poppins(color: Colors.white),
                prefixIcon: Icon(
                  HugeIcons.strokeRoundedSearch01,
                  color: Colors.grey.shade200,
                ),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (typedNumber.isNotEmpty && isUnknownNumber)
            ListTile(
              leading: const Icon(Icons.person_outline, color: Colors.white),
              title: Text(
                "Unknown Number",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              subtitle: Text(
                typedNumber,
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
              onTap: () {
                if (!isValidIndianNumber(typedNumber)) {
                  showInvalidPopup();
                  return;
                }

                saveRecentContact("Unknown Number", typedNumber);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => MobileRechargePage(
                          name: "Unknown Number",
                          number: typedNumber,
                        ),
                  ),
                );
              },
            ),
          Expanded(
            child: ListView(
              children: [
                if (recentContacts.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "RECENTS",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[500],
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ...recentContacts.map(
                  (c) => ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => MobileRechargePage(
                                name: c['name']!,
                                number: c['number']!,
                              ),
                        ),
                      );
                    },
                    leading: const Icon(
                      Icons.account_circle,
                      color: Colors.red,
                    ),
                    title: Text(
                      c['name']!,
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    subtitle: Text(
                      c['number']!,
                      style: GoogleFonts.poppins(color: Colors.grey[200]),
                    ),
                    trailing: GestureDetector(
                      onTap: () async {
                        setState(() {
                          recentContacts.removeWhere(
                            (rc) => rc['number'] == c['number'],
                          );
                        });
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        final encoded =
                            recentContacts.map((e) => jsonEncode(e)).toList();
                        await prefs.setStringList('recent_contacts', encoded);
                      },
                      child: Text(
                        "Remove",
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "ALL CONTACTS",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                ...filteredContacts.map((contact) {
                  final name = contact.displayName;
                  final number = contact.phones.first.number;
                  return GestureDetector(
                    onTap: () {
                      saveRecentContact(name, number);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => MobileRechargePage(
                                name: name,
                                number: number,
                              ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          _getInitials(name),
                          style: TextStyle(color: Colors.grey.shade800),
                        ),
                      ),
                      title: Text(
                        name,
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      subtitle: Text(
                        number,
                        style: GoogleFonts.poppins(color: Colors.grey[500]),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
