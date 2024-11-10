import 'package:afrika_baba/shared/widgets/buttons/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentMethodScreen extends StatefulWidget {
  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedPaymentMethod = 'hp'; 

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Mode de paiement',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: screenHeight * 0.020,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mes modes de paiement',
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: screenHeight * 0.02,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              buildPaymentMethodOption('hp', 'https://s3-alpha-sig.figma.com/img/04f9/5f36/205f834360b9ff80f626499d98ba1b29?Expires=1725235200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=WYEUN~a8zDtew-WAjXEmydhKWQCRVgl~bvoDtmlWnlPcDP3-nZl1IOSt26BgjHYsO4ft059dRqvbbJJiHUO74JpaFfc0C7kh~IOwJIATvznHROMTjfBr2vO5UWX34V1xgMszYdA9b-malr4FMnMPypX4QSNK4Cx7lcxV-3YSYXAgyZ7587JdNpGCbiEVM4F1vKvepeKTofkExw~iIbR37LkoH67r9ntn0KqRjKbm1FmC51xEgHwOYCyEtLNzIxiRxQK6jZzNj9CjzPv4losMB5xUEhRyDK1yIkfdOBWrifZwBI1aLdWHyFx5XYIcqlA-Y4r9Ows1UJtDYRW4tSunUw__'),
              buildPaymentMethodOption('mastercard', 'https://upload.wikimedia.org/wikipedia/commons/4/41/Visa_Logo.png'),
              buildPaymentMethodOption('visa', 'https://brand.mastercard.com/content/dam/mccom/brandcenter/thumbnails/mc_dla_symbol_92.png'),
              Divider(height: screenHeight * 0.05, color: Colors.grey),
              Text(
                'Ajoutez une nouvelle mode de paiement',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: screenHeight * 0.02,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Image.network('https://upload.wikimedia.org/wikipedia/commons/4/41/Visa_Logo.png', width: 24),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'visa',
                    child: Text('Visa'),
                  ),
                  DropdownMenuItem(
                    value: 'mastercard',
                    child: Text('Mastercard'),
                  ),
                ],
                onChanged: (value) {},

              ),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                decoration: InputDecoration(
                  labelText: "Numéro de carte",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Validité",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "CVV",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.05),
              CustomButton(
                text: "Ajouter une nouvelle mode de paiement",
                onPressed: () {
                  // Ajouter la nouvelle carte
                },
                size: 13,
                elevation: 0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPaymentMethodOption(String value, String assetPath) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all( color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      height: 60,
      child: RadioListTile<String>(
        value: value,
        activeColor: Colors.blue,
        groupValue: _selectedPaymentMethod,
        onChanged: (String? newValue) {
          setState(() {
            _selectedPaymentMethod = newValue!;
          });
        },
        title: Row(
          children: [
            Image.network(assetPath, width: 30),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '•••• •••• •••• 1234',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
