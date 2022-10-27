import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  static const _credential = r''' 
  {
  "type": "service_account",
  "project_id": "expense-366810",
  "private_key_id": "c5240db826658d08cfcbcc5136ad058488af367e",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCVroN2lhsovBMr\n41ctAJasdEhs4RCY/3xg1dbq+z7dj+JTIdFJFuvUeilB4udrwMcBOawuhDQyGz1D\nRzclIptoL1N0IbEFbjjvy2D/ORDrNAQFV5JkrI12ApavornCyH/AfDxueIncjdVo\nxeSTMCWSlIZa97jWJVbx61MoZrcbtT2ODJPdtE6ja9AtFic/Yagw4HgVOYHEZDE1\nCigSQrTiqAtko29R/2KH13cWib61WjKll2KgyRwa14e4K/WI/sENq8rW4fB+YeE1\nQa5TtBSBaRmvPf5xge0SK0BAP3T9a9wTViiS0s+sGgKMYnfJ0ksdhmd1fX7H3MsU\nrEX6ZOdHAgMBAAECggEAB+nvJ3DuRKwU82gUrttuG/YV8jPAFebEI7aKo2ffPgWi\neLS8BPpCQ7ylu8cMZ0UNAIKVGOyCefe4uHrmbn8y6kI+TlCNtHTMa9k76qKQw26/\nm6yyn8IDxK6EWwrmeWbyYjHvXAPhfhi9pMl5uVJ9Wg+iPuMEEcZtn2LKxcMQgVVy\nDDyGAKCioQAed++pnxUO/t/LhZu2NJkALKNB7TvD5UjcAimqrtKPyoAzbe11c9uA\nm6llYA8s3F9XXHW1ek5dEfYC2io71LW7+xaUteX8uIkxWLrFQyHUXbY5rdVcVM+A\n63OY7wrCI/j2Ux8YSQczdyDSnOnEtYDng+px8Wv0OQKBgQDPyByAQONphjWyHYUv\nq/F1tUFvlsgMvtO62KJe5/+3jdG7bkAdF/l7NVOOreoQJWgEDc4XCNfVbOUx3upI\nHYGSK/Ult1rMH9DxqRZ5e0nfp+oIsNsJb/iCpLD2BbiofdzIeK8/oJAJBETyGv7l\nA8tGeQ+V3ne1/PueIPWUJMepnQKBgQC4asyrbaHjJW5Oheo/tAsx+H8pMZbH986d\nGgcbW+7ULPWK6xuq2ThRx/zbeEuAqI1Mk6YNDlWKF83bg+sE0h9TWvKAwqb8QX0o\nhf6+mWqHtMiWWxlyBV8xRvEQFFOpGKdnULtrq25aSoMbhNzbY+BqWmnVrEW4S/q8\nvTEghN6BMwKBgGVx4SBpDd7ObNbqfMU6oKgEd89AgalfXcZi0Fufz4TRk+17tYe+\n1cpmzcXieV2qta8NAmrSoXYNNZV0rVPKPCGenpDshUMV4ZCrKlLjc7zjoWre1gI0\njdNTDyb+whpZYPrrmTxqawhL8lF2Bq7PfGaK4qYcOLw8qKialOvgTS8tAoGAPXH4\nN7YTlmdGVYtw/UCz6jZtx//pyT7b7KRbcdYzwSYpuduUIFy30yfbLBTsszV1vuoD\nDZ6VCancwSM3Dygjn9ZRrm0szifT18itlDvxrr2hh9dapw77JKQKdd0P8utv+5B+\noeVAo3zoKicen0qr30O4t6TqpflK1dADql4a9NkCgYEAsalfwCvH+LRGcRkuYfD5\nWsDEITSCmdpyIsKZSoB0rgdzN0KFPn2EYlW9eUAUQfj1ubMxoQHJY1poHqpIFmg9\nYz+gapvhD1hUqANakJ12tm+KkKEC01SnW21X4F0dbVtdayGUTmyrj524eWx+Bza1\nqD4s/HZKavZ2F0mqxusOoOY=\n-----END PRIVATE KEY-----\n",
  "client_email": "expense@expense-366810.iam.gserviceaccount.com",
  "client_id": "109261036854375995446",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/expense%40expense-366810.iam.gserviceaccount.com"
  }
  ''';

  static const _spreadSheetId = '17HpOsSoN2jfeJP20tlOAKjTEzUDAupmHq5gdJWerSO0';
  static final _gsheets = GSheets(_credential);
  static Worksheet? worksheet;

  static int numberOftransaction = 0;
  static List<List<dynamic>> currentTransaction = [];
  static bool loading = true;

  //initialise spreadsheet
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadSheetId);
    worksheet = ss.worksheetByTitle('Tracker');

    countRow();
  }

  //load existing notes from the spreadsheet
  static Future countRow() async {
    while ((await worksheet!.values
            .value(column: 1, row: numberOftransaction + 1)) !=
        '') {
      numberOftransaction++;
    }
    loadTransaction();
  }

  static Future loadTransaction() async {
    if (worksheet == null) return;
    for (int i = 0; i < numberOftransaction; i++) {
      final String TransactionName =
          await worksheet!.values.value(column: 1, row: i + 1);
      final String TransactionAmount =
          await worksheet!.values.value(column: 2, row: i + 1);
      final String TransactionType =
          await worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransaction.length < numberOftransaction) {
        currentTransaction.add([
          TransactionName,
          TransactionAmount,
          TransactionType,
        ]);
      }
    }
    loading = false;
    print(currentTransaction);
  }

  //insert new transaction
  static Future insert(String name, String amount, bool isIncome) async {
    if (worksheet == null) return;
    numberOftransaction++;
    currentTransaction.add(
      [
        name,
        amount,
        isIncome == true ? "income" : "expense",
      ],
    );

    await worksheet!.values.appendRow([
      name,
      amount,
      isIncome == true ? 'income' : 'expense',
    ]);
  }

  //Calculate income
  static double CalculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < numberOftransaction; i++) {
      if (currentTransaction[i][2] == 'income') {
        totalIncome += double.parse(currentTransaction[i][1]);
      }
    }
    return totalIncome;
  }

  //calculate expense
  static double CalculateExpense() {
    double totalexpense = 0;
    for (int i = 0; i < numberOftransaction; i++) {
      if (currentTransaction[i][2] == 'expense') {
        totalexpense += double.parse(currentTransaction[i][1]);
      }
    }
    return totalexpense;
  }
}
