// Copyright (c) 2013, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart' as arch;
import 'package:grinder/grinder.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:polymer/builder.dart' as polymer;

final NumberFormat _NF = new NumberFormat.decimalPattern();

final Directory BUILD_DIR = new Directory('build');
final Directory DIST_DIR = new Directory('dist');


void main([List<String> args]) {
  task('setup', setup);

  task('mode-notest', (c) => _changeMode(useTestMode: false));
  task('mode-test', (c) => _changeMode(useTestMode: true));

  task('lint', lint, ['setup']);

  task('deploy', deploy, ['lint']);

  task('stats', stats);
  task('archive', archive, ['mode-notest', 'deploy']);
  task('createSdk', createSdk);

  task('clean', clean);
  
  task('da', removeDartFiles);

  startGrinder(args);
}

/**
 * Init needed dependencies.
 */
void setup(GrinderContext context) {
  // Check to make sure we can locate the SDK.
  if (sdkDir == null) {
    context.fail("Unable to locate the Dart SDK\n"
        "Please set the DART_SDK environment variable to the SDK path.\n"
        "  e.g.: 'export DART_SDK=your/path/to/dart/dart-sdk'");
  }

  //Pub.upgrade(context);

  BUILD_DIR.createSync();
  DIST_DIR.createSync();

  _removeSymlinks(joinDir(Directory.current, ['web']), ignoreTop : true);
}

/**
 * Run Polymer lint on the Polymer entry point.
 */
void lint(GrinderContext context) {
  const entryPoint = 'web/rss_app.html';

  context.log('Running polymer linter on ${entryPoint}...');
  polymer.lint(
      entryPoints: [entryPoint],
      options: polymer.parseOptions([]),
      currentPackage: 'rssapp'
  );

  context.log('');
  context.log('Running release-config.json linter...');
  Map<String, Map> configs = JSON.decode(
      new File('tool/release-config.json').readAsStringSync());

  List<String> branchNames = [];

  configs.forEach((String name, Map config) {
    Function _verify = (key) {
      if (config[key] == null) context.fail("'${key}' field is missing");
      if (config[key].isEmpty) context.fail("'${key}' field is empty");
    };

    context.log('linting ${name} release');

    _verify('name');
    _verify('branch');
    _verify('version');
    
    String branch = config['branch'];
    if (branchNames.contains(branch)) {
      context.fail("Branch name '${branch}' is duplicated");
    }
    branchNames.add(branch);
  });
}

/**
 * Do a polymer deploy to `build/web/`.
 */
void deploy(GrinderContext context) {
  Directory destDir = BUILD_DIR;

  _polymerDeploy(context, destDir);

  Directory deployWeb = joinDir(destDir, ['web']);

  _dart2jsCompile(context, deployWeb, 'rss_app.html_bootstrap.dart');

  // Remove map files.
  List files = BUILD_DIR.listSync(recursive: true, followLinks: false);
  for (FileSystemEntity entity in files) {
    if (entity is File && entity.path.endsWith('.js.map')) {
      deleteEntity(entity);
    }
  }

  _removeSymlinks(joinDir(BUILD_DIR, ['web']), ignoreTop : true);
  _removeDartFiles(BUILD_DIR);
}



// Creates an archive of the Chrome App.
//
// Sources must be pre-compiled to Javascript using "deploy" task.
//
// Will create an archive using the contents of build/web/:
// - Copy the compiled sources to build/chrome-app
// - Clean all packages/ folders that have been duplicated into every
//   folders by the "compile" task
// - Copy the packages/ directory to build/chrome-app/packages
// - Remove test
// - Zip the content of build/chrome-app to dist/app.zip
void archive(GrinderContext context, [String outputZip]) {
  final String sparkZip = outputZip == null ? '${DIST_DIR.path}/app.zip' :
                                              '${DIST_DIR.path}/${outputZip}';
  _delete(sparkZip);
  _removeSymlinks(joinDir(BUILD_DIR, ['web']), ignoreTop : true);
  _zip(context, 'build/web', sparkZip);
  _printSize(context, getFile(sparkZip));
}

void stats(GrinderContext context) {
  StatsCounter stats = new StatsCounter();
  stats.collect(getDir('..'));
  context.log(stats.toString());
}

/**
 * Create the 'lib/sdk/dart-sdk.bz' file from the current Dart SDK.
 */
void createSdk(GrinderContext context) {
  Directory srcSdkDir = sdkDir;
  Directory destSdkDir = new Directory('lib/sdk');

  destSdkDir.createSync();

  File versionFile = joinFile(srcSdkDir, ['version']);
  File destArchiveFile = joinFile(destSdkDir, ['dart-sdk.bin']);
  File destCompressedFile = joinFile(destSdkDir, ['dart-sdk.bz']);

  // copy files over
  context.log('copying SDK');
  copyDirectory(joinDir(srcSdkDir, ['lib']), joinDir(destSdkDir, ['lib']), context);

  // Get rid of some big directories we don't use.
  _delete('web/sdk/lib/_internal/compiler', context);
  _delete('web/sdk/lib/_internal/pub', context);

  context.log('creating SDK archive');
  _createSdkArchive(versionFile, joinDir(destSdkDir, ['lib']), destArchiveFile);

  // Create the compresed file; delete the original.
  _compressFile(destArchiveFile, destCompressedFile);
  destArchiveFile.deleteSync();

  deleteEntity(joinDir(destSdkDir, ['lib']), context);
}

/**
 * Delete all generated artifacts.
 */
void clean(GrinderContext context) {
  // Delete any compiled js output.
  for (FileSystemEntity entity in getDir('web').listSync()) {
    if (entity is File) {
      String ext = fileExt(entity);

      if (ext == 'js.map' || ext == 'js.deps' || ext == 'dart.js') {
        entity.deleteSync();
      }
    }
  }

  // Delete the build/ dir.
  deleteEntity(BUILD_DIR);

  // Remove any symlinked packages that may have snuck into app/.
  for (var entity in getDir('web').listSync(recursive: true, followLinks: false)) {
    if (entity is Link && fileName(entity) == 'packages') {
      entity.deleteSync();
    }
  }
}

void buildAndroidRSA(GrinderContext context) {
  context.log('building PNaCL Android RSA module');
  final Directory androidRSADir = new Directory('nacl_android_rsa');
  _runCommandSync(context, './make.sh', cwd: androidRSADir.path);
  Directory appMobileDir = getDir('web/lib/mobile');
  appMobileDir.createSync();
  copyFile(getFile('nacl_android_rsa/nacl_android_rsa.nmf'), appMobileDir, context);
  copyFile(getFile('nacl_android_rsa/nacl_android_rsa.pexe'), appMobileDir, context);
}

void _zip(GrinderContext context, String dirToZip, String destFile) {
  final String destPath = path.relative(destFile, from: dirToZip);

  if (Platform.isWindows) {
    try {
      // 7z a -r '${destFile}'
      runProcess(
          context,
          '7z',
          arguments: ['a', '-r', destPath, '.'],
          workingDirectory: dirToZip,
          quiet: true);
    } on ProcessException catch(e) {
      context.fail("Unable to execute 7z.\n"
        "Please install 7zip. Add 7z directory to the PATH environment variable.");
    }
  } else {
    // zip '${destFile}' . -r -q -x .*
    runProcess(
        context,
        'zip',
        arguments: [destPath, '.', '-qr', '-x', '.*'],
        workingDirectory: dirToZip);
  }
}

void _polymerDeploy(GrinderContext context, Directory destDir) {
  deleteEntity(getDir('${destDir.path}'), context);

  var args = ['--out', destDir.path];

  runDartScript(context, 'packages/polymer/deploy.dart',
      arguments: args,
      packageRoot: 'packages');

  // Create an empty `user.json` overrides file so we don't get an error in the
  // console in the deployed application.
  File userJsonFile = joinFile(destDir, ['web', 'user.json']);
  if (!userJsonFile.existsSync()) {
    userJsonFile.writeAsStringSync('{}\n');
  }
}

void _dart2jsCompile(GrinderContext context, Directory target, String filePath) {
  context.log('Compile dart code to javascritp.');
  context.log('SDK location: ${sdkDir.path}');
  
  
  File scriptFile = joinFile(sdkDir, ['bin', _execName('dart2js')]);
  
  // Run dart2js with a custom heap size.
  _runProcess(context, scriptFile.path,
      arguments: [
        joinDir(target, [filePath]).path,
        '--package-root=packages',
        '--suppress-warnings',
        '--suppress-hints',
        '--csp',
        '--minify',
        '--out=' + joinDir(target, ['${filePath}.js']).path
      ],
      environment: {
        'DART_VM_OPTIONS': '--old_gen_heap_size=2048'
      }
  );

  // clean up unnecessary (and large) files
  deleteEntity(joinFile(target, ['${filePath}.js.deps']), context);
  deleteEntity(joinFile(target, ['${filePath}.js.map']), context);

  _printSize(context, joinFile(target, ['${filePath}.js']));
}

void _changeMode({bool useTestMode: true}) {
  _changeModeImpl(useTestMode, joinFile(Directory.current, ['web', 'user.json']));
  _changeModeImpl(useTestMode, joinFile(BUILD_DIR, ['web', 'user.json']));
}

void _changeModeImpl(bool useTestMode, File file) {
  if (!file.parent.existsSync()) return;
  file.createSync();
  String content = file.readAsStringSync();
  var dict;
  try {
    dict = JSON.decode(content);
  } catch (e) {
    dict = new Map();
  }
  dict['test-mode'] = useTestMode;
  file.writeAsStringSync(new JsonPrinter().print(dict));
}

// Returns the URL of the git repository.
String _getRepositoryUrl() {
  return _getCommandOutput('git config remote.origin.url');
}

// Returns the current revision identifier of the local copy.
String _getCurrentRevision() {
  return _getCommandOutput('git rev-parse HEAD').substring(0, 10);
}


/**
 * Create an archived version of the Dart SDK.
 *
 * File format is:
 *  - sdk version, as a utf8 string (null-terminated)
 *  - file count, printed as a utf8 string
 *  - n file entries:
 *    - file path, as a UTF8 string
 *    - file length (utf8 string)
 *  - file contents appended to the archive file, n times
 */
void _createSdkArchive(File versionFile, Directory srcDir, File destFile) {
  List files = srcDir.listSync(recursive: true, followLinks: false);
  files = files.where((f) => f is File).toList();

  ByteWriter writer = new ByteWriter();

  String version = versionFile.readAsStringSync().trim();
  writer.writeString(version);
  writer.writeInt(files.length);

  String pathPrefix = srcDir.path + Platform.pathSeparator;

  for (File file in files) {
    String path = file.path.substring(pathPrefix.length);
    path = path.replaceAll(Platform.pathSeparator, '/');
    writer.writeString(path);
    writer.writeInt(file.lengthSync());
  }

  for (File file in files) {
    writer.writeBytes(file.readAsBytesSync());
  }

  destFile.writeAsBytesSync(writer.toBytes());
}

/**
 * Create a bzip2 compressed version of the input file.
 */
void _compressFile(File sourceFile, File destFile) {
  List<int> data = sourceFile.readAsBytesSync();
  arch.BZip2Encoder encoder = new arch.BZip2Encoder();
  List<int> output = encoder.encode(data);
  destFile.writeAsBytesSync(output);
}

void _printSize(GrinderContext context, File file) {
  int sizeKb = file.lengthSync() ~/ 1024;
  context.log('${file.path} is ${_NF.format(sizeKb)}k');
}

void _delete(String path, [GrinderContext context]) {
  path = path.replaceAll('/', Platform.pathSeparator);

  if (FileSystemEntity.isFileSync(path)) {
    deleteEntity(getFile(path), context);
  } else {
    deleteEntity(getDir(path), context);
  }
}

void _rename(String srcPath, String destPath, [GrinderContext context]) {
   if (context != null) {
     context.log('rename ${srcPath} to ${destPath}');
   }
   File srcFile = new File(srcPath);
   srcFile.renameSync(destPath);
}

void _copyFileWithNewName(File srcFile, Directory destDir, String destFileName,
                          [GrinderContext context]) {
  File destFile = joinFile(destDir, [destFileName]);
  if (context != null) {
    context.log('copying ${srcFile.path} to ${destFile.path}');
  }
  destDir.createSync(recursive: true);
  destFile.writeAsBytesSync(srcFile.readAsBytesSync());
}

void _runCommandSync(GrinderContext context, String command, {String cwd}) {
  context.log(command);

  ProcessResult result;
  if (Platform.isWindows) {
    result = Process.runSync('cmd.exe', ['/c', command], workingDirectory: cwd);
  } else {
    result = Process.runSync('/bin/sh', ['-c', command], workingDirectory: cwd);
  }

  if (result.stdout.isNotEmpty) {
    context.log(result.stdout);
  }

  if (result.stderr.isNotEmpty) {
    context.log(result.stderr);
  }

  if (result.exitCode > 0) {
    context.fail("exit code ${result.exitCode}");
  }
}

String _getCommandOutput(String command) {
  if (Platform.isWindows) {
    return Process.runSync('cmd.exe', ['/c', command]).stdout.trim();
  } else {
    return Process.runSync('/bin/sh', ['-c', command]).stdout.trim();
  }
}

/**
 * Run the given executable, with optional arguments and working directory.
 */
void _runProcess(GrinderContext context, String executable,
    {List<String> arguments : const [],
     bool quiet: false,
     String workingDirectory,
     Map<String, String> environment}) {
  context.log("${executable} ${arguments.join(' ')}");

  ProcessResult result = Process.runSync(
      executable, arguments, workingDirectory: workingDirectory,
      environment: environment);

  if (!quiet) {
    if (result.stdout != null && !result.stdout.isEmpty) {
      context.log(result.stdout.trim());
    }
  }

  if (result.stderr != null && !result.stderr.isEmpty) {
    context.log(result.stderr);
  }

  if (result.exitCode != 0) {
    throw new GrinderException(
        "${executable} failed with a return code of ${result.exitCode}");
  }
}

String _execName(String name) {
  if (Platform.isWindows) {
    return name == 'dart' ? 'dart.exe' : '${name}.bat';
  }

  return name;
}

void _removeSymlinks(Directory dir, {bool ignoreTop: false}) {
  for (var entity in dir.listSync(recursive: true, followLinks: false)) {
    if (entity is Link && !ignoreTop) {
      try { entity.deleteSync(); } catch (e) { print(e); }
    } else if (entity is Directory) {
      _removeSymlinks(entity);
    }
  }
}

void removeDartFiles(GrinderContext context){
  Directory destDir = BUILD_DIR;
  _removeDartFiles(BUILD_DIR);
}
void _removeDartFiles(Directory dir){
  for (var entity in dir.listSync(recursive: true, followLinks: false)) {
    
    if (entity is Directory) {
      _removeDartFiles(entity);
    } else {
      if (entity is File && entity.path.endsWith('.dart')) {
        try { entity.deleteSync(); } catch (e) { print(e); }
      }
    }
  }
}

/**
 * Pretty print Json text.
 *
 * Usage:
 *     String str = new JsonPrinter().print(jsonObject);
 */
class JsonPrinter {
  String _in = '';

  JsonPrinter();

  /**
   * Given a structured, json-like object, print it to a well-formatted, valid
   * json string.
   */
  String print(dynamic json) {
    return _print(json) + '\n';
  }

  String _print(var obj) {
    if (obj is List) {
      return _printList(obj);
    } else if (obj is Map) {
      return _printMap(obj);
    } else if (obj is String) {
      return '"${obj}"';
    } else {
      return '${obj}';
    }
  }

  String _printList(List list) {
    return "[${_indent()}${list.map(_print).join(',${_newLine}')}${_unIndent()}]";
  }

  String _printMap(Map map) {
    return "{${_indent()}${map.keys.map((key) {
      return '"${key}": ${_print(map[key])}';
    }).join(',${_newLine}')}${_unIndent()}}";
  }

  String get _newLine => '\n${_in}';

  String _indent() {
    _in += '  ';
    return '\n${_in}';
  }

  String _unIndent() {
    _in = _in.substring(2);
    return '\n${_in}';
  }
}

class StatsCounter {
  int _files = 0;
  int _lines = 0;

  void collect(Directory dir) => _collectLineInfo(dir);

  int get fileCount => _files;

  int get lineCount => _lines;

  String toString() => 'Found ${_NF.format(fileCount)} Dart files and '
      '${_NF.format(lineCount)} lines of code.';

  void _collectLineInfo(Directory dir) {
    for (FileSystemEntity entity in dir.listSync(followLinks: false)) {
      if (entity is Directory) {
        if (fileName(entity) != 'packages' &&
            fileName(entity) != 'build' &&
            !fileName(entity).startsWith('.')) {
          _collectLineInfo(entity);
        }
      } else if (entity is File) {
        if (fileExt(entity) == 'dart') {
          _files++;
          _lines += _lineCount(entity);
        }
      }
    }
  }

  static int _lineCount(File file) {
    return file.readAsStringSync().split('\n').where(
        (l) => l.trim().isNotEmpty).length;
  }
}

class ByteWriter {
  List<int> _bytes = [];

  void writeString(String str) {
    writeBytes(UTF8.encoder.convert(str));
    _bytes.add(0);
  }

  void writeInt(int val) => writeString(val.toString());

  void writeBytes(List<int> data) => _bytes.addAll(data);

  List<int> toBytes() => _bytes;
}
