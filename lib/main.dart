import"dart:io";


import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "flutter APP",
      theme: ThemeData(
        primarySwatch: Colors.purple,
         accentColor: Colors.amber,

      ),


      home:MyHomePage()
    );
  }
}



class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{


final List<Transaction>_userTransactions=[
/*
  Transaction(
      id:'t1',
      title: "new shoes",
      amount: 69.99,
      date: DateTime.now()
  ),
  Transaction(
      id:'t2',
      title: "Weekley Groceries",
      amount: 16.53,
      date: DateTime.now()
  ),
*/
];


bool _showChart=false;

List<Transaction> get _recentTransactions{

  return _userTransactions.where((tx) {
    return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7)
    ),
    );
  }).toList();
}



void _addNewTransaction(String txTitle,double txAmount,DateTime chosenDate){
  final newTx= Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id:DateTime.now().toString()
  );

  setState(() {
    _userTransactions.add(newTx);
  });

}




void _startAddNewTransaction(BuildContext ctx){
  showModalBottomSheet(context: ctx, builder: (bCtx) {

    return GestureDetector(
        onTap: (){},
        child:  NewTransaction(_addNewTransaction),
    behavior: HitTestBehavior.opaque,
    );

  });
  
}

void _deleteTransaction(String id){
  setState(() {
    _userTransactions.removeWhere((tx){

      return  tx.id==id;
    });
    });

}


  @override
  Widget build(BuildContext context) {

 final isLandscape = MediaQuery.of(context).orientation== Orientation.landscape;

  final appBar= AppBar(
    title:Text("ExchangeListApp")
    ,
    actions: <Widget>[
    IconButton(
    icon:Icon(Icons.add),
    onPressed:()=> _startAddNewTransaction(context),

    )

    ]



    );

  final txListWidget =  Container(height: (MediaQuery.of(context).size.height*0.6)-MediaQuery.of(context).padding.top,
      child :  TransactionList(_userTransactions,_deleteTransaction));

  return Scaffold(
      appBar: appBar,
      body:SingleChildScrollView(
          child:Column(
     //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
               if (isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Text("Show Chart"),
                  Switch.adaptive(value: _showChart,onChanged: (val){setState(() {
                    _showChart= val;
                  });},)
                ],),

if (!isLandscape)
                    Container(height: (MediaQuery.of(context).size.height*0.3)-appBar.preferredSize.height,
                          child: Chart(_recentTransactions)),

                if (!isLandscape) txListWidget,

              if(isLandscape)
                _showChart?
                Container(height: (MediaQuery.of(context).size.height*0.7)-appBar.preferredSize.height,
                        child: Chart(_recentTransactions))
                :txListWidget

      ],
      )
    ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS? Container()

          : FloatingActionButton( child: Icon(Icons.add),onPressed:()=> _startAddNewTransaction(context)) ,
    );
  }
}



