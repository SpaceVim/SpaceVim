<?php

function extract_function_signatures($files, $extensions, $signatures = array()) {
    foreach ($files as $file) {
        $extension_name = get_extension_name($file, $extensions);
        if ($extension_name === null){
            continue;
        }
        if (!isset($signatures[$extension_name])) {
            $signatures[$extension_name] = array();
        }

        $doc = new DOMDocument;
        $doc->loadHTMLFile($file);
        $xpath = new DOMXpath($doc);

        $removed_warning = $xpath->query('//div[contains(@id, "-refsynopsisdiv")]/div[@class="warning"]');
        if ($removed_warning->length > 0 && preg_match('/REMOVED\s+in\s+PHP\s+7\.\d+\.\d+/i', $removed_warning->item(0)->textContent)) {
          continue;
        }

        $nodes = $xpath->query('//div[contains(@class, "methodsynopsis")]');
        if ($nodes->length == 0) {
            // no signature found, maybe its an alias?
            $nodes = $xpath->query('//div[contains(@class, "description")]/p[@class="simpara"][contains(text(), "This function is an alias of:")]');
            if ($nodes->length) {
                $signatures[$extension_name][] = handle_func_alias($xpath, $nodes, $file);
            }
        } else if ($nodes->length == 1) {
            if (!preg_match('/\w+::\w+/', $nodes->item(0)->textContent)) {
                $signatures[$extension_name][] = handle_func_def($xpath, $nodes->item(0), $file);
            } else {
                fwrite(STDERR, "WARNING: Only class-like function definition found in ".$file."\n");
                continue;
            }
        } else if ($nodes->length > 1) {
            // more than one signature for a single function name
            // maybe its a procedural style of a method like  xmlwriter_text -> XMLWriter::text
            // search for the first non object style synopsis and extract from that
            foreach ($nodes as $node) {
                if (!preg_match('/\w+::\w+/', $node->textContent)) {
                    $signatures[$extension_name][] = handle_func_def($xpath, $node, $file);
                    break;
                }
            }
        }
    }
    return $signatures;
}

function list_procedural_style_files($dir) {
    $files = array();
    $dir = rtrim($dir, '/');
    $dh  = opendir($dir);

    $doc = new DOMDocument();
    while (false !== ($filename = readdir($dh))) {
        if (preg_match('/\.html$/', $filename)) {
            $doc->loadHTMLFile($dir.'/'.$filename);
            $xpath = new DOMXPath($doc);
            $nodes = $xpath->query('//p[contains(@class, "para") and contains(translate(text(), "P", "p"), "procedural style")]');
            if ($nodes && $nodes->length !== 0) {
                $files[] = $dir.'/'.$filename;
            }
        }
    }
    return array_unique($files);
}

function handle_func_def($xpath, $nodes, $file) {
    $type = $xpath->query('span[@class="type"]', $nodes);
    $methodname = $xpath->query('*[@class="methodname"]/*', $nodes);
    $methodparams = $xpath->query('*[@class="methodparam"]', $nodes);
    if ($type->length === 0) {
        fwrite(STDERR, "WARNING: can't find return type in ".$file."\n");
        $return_type = 'void';
    } else {
        $return_type = trim($type->item(0)->textContent);
    }
    if ($methodname->length === 0) {
        fwrite(STDERR, "Extraction error, can't find method name in ".$file."\n");
        exit;
    }
    $params = array();
    $optional = false;
    foreach ($methodparams as $param) {
        if (!$optional
            && $param->previousSibling->nodeType == XML_TEXT_NODE
            && strpos($param->previousSibling->textContent, '[') !== false) {

            $optional = true;
        }
        $paramtype = $xpath->query('*[@class="type"]', $param);
        $paramname = $xpath->query('*[contains(@class, "parameter")]', $param);
        $paramdefault = $xpath->query('*[@class="initializer"]', $param);
        if ($paramname->length) {
            // regular parameter
            $p = array(
                'type' => $paramtype->item(0)->textContent,
                'name' => $paramname->item(0)->textContent,
                'optional' => $optional,
            );
            if ($paramdefault->length) {
                $p['default'] = trim($paramdefault->item(0)->textContent, "=\r\n ");
                $p['optional'] = true;
            }
            $params[] = $p;
        }
    }
    $full_signature = preg_replace('/\s+/', ' ', trim(str_replace(array("\n", "\t", "\r"), "", $nodes->textContent)));
    return array(
        'type' => 'function',
        'full_signature' => $full_signature,
        'return_type' => $return_type,
        'name' => trim($methodname->item(0)->textContent),
        'params' => $params
    );
}

function handle_func_alias($xpath, $nodes, $file) {
    $methodname = $xpath->query('//h1[@class="refname"]');
    $refname = $xpath->query('//*[contains(@class, "description")]/p[@class="simpara"]/*[@class="methodname" or @class="function"]');
    $name = trim(str_replace("\n", '', $methodname->item(0)->textContent));
    $aliased_name = trim(str_replace("\n", '', $refname->item(0)->textContent));
    $full_signature = "$name — Alias of $aliased_name";
    return array(
        'type' => 'alias',
        'full_signature' => $full_signature,
        'name' => $name,
        'aliased_name' => $aliased_name,
    );
}

function write_function_signatures_to_vim_hash($signatures, $outpath, $keyname, $enabled_extensions = null, $prettyprint = true) {
    $fd = fopen($outpath, 'a');
    if (!empty($enabled_extensions)) {
        $enabled_extensions = array_flip($enabled_extensions);
    }
    foreach ($signatures as $extension_name => $functions) {
        if (empty($functions)) {
            continue;
        }
        if ($enabled_extensions && !isset($enabled_extensions[filenameize($extension_name)])) {
            continue;
        }

        // weed out duplicates, (like nthmac) only keep the first occurance
        $functions = array_index_by_col($functions, 'name', false);

        if ($prettyprint) {
            fwrite($fd, "let g:phpcomplete_builtin['".$keyname."']['".filenameize($extension_name)."'] = {\n");
        } else {
            fwrite($fd, "let g:phpcomplete_builtin['".$keyname."']['".filenameize($extension_name)."']={");
        }
        foreach ($functions as $function) {
            if ($function['type'] == 'function') {
                if ($prettyprint) {
                    fwrite($fd, "\\ '{$function['name']}(': '".format_method_signature($function)."',\n");
                } else {
                    fwrite($fd, "'{$function['name']}(':'".format_method_signature($function)."',");
                }
            } else if ($function['type'] == 'alias') {
                if ($prettyprint) {
                    fwrite($fd, "\\ '{$function['name']}(': '".vimstring_escape($function['full_signature'])."',\n");
                } else {
                    fwrite($fd, "'{$function['name']}(':'".vimstring_escape($function['full_signature'])."',");
                }
            } else {
                fwrite(STDERR, 'unknown signature type '.var_export($function, true));
                exit;
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
