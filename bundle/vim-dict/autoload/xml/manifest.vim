" Vim XML data file
" Last Change: 2015-09-15

let g:xmldata_manifest = {
\ 'vimxmlentities': ['lt', 'gt', 'amp', 'apos', 'quot'],
\ 'vimxmlroot': ['manifest'],
\ 'activity': [
\ ['intent-filter', 'meta-data'],
\ {'android:allowEmbedded': [], 'android:configChanges': [], 'android:enabled': [], 'android:excludeFromRecents': [], 'android:exported': [], 'android:hardwareAccelerated': [], 'android:icon': [], 'android:label': [], 'android:launchMode': [], 'android:logo': [], 'android:name': [], 'android:noHistory': [], 'android:parentActivityName': [], 'android:persistableMode': [], 'android:relinquishTaskIdentity': [], 'android:screenOrientation': [], 'android:stateNotNeeded': [], 'android:taskAffinity': [], 'android:theme': [], 'android:uiOptions': [], 'android:windowSoftInputMode': []}
\ ],
\ 'data': [
\ [],
\ {'android:host': [], 'android:mimeType': [], 'android:scheme': [], 'android:ssp': []}
\ ],
\ 'meta-data': [
\ [],
\ {'android:name': [], 'android:resource': [], 'android:value': []}
\ ],
\ 'category': [
\ [],
\ {'android:name': []}
\ ],
\ 'uses-feature': [
\ [],
\ {'android:glEsVersion': [], 'android:name': [], 'android:required': []}
\ ],
\ 'uses-permission-sdk-m': [
\ [],
\ {'android:name': []}
\ ],
\ 'action': [
\ [],
\ {'android:name': []}
\ ],
\ 'application': [
\ ['activity', 'activity-alias', 'meta-data', 'provider', 'receiver', 'service', 'uses-library'],
\ {'android:allowBackup': [], 'android:backupAgent': [], 'android:debuggable': [], 'android:description': [], 'android:fullBackupContent': [], 'android:hardwareAccelerated': [], 'android:icon': [], 'android:label': [], 'android:logo': [], 'android:name': [], 'android:persistent': [], 'android:supportsRtl': [], 'android:theme': []}
\ ],
\ 'instrumentation': [
\ [],
\ {'android:label': [], 'android:name': [], 'android:targetPackage': []}
\ ],
\ 'activity-alias': [
\ ['intent-filter'],
\ {'android:label': [], 'android:name': [], 'android:targetActivity': []}
\ ],
\ 'receiver': [
\ ['intent-filter', 'meta-data'],
\ {'android:description': [], 'android:enabled': [], 'android:exported': [], 'android:label': [], 'android:name': [], 'android:permission': [], 'android:process': []}
\ ],
\ 'supports-screens': [
\ [],
\ {'android:compatibleWidthLimitDp': [], 'android:largeScreens': [], 'android:requiresSmallestWidthDp': []}
\ ],
\ 'uses-library': [
\ [],
\ {'android:name': [], 'android:required': []}
\ ],
\ 'uses-permission': [
\ [],
\ {'android:name': []}
\ ],
\ 'permission': [
\ [],
\ {'android:name': []}
\ ],
\ 'provider': [
\ ['grant-uri-permission', 'intent-filter'],
\ {'android:authorities': [], 'android:enabled': [], 'android:exported': [], 'android:grantUriPermissions': [], 'android:name': [], 'android:permission': []}
\ ],
\ 'manifest': [
\ ['application', 'instrumentation', 'meta-data', 'permission', 'supports-screens', 'uses-feature', 'uses-permission', 'uses-permission-sdk-m', 'uses-sdk'],
\ {'android:uiOptions': [], 'android:versionCode': [], 'android:versionName': [], 'package': []}
\ ],
\ 'intent-filter': [
\ ['action', 'category', 'data'],
\ {'android:label': []}
\ ],
\ 'uses-sdk': [
\ [],
\ {'android:minSdkVersion': [], 'android:targetSdkVersion': [], 'minSdkVersion': []}
\ ],
\ 'grant-uri-permission': [
\ [],
\ {'android:pathPattern': []}
\ ],
\ 'service': [
\ ['intent-filter', 'meta-data'],
\ {'android:allowEmbedded': [], 'android:enabled': [], 'android:exported': [], 'android:isolatedProcess': [], 'android:label': [], 'android:name': [], 'android:permission': [], 'android:process': [], 'android:stopWithTask': [], 'android:taskAffinity': []}
\ ],
\ }
