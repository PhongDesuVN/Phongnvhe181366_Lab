import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 1. Model dữ liệu
class CurrencyItem {
  String code;
  double rate;

  CurrencyItem({
    required this.code,
    required this.rate,
  });
}

class ExchangeData {
  String base;
  List<CurrencyItem> items;

  ExchangeData({
    required this.base,
    required this.items,
  });

  factory ExchangeData.fromJson(Map<String, dynamic> json) {
    String baseCode = json['base_code'].toString();
    Map<String, dynamic> ratesMap = json['rates'];

    List<CurrencyItem> list = [];
    List<String> mainCurrencies = ['VND', 'EUR', 'JPY', 'GBP', 'AUD', 'CAD'];

    for (var key in ratesMap.keys) {
      if (mainCurrencies.contains(key) == true) {
        double rateVal = double.tryParse(ratesMap[key].toString()) ?? 0.0;
        list.add(CurrencyItem(code: key, rate: rateVal));
      }
    }

    return ExchangeData(
      base: baseCode,
      items: list,
    );
  }
}

// 2. Class gọi API (ApiService)
class ApiService {
  Future<ExchangeData> fetchRates() async {
    Uri url = Uri.parse('https://open.er-api.com/v6/latest/USD');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return ExchangeData.fromJson(json);
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}

// 3. Màn hình giao diện
class CurrencyScreen extends StatefulWidget {
  @override
  CurrencyScreenState createState() {
    return CurrencyScreenState();
  }
}

class CurrencyScreenState extends State<CurrencyScreen> {
  ApiService apiService = ApiService();
  late Future<ExchangeData> futureData;
  TextEditingController amountController = TextEditingController(text: '100');

  @override
  void initState() {
    super.initState();
    futureData = apiService.fetchRates();
  }

  // Hàm tính gợi ý
  String getAdvice(double vndRate) {
    if (vndRate > 25000) {
      return 'Tỷ giá USD đang ở mức cao (Nên bán USD)';
    } else {
      return 'Tỷ giá USD ở mức bình thường (Thích hợp mua vào)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Helper (Lab 8B)'),
      ),
      body: FutureBuilder<ExchangeData>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError == true) {
            return Center(
              child: Text('Error: ' + snapshot.error.toString()),
            );
          }

          if (snapshot.hasData == true) {
            ExchangeData exchangeData = snapshot.data!;

            double vndRate = 0.0;
            for (int i = 0; i < exchangeData.items.length; i = i + 1) {
              if (exchangeData.items[i].code == 'VND') {
                vndRate = exchangeData.items[i].rate;
              }
            }

            double usdAmount = double.tryParse(amountController.text) ?? 0.0;

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Nhập số tiền (USD)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),

                  // Thẻ gợi ý mua bán
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gợi ý mua bán:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(getAdvice(vndRate)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  Text(
                    'Quy đổi sang các ngoại tệ khác:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),

                  Expanded(
                    child: ListView.builder(
                      itemCount: exchangeData.items.length,
                      itemBuilder: (context, index) {
                        CurrencyItem item = exchangeData.items[index];
                        double convertedValue = usdAmount * item.rate;

                        return Card(
                          child: ListTile(
                            title: Text('1 USD = ' + item.rate.toString() + ' ' + item.code),
                            subtitle: Text(
                              'Tổng: ' + convertedValue.toStringAsFixed(2) + ' ' + item.code,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Text('No data found'),
          );
        },
      ),
    );
  }
}