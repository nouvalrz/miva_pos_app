import 'package:miva_pos_app/app/services/supabase_powersync_connector.dart';
import 'package:miva_pos_app/app/services/supabase_service.dart';
import "package:powersync/powersync.dart";
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:miva_pos_app/app/data/models/schema.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// GLOBAL REFERENCE TO DATABASE
late final PowerSyncDatabase db;

Future<String> getDatabasePath() async {
  final dir = await getApplicationCacheDirectory();
  return join(dir.path, 'powersync-dart.db');
}

Future<void> openDatabase() async {
  // Set up LOCAL DATABASE
  db = PowerSyncDatabase(schema: schema, path: await getDatabasePath());
  await db.initialize();

  // Set up REMOTE DATABASE
  // Open supabase connection
  await openSupabase();

  SupabasePowersyncConnector? currentConnector;

  if (isLoggedIn()) {
    // If the user is already logged in, connect immediately.
    // Otherwise, connect once logged in.
    currentConnector = SupabasePowersyncConnector(db);
    db.connect(connector: currentConnector);
  }

  Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
    final AuthChangeEvent event = data.event;
    if (event == AuthChangeEvent.signedIn) {
      // Connect to PowerSync when the user is signed in
      currentConnector = SupabasePowersyncConnector(db);
      db.connect(connector: currentConnector!);
    } else if (event == AuthChangeEvent.signedOut) {
      // Implicit sign out - disconnect, but don't delete data
      currentConnector = null;
      await db.disconnect();
    } else if (event == AuthChangeEvent.tokenRefreshed) {
      // Supabase token refreshed - trigger token refresh for PowerSync.
      currentConnector?.prefetchCredentials();
    }
  });
}

Future<void> logout() async {
  await Supabase.instance.client.auth.signOut();
  await db.disconnectAndClear();
}
