<?php

/**
 * Create dictionaries for phpcomlete.vim to use in autocompletion
 *
 * Uses the offical PHP documentation html files to extract function
 * and method names with parameter signatures. The extracted info
 * dumped into vim dictionaries that phpcomlete.vim plugin loads in
 * for omnicomplete.
 */

require_once __DIR__.'/'.'generator/tools.php';
require_once __DIR__.'/'.'generator/constants.php';
require_once __DIR__.'/'.'generator/functions.php';
require_once __DIR__.'/'.'generator/classes.php';

$dist_enabled_function_extensions  = array(
    'math', 'strings', 'apache', 'arrays', 'php_options_info', 'classes_objects',
    'urls', 'filesystem', 'variable_handling', 'calendar',
    'function_handling', 'directories', 'date_time', 'network', 'spl',
    'misc', 'curl', 'error_handling', 'dom', 'program_execution',
    'mail', 'fastcgi_process_manager', 'filter', 'fileinfo', 'output_control',
    'gd', 'iconv', 'json', 'libxml', 'multibyte_string', 'mssql',
    'mysql', 'mysqli', 'password_hashing', 'postgresql',
    'pcre', 'sessions', 'streams', 'simplexml', 'xmlwriter', 'zip',
);
$dist_enabled_class_extensions = array(
    'spl', 'predefined_interfaces_and_classes', 'curl', 'date_time', 'directories',
    'dom', 'predefined_exceptions', 'libxml', 'mysqli', 'pdo', 'phar', 'streams',
    'sessions', 'simplexml', 'spl_types', 'xmlreader', 'zip',
);
$dist_enabled_interface_extensions = array(
    'predefined_interfaces_and_classes', 'spl', 'date_time', 'json',
);
$dist_enabled_constant_extensions  = array(
    'common', 'arrays', 'calendar', 'curl', 'date_time', 'libxml', 'mysqli', 'spl',
    'unknow', 'directories', 'dom', 'command_line_usage', 'handling_file_uploads',
    'fileinfo', 'filesystem', 'filter', 'php_options_info', 'strings',
    'error_handling', 'math', 'network', 'urls', 'gd', 'json', 'multibyte_string',
    'mssql', 'mysql', 'output_control', 'password_hashing', 'postgresql',
    'pcre', 'program_execution', 'sessions', 'variable_handling', 'misc',
    'streams','iconv', 'phpini_directives', 'types', 'pdo',
    'list_of_reserved_words', 'php_type_comparison_tables',
);

function main($argv){

    if (count($argv) < 3) {
        usage($argv);
        return 1;
    }

    if (!is_dir($argv[1])) {
        fprintf(STDERR, "Error: Invalid php_doc_path. {$argv[1]} is not a directory\n\n");
        usage($argv);
        return 1;
    }
    if (!is_readable($argv[1])) {
        fprintf(STDERR, "Error: Invalid php_doc_path. {$argv[1]} is not readalbe\n\n");
        usage($argv);
        return 1;
    }
    if (!is_dir($argv[2])) {
        fprintf(STDERR, "Error: Invalid plugin_path. {$argv[2]} is not a directory\n\n");
        usage($argv);
        return 1;
    }
    if (!is_dir($argv[2].'/misc')) {
        fprintf(STDERR, "Error: Invalid plugin_path. {$argv[2]}/misc is not a directory\n\n");
        usage($argv);
        return 1;
    }

    $extensions = get_extension_names($argv[1]);

    libxml_use_internal_errors(true);

    $function_files = glob("{$argv[1]}/function.*.html");
    $functions = extract_function_signatures($function_files, $extensions);

    $extra_function_files = list_procedural_style_files("{$argv[1]}");
    $functions = extract_function_signatures($extra_function_files, $extensions, $functions);

    $class_files = glob("{$argv[1]}/class.*.html", GLOB_BRACE);
    list($classes, $interfaces) = extract_class_signatures($class_files, $extensions);

    // unfortunately constants are really everywhere, the *constants.html almost there ok but leaves out
    // pages like filter.filters.sanitize.html
    $constant_files = glob("{$argv[1]}/*.html");
    list($constants, $class_constants) = extract_constant_names($constant_files, $extensions);

    // some class constants like PDO::* are not defined in the class synopsis
    // but they show up with the other constatns so we add them to the extracted classes
    inject_class_constants($interfaces, $class_constants, false);
    inject_class_constants($classes, $class_constants, false);


    $meta_outfile = $argv[2].'/misc/available_extensions';
    file_put_contents($meta_outfile, "Available function extensions:\n");
    file_put_contents($meta_outfile, join("\n", array_map(function($ext_name){ return "\t".filenameize($ext_name); }, array_keys($functions))), FILE_APPEND);

    file_put_contents($meta_outfile, "\n\nAvailable Class extensions:\n", FILE_APPEND);
    file_put_contents($meta_outfile, join("\n", array_map(function($ext_name){ return "\t".filenameize($ext_name); }, array_keys($classes))), FILE_APPEND);

    file_put_contents($meta_outfile, "\n\nAvailable Interface extensions:\n", FILE_APPEND);
    file_put_contents($meta_outfile, join("\n", array_map(function($ext_name){ return "\t".filenameize($ext_name); }, array_keys($interfaces))), FILE_APPEND);

    file_put_contents($meta_outfile, "\n\nAvailable Constant extensions:\n", FILE_APPEND);
    file_put_contents($meta_outfile, join("\n", array_map(function($ext_name){ return "\t".filenameize($ext_name); }, array_keys($constants))), FILE_APPEND);


    $outfile = $argv[2].'/misc/builtin.vim';
    file_put_contents(
        $outfile,
        "let g:phpcomplete_builtin = {\n"
        ."\ 'functions':{},\n"
        ."\ 'classes':{},\n"
        ."\ 'interfaces':{},\n"
        ."\ 'constants':{},\n"
        ."\ }\n"
    );

    write_function_signatures_to_vim_hash($functions, $outfile, 'functions');
    print "\nextracted ".array_sum(array_map(function($a){ return count($a); }, $functions))." built-in function";

    write_class_signatures_to_vim_hash($classes, $outfile, 'classes');
    print "\nextracted ".array_sum(array_map(function($a){ return count($a); }, $classes))." built-in class";

    write_class_signatures_to_vim_hash($interfaces, $outfile, 'interfaces');
    print "\nextracted ".array_sum(array_map(function($a){ return count($a); }, $interfaces))." built-in interface";

    write_constant_names_to_vim_hash($constants, $outfile, 'constants');
    print "\nextracted ".array_sum(array_map(function($a){ return count($a); }, $constants))." built-in constants";


    $dist_outfile = $argv[2].'/misc/dist_builtin.vim';
    file_put_contents(
        $dist_outfile,
        "let g:phpcomplete_builtin = {\n"
        ."\ 'functions':{},\n"
        ."\ 'classes':{},\n"
        ."\ 'interfaces':{},\n"
        ."\ 'constants':{},\n"
        ."\ }\n"
    );

    global $dist_enabled_function_extensions;
    global $dist_enabled_class_extensions;
    global $dist_enabled_interface_extensions;
    global $dist_enabled_constant_extensions;

    write_function_signatures_to_vim_hash($functions, $dist_outfile, 'functions', $dist_enabled_function_extensions, false);
    write_class_signatures_to_vim_hash($classes, $dist_outfile, 'classes', $dist_enabled_class_extensions, false);
    write_class_signatures_to_vim_hash($interfaces, $dist_outfile, 'interfaces', $dist_enabled_interface_extensions, false);
    write_constant_names_to_vim_hash($constants, $dist_outfile, 'constants', $dist_enabled_constant_extensions, false);

    return 0;
}

function usage($argv) {
    fprintf(STDERR,
        "USAGE:\n".
        "\tphp {$argv[0]} <php_doc_path> <plugin_path>\n".
        "\n".
        "php_doc_path:\n".
        "\tPath to a directory containing the\n".
        "\textracted Many HTML files version of the documentation.\n".
        "\tDownload from here: http://www.php.net/download-docs.php\n".
        "\n".
        "plugin_path:\n".
        "\tPath to the plugins root, example: ~/.vim/bundle/phpcomplete.vim/\n"
    );
}

return main($argv);
