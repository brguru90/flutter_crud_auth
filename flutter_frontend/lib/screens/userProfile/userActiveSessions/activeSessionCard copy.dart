import 'package:flutter/material.dart';

class activeSessionCard extends StatelessWidget {
  const activeSessionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Table(
            // border: TableBorder.all(),
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: Text(
                      "Token ID:",
                      style: TextStyle(color: Colors.blue[700], fontSize: 20.0),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "token_id",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text(
                      "IP:",
                      style: TextStyle(color: Colors.blue[700], fontSize: 16.0),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "255.255.255.255",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text(
                      "Expiry:",
                      style: TextStyle(color: Colors.blue[700], fontSize: 16.0),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "Date",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text(
                      "Status:",
                      style: TextStyle(color: Colors.blue[700], fontSize: 16.0),
                    ),
                  ),
                  Text(
                    "Active",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
