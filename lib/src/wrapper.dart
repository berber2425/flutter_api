import 'package:api/src/link.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ApiWrapper extends StatelessWidget {
  const ApiWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(client: clientNotifier, child: child);
  }
}
