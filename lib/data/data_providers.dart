import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../domain/use_cases/notes_use_cases.dart';
import 'data_sources/local/local_notes_data_source.dart';
import 'data_sources/local/notes_cache_manager.dart';
import 'data_sources/remote/notes_api.dart';
import 'data_sources/remote/remote_notes_data_source.dart';
import 'notes_repository.dart';

List<InheritedProvider> get dataProviders => [
      ProxyProvider<http.Client, NotesRemoteDataSource>(
        update: (_, httpClient, __) => NotesApi(httpClient: httpClient),
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
