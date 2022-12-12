import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/chart.dart';
import 'package:flutter_application_2/widgets/new_transaction.dart';
import 'package:flutter_application_2/widgets/transaction_list.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'models/transaction.dart';
import 'widgets/get_tsx_between.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('tr', 'TR'),
      ],
      debugShowCheckedModeBanner: false,
      title: "Haftalık Giderler App",
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: "Quicksand",
        textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: const TextStyle(
                fontFamily: "Quicksand",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: "Quicksand",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  final List<Transaction> _userTransactions = [];

  late Future<bool> initialTransactions;
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((transaction) {
      return transaction.date
          .isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String transactionTitle, String transactionAmount,
      DateTime selectedDate) {
    var transactionAmountDouble = double.tryParse(transactionAmount) ?? 0.0;
    Transaction newTransaction = Transaction(
        id: _userTransactions.isEmpty
            ? 1
            : _userTransactions[_userTransactions.length - 1].id + 1,
        title: transactionTitle,
        amount: transactionAmountDouble,
        date: selectedDate);
    setState(() {
      _userTransactions.add(newTransaction);
      writeTransaction();
    });
  }

  void _deleteTransaction(Transaction transaction) {
    setState(() {
      _userTransactions.remove(transaction);
      writeTransaction();
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return NewTransaction(_addNewTransaction);
        });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File("$path/transactions.txt");
  }

  Future<bool> readTransaction() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsLines();
      for (var i = 0; i < contents.length; i++) {
        List<String> attributes = contents[i].split("+");
        _userTransactions.add(Transaction(
          id: (int.parse(attributes[0])),
          title: attributes[1],
          amount: (double.parse(attributes[2])),
          date: DateTime.parse(attributes[3]),
        ));
      }
      return true;
    } catch (e) {
      log(e.toString());
      return true;
    }
  }

  void writeTransaction() async {
    final file = await _localFile;
    file.writeAsString("");
    for (var i = 0; i < _userTransactions.length; i++) {
      String holder =
          "${_userTransactions[i].id}+${_userTransactions[i].title}+${_userTransactions[i].amount}+${_userTransactions[i].date}\n";
      await file.writeAsString(holder, mode: FileMode.append);
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    initialTransactions = readTransaction();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: const Text(
        "Harcamalarım",
      ),
      actions: [
        IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: const Icon(
              Icons.add_circle_sharp,
              size: 35,
            ))
      ],
    );
    return FutureBuilder(
      future: initialTransactions,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: appBar,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  if (isLandscape)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Grafiği göster"),
                        Switch(
                            value: _showChart,
                            onChanged: ((value) {
                              setState(() {
                                _showChart = value;
                              });
                            })),
                      ],
                    ),
                  if (!isLandscape)
                    SizedBox(
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.30,
                        child: Chart(_recentTransactions)),
                  if (!isLandscape)
                    SizedBox(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.55,
                      child: TransactionList(
                          _userTransactions, _deleteTransaction),
                    ),
                  if (!isLandscape)
                    Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.15,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 40),
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          padding: MaterialStatePropertyAll(
                              EdgeInsets.fromLTRB(10, 12, 10, 12)),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return GetTsxBetween(_userTransactions);
                            },
                          );
                        },
                        child: const Text(
                          "Belirli bir aralığı\ngörüntüleyin!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  if (isLandscape)
                    _showChart
                        ? SizedBox(
                            height: (MediaQuery.of(context).size.height -
                                    appBar.preferredSize.height -
                                    MediaQuery.of(context).padding.top) *
                                0.6,
                            child: Chart(_recentTransactions))
                        : SizedBox(
                            height: (MediaQuery.of(context).size.height -
                                    appBar.preferredSize.height -
                                    MediaQuery.of(context).padding.top) *
                                0.7,
                            child: TransactionList(
                                _userTransactions, _deleteTransaction),
                          ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
          );
        } else {
          return Center(
            child: LoadingAnimationWidget.waveDots(
              color: Colors.purple,
              size: 40,
            ),
          );
        }
      },
    );
  }
}
