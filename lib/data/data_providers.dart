import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../domain/use_cases/notes_use_cases.dart';
import '../main.dart';
import 'data_sources/notes_api.dart';
import 'data_sources/notes_cache_manager.dart';
import 'notes_repository.dart';

List<InheritedProvider> get dataProviders => [
      Provider<http.Client>(create: (_) => http.Client()),
      ProxyProvider<http.Client, NotesRemoteDataSource>(
        update: (_, httpClient, __) =>
            useFakeApi ? FakeNotesApi() : NotesApi(httpClient: httpClient),
      ),
      Provider<NotesLocalDataSource>(create: (_) => NotesCacheManager()),
      ProxyProvider2<NotesLocalDataSource, NotesRemoteDataSource,
          NotesUseCases>(
        update: (_, notesLocalDs, notesRemoteDs, __) => NotesRepository(
          notesRemoteDataSource: notesRemoteDs,
          notesLocalDataSource: notesLocalDs,
        ),
      ),
    ];
