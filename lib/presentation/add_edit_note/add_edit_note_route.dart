import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuvigator/next.dart';

import '../shared/route_helper.dart';
import 'add_edit_note_screen.dart';
import 'bloc/add_edit_note_bloc.dart';

const _addNotePath = 'notes/add';
const _editNotePath = 'notes/:id';

String addNoteDeepLink({bool includeSchema = false}) =>
    appDeepLink(_addNotePath, includeSchema: includeSchema);

String editNoteDeepLink({required String id, bool includeSchema = false}) =>
    appDeepLink(
      _editNotePath.replaceAll(':id', id),
      includeSchema: includeSchema,
    );

List<NuRoute> get addEditNoteRoutes => [
      _AddEditNoteRoute(deepLink: appDeepLink(_addNotePath)),
      _AddEditNoteRoute(deepLink: appDeepLink(_editNotePath)),
    ];

class _AddEditNoteRoute extends NuRoute {
  _AddEditNoteRoute({required this.deepLink});

  final String deepLink;

  @override
  Widget build(BuildContext context, NuRouteSettings<Object> settings) {
    return BlocProvider<AddEditNoteBloc>(
      create: (context) => AddEditNoteBloc(notesUseCases: context.read())
        ..add(AddEditNoteLoadEvent(
          id: settings.pathParameters['id']?.toString(),
        )),
      child: AddEditNoteScreen(
        onBack: () {
          Nuvigator.of(context)?.pop();
        },
        onSaved: () {
          Nuvigator.of(context)?.pop(true);
        },
      ),
    );
  }

  @override
  String get path => deepLink;

  @override
  ScreenType? get screenType => MaterialScreenType();
}
