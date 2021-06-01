const _appPrefix = 'clean_bloc';

String appDeepLink(String path, {bool includeSchema = false}) =>
    '${includeSchema ? 'app://' : ''}$_appPrefix/$path';
