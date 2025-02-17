import 'package:flutter/material.dart';
import '../models/transaction.dart';
import "package:intl/intl.dart";
import './chart_bar.dart';

class Chart extends StatelessWidget{

  final List<Transaction> recentTransactions;


  Chart(this.recentTransactions);

 List <Map<String,Object>> get groupedTRansactionValues{
   return List.generate(7,(index){


     final weekDay=DateTime.now().subtract(Duration(days:index),);
     double totalSum = 0.0;
     for (var i=0; i<recentTransactions.length; i++){
       if(recentTransactions[i].date.day == weekDay.day &&
           recentTransactions[i].date.month == weekDay.month &&
       recentTransactions[i].date.year == weekDay.year)
totalSum += recentTransactions[i].amount;
     }



     return {
       "day":DateFormat.E().format(weekDay).substring(0,1),
       "amount":totalSum};
   }).reversed.toList(); //mi genera la lista al contratrio

 }



 double get totalSpending{

   return groupedTRansactionValues.fold(0.0,(sum,item) {

     return sum + item ["amount"];
   });
 }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
Card(
      elevation: 6,
      margin:EdgeInsets.all(20),
        child:Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTRansactionValues.map((data)
    {
          return Flexible( // prende tutto lo spazio dipsonibile anche se impongo una grandezza fissa
            fit: FlexFit.tight,
              child: ChartBar(
              data["day"],data["amount"],

              totalSpending == 0.0? 0.0 : (data["amount"] as double)/totalSpending // if totalspending == 0 allora scrivi 0 altrimenti scrivi quello dopo il ":"
          ),
          );

    }).toList(),
    ),
        )
    );
    }



}