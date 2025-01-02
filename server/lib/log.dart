import 'package:logging/logging.dart';

final log = Logger("server")
  ..onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
