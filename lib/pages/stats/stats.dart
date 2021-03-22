import 'package:flutter/material.dart';

class Stats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _makeSubMenus(),
    );
  }

  _makeSubMenus() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        ListTile(
          title: Text('번호별'),
          leading: Icon(Icons.youtube_searched_for),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          title: Text('색상별'),
          leading: Icon(Icons.color_lens_outlined),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          title: Text('홀짝'),
          leading: Icon(Icons.star_half),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          title: Text('연속번호'),
          leading: Icon(Icons.saved_search),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          title: Text('미출현번호'),
          leading: Icon(Icons.search_off),
          onTap: () {},
        ),
        Divider(),
      ],
    );
  }
}
