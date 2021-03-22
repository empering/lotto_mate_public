import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lotto_mate/models/buy.dart';
import 'package:lotto_mate/models/draw.dart';
import 'package:lotto_mate/widgets/lotto_number.dart';

import 'history_form.dart';

@Deprecated("사용안함")
class History2 extends StatelessWidget {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
          future: db.collection('buys').get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("error!!");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              List<Buy> buys = snapshot.data!.docs
                  .map((e) => Buy.fromFirestore(e.data()!))
                  .toList();

              return SafeArea(
                child: ListView.builder(
                  itemCount: buys.length,
                  itemBuilder: (BuildContext context, int index) =>
                      _buildHistoryCard(buys[index], index),
                ),
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HistoryForm()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildHistoryCard(Buy buy, int index) {
    return FutureBuilder<DocumentSnapshot>(
      future: db.doc('draws/${buy.drawId}').get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("error!!");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Draw draw = Draw.fromFirestore(snapshot.data!.data()!);

          return Card(
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 75,
                    child: Text('${draw.id} 회차'),
                  ),
                  Text('총 ${buy.picks!.length}회 응모'),
                  Text('당첨 1회'),
                  Text('+ 5,000 원'),
                ],
              ),
              subtitle: Container(
                padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
                child: Column(
                  children: buy.picks!
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: e.numbers!
                                  .map((e) => LottoNumber(
                                        number: e,
                                        winNumbers: draw.numbers,
                                      ))
                                  .toList(),
                            ),
                          ))
                      .toList(),
                ),
              ),
              contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              trailing: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                },
              ),
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
