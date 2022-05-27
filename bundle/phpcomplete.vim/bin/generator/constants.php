<?php

function extract_constant_names($files, $extensions) {
    $constants = array();
    $class_constants = array();

    foreach ($files as $file) {
        $doc = new DOMDocument;
        $doc->loadHTMLFile($file);
        $xpath = new DOMXpath($doc);

        // Unfortunately, the constatns are not marked with classes in code,
        // only a <strong><code>UPPERCASE_LETTER</code></strong> seem to be universal among them
        // xpath1 doesn't have uppercase so but fortunately the alphabet is pretty limited
        // so translate() will do for uppercasing content so we only select full uppercased contents
        $nodes = $xpath->query('//strong/code[translate(text(), "abcdefghijklmnopqrstuvwxyz", "ABCDEFGHIJKLMNOPQRSTUVWXYZ") = text()]');
        foreach ($nodes as $node) {
            // regexp lifted from http://php.net/manual/en/language.constants.php added ":" so we can pick up class constants
            if (preg_match('/^[a-zA-Z_\x7f-\xff][:a-zA-Z0-9_\x7f-\xff]*$/', trim($node->textContent))) {
                $constant = trim($node->textContent);

                // these are so common they are in almost every file,
                // to trim down the number of non-empty extensions we handle them elsewhere
                if (strpos($constant, 'E_') === 0 || strpos($constant, '__') === 0 || in_array($constant, array('NULL', 'TRUE', 'FALSE'))) {
                    $constants['common'][$constant] = true;
                    continue;
                }
                $extension_name = get_extension_name($file, $extensions);
                if ($extension_name === null){
                    continue;
                }
                if (strpos($constant, "::") !== false) {
                    if (!isset($class_constants[$extension_name])) {
                         $class_constants[$extension_name] = array();
                    }
                    $class_constants[$extension_name][$constant] = true;
                } else {
                    if (!isset($constants[$extension_name])) {
                         $constants[$extension_name] = array();
                    }
                    $constants[$extension_name][$constant] = true;
                }
            }
        }
    }
    return array($constants, $class_constants);
}

function inject_class_constants(&$class_groups, $class_constant_groups, $generate_warnings = true) {
    // a lowercaseclassname => LowerCaseClassName map
    $classnames = array();
    foreach ($class_groups as $extension => $classes) {
        $classnames = array_merge($classnames, array_combine(array_map('strtolower', array_keys($classes)), array_keys($classes)));
    }

    foreach ($class_constant_groups as $const_extension => $class_constants) {
        foreach ($class_constants as $constant => $__not_used) {
            list($classname, $constantname) = explode('::', $constant);
            $lowercase_classname = strtolower($classname);
            if (!isset($classnames[$lowercase_classname])) {
                if ($generate_warnings) {
                    fwrite(STDERR, "\nNOTICE: can't place class constant: '{$constant}', no such class found: '{$classname} ({$lowercase_classname})'");
                }
                continue;
            }

            $classname = $classnames[$lowercase_classname];
            foreach ($class_groups as $class_extension => $classes) {
                if (isset($classes[$classname])) {
                    $class_groups[$class_extension][$classname]['constants'][$constantname] = array('initializer' => '');
                    continue 2;
                }
            }

            // this line only reached if the previous loop fails to place the constant
            if ($generate_warnings) {
                fwrite(STDERR, "\nNOTICE: can't place class constant: '{$constant}', no such class found: '{$classname}' 2");
            }
        }
    }
}

function write_constant_names_to_vim_hash($constant_groups, $outpath, $keyname, $enabled_extensions = null, $prettyprint = true) {
    $fd = fopen($outpath, 'a');
    if (!empty($enabled_extensions)) {
        $enabled_extensions = array_flip($enabled_extensions);
    }
    foreach ($constant_groups as $extension_name => $constants) {
        if (empty($constants)) {
            continue;
        }
        if ($enabled_extensions && !isset($enabled_extensions[filenameize($extension_name)])) {
            continue;
        }

        if ($prettyprint) {
            fwrite($fd, "let g:phpcomplete_builtin['".$keyname."']['".filenameize($extension_name)."'] = {\n");
        } else {
            fwrite($fd, "let g:phpcomplete_builtin['".$keyname."']['".filenameize($extension_name)."']={");
        }
        foreach ($constants as $constant => $__not_used) {
            if ($prettyprint) {
                fwrite($fd, "\\ '{$constant}': '',\n");
            } else {
                fwrite($fd, "'{$constant}':'',");
            }
        }
        if ($prettyprint) {
            fwrite($fd, "\\ }\n");
        } else {
            fwrite($fd, "}\n");
        }
    }
    fclose($fd);
}
