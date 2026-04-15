// Conditional export shim
export 'io_utils_io.dart' if (dart.library.html) 'io_utils_web.dart';
