import 'package:walletconnect_flutter_v2/apis/web3app/web3app.dart';

List trending = [];
List topCoins = [];
bool isLoading = true;
String? walletAddress;
String? wcUri;
double totalInr = 0;
Map<String, double> tokenWorths = {};
final goldrushApiKey = 'cqt_rQcfYpdJxpmDJ769tbcrjCV3xbXB';
late Web3App wcClient;
