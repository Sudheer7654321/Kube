import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kube/pages/stock/buyPages/buy_preview_screen.dart';

class BuyStockScreen extends StatefulWidget {
  final String symbol;
  final String companyName;
  final double currentPrice;
  final String logoUrl;

  const BuyStockScreen({
    super.key,
    required this.symbol,
    required this.companyName,
    required this.currentPrice,
    required this.logoUrl,
  });
  @override
  _BuyStockScreenState createState() => _BuyStockScreenState();
}

class _BuyStockScreenState extends State<BuyStockScreen> {
  String sharesInput = "0";
  String limitPriceInput = "0";
  String selectedOrderType = "Market Order";
  String editingField = "shares";

  double get stockPrice => widget.currentPrice;
  double balance = 60.00;

  void addDigit(String digit) {
    setState(() {
      String target = editingField == "limit" ? limitPriceInput : sharesInput;

      if (digit == "⌫") {
        if (target.isNotEmpty) {
          target = target.substring(0, target.length - 1);
          if (target.isEmpty) target = "0";
        }
      } else {
        if (target == "0" && digit != ".") {
          target = digit;
        } else {
          target += digit;
        }
      }

      if (editingField == "limit") {
        limitPriceInput = target;
      } else {
        sharesInput = target;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double shares = double.tryParse(sharesInput) ?? 0.0;
    double limitPrice = double.tryParse(limitPriceInput) ?? 0.0;
    double totalAmount =
        selectedOrderType == "Limit Order"
            ? shares * limitPrice
            : shares * stockPrice;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Buy ${widget.companyName}",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        leading: BackButton(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                ["Market Order", "Limit Order"].map((order) {
                                  final bool isSelected =
                                      selectedOrderType == order;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0,
                                    ),
                                    child: ChoiceChip(
                                      label: Text(
                                        order,
                                        style: GoogleFonts.poppins(
                                          color:
                                              isSelected
                                                  ? Colors.black
                                                  : Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      selected: isSelected,
                                      selectedColor: Colors.white,
                                      backgroundColor: Colors.grey[300],
                                      onSelected: (_) {
                                        setState(() {
                                          selectedOrderType = order;
                                          sharesInput = "0";
                                          limitPriceInput = "0";
                                          editingField = "shares";
                                        });
                                      },
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      shape: StadiumBorder(),
                                    ),
                                  );
                                }).toList(),
                          ),

                          SizedBox(height: 30),
                          Text(
                            "Enter number of shares",
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                editingField = "shares";
                              });
                            },
                            child: Text(
                              sharesInput,
                              style: GoogleFonts.poppins(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color:
                                    editingField == "shares"
                                        ? Colors.white
                                        : Colors.grey,
                              ),
                            ),
                          ),

                          if (selectedOrderType == "Limit Order") ...[
                            SizedBox(height: 16),
                            Text(
                              "Enter Limit Price",
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  editingField = "limit";
                                });
                              },
                              child: Text(
                                limitPriceInput,
                                style: GoogleFonts.poppins(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      editingField == "limit"
                                          ? Colors.blueAccent
                                          : Colors.grey,
                                ),
                              ),
                            ),
                          ],

                          SizedBox(height: 8),
                          Text(
                            "≈ \₹${totalAmount.toStringAsFixed(2)} total   •   1 ${widget.symbol} = \₹${stockPrice.toStringAsFixed(2)}",
                            style: GoogleFonts.poppins(color: Colors.grey),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "\₹$balance available",
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildNumberPad(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _buildPreviewButton(
                shares,
                totalAmount,
                selectedOrderType == "Limit Order" ? limitPrice : stockPrice,
              ),

              SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNumberPad() {
    List<String> buttons = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '.',
      '0',
      '⌫',
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: buttons.length,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 70,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => addDigit(buttons[index]),
            child: Center(
              child: Text(
                buttons[index],
                style: GoogleFonts.poppins(fontSize: 26),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPreviewButton(
    double shares,
    double totalAmount,
    double usedPrice,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => PreviewOrderScreen(
                    symbol: widget.symbol,
                    amount: totalAmount,
                    stockPrice: stockPrice,
                    shares: shares,
                    companyName: widget.companyName,
                    logoUrl: widget.logoUrl,
                    orderType: selectedOrderType,
                    limitPrice:
                        selectedOrderType == "Limit Order"
                            ? double.tryParse(limitPriceInput)
                            : null,
                  ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "Preview Order →",
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
