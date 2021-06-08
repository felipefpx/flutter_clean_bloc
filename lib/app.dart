import 'package:flutter/material.dart';
import 'package:nuvigator/next.dart';
import 'package:provider/provider.dart';

import 'data/data_providers.dart';
import 'presentation/add_edit_note/add_edit_note_route.dart';
import 'presentation/note_list/note_list_route.dart';

const appName = 'Flutter Clean-BloC';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ...dataProviders,
        ],
        child: Nuvigator.routes(
          initialRoute: noteListDeepLink(),
          routes: [
            NoteListRoute(),
            ...addEditNoteRoutes,
          ],
        ),
      ),
    );
  }
}
