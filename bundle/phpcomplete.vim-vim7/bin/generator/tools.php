<?php

function format_method_signature($signature) {
    $optional_depth = 0;
    $istr = '';
    if (empty($signature['params'])) {
        // "__construct"s have no return type, they dont need the " |" at the end
        return 'void'.($signature['return_type'] ? ' | '.$signature['return_type'] : '');
    }
    foreach ($signature['params'] as $i => $param) {
        if ($param['optional'] || isset($param['default']) || $optional_depth != 0) {
            ++$optional_depth;
            if ($i != 0) {
                $istr .= ' [, ';
            } else {
                $istr .= '[ ';
            }
        } elseif ($i != 0) {
            $istr .= ', ';
        }
        $istr .= $param['type'];
        $istr .= ' ';
        $istr .= $param['name'];
        if (isset($param['default'])) {
            $istr .= ' = '.vimstring_escape($param['default']);
        }
    }
    $istr .= str_repeat(']', $optional_depth);
    if ($signature['return_type']) {
        $istr .= ' | '.$signature['return_type'];
    }
    return trim($istr);
}

function get_extension_names($docs_dir) {
    $re = array();
    $doc = new DOMDocument('1.0', 'utf-8');
    $doc->loadHTMLFile($docs_dir.'/extensions.membership.html');
    $xpath = new DOMXPath($doc);

    $links_nodes = $xpath->query('//ul[@class="itemizedlist"]//a[@class="xref"]');
    foreach ($links_nodes as $link_node) {
        $re[$link_node->getAttribute('href')] = $link_node->textContent;
    }

    $doc = new DOMDocument('1.0', 'utf-8');
    @$doc->loadHTMLFile($docs_dir.'/funcref.html');
    $xpath = new DOMXPath($doc);
    $link_nodes = $xpath->query('//ul[@class="chunklist chunklist_set chunklist_children"]/li/a');
    foreach ($link_nodes as $link_node) {
        $re[$link_node->getAttribute('href')] = $link_node->textContent;
    }

    foreach (array('langref.html', 'appendices.html', 'features.html') as $file) {
        $doc = new DOMDocument('1.0', 'utf-8');
        $doc->loadHTMLFile($docs_dir.'/'.$file);
        $xpath = new DOMXPath($doc);

        $category_nodes = $xpath->query('//ul[@class="chunklist chunklist_book"]/li');
        foreach ($category_nodes as $category_node) {
            $category_name_node = $xpath->query('a', $category_node)->item(0);
            $category_name = trim($category_name_node->textContent);
            $re[$category_name_node->getAttribute('href')] = $category_name;

            $link_nodes = $xpath->query('ul[@class="chunklist chunklist_book chunklist_children"]/li/a', $category_node);
            if ($link_nodes->length > 0) {
                foreach ($link_nodes as $link_node) {
                    // save sub-category file names under the category name
                    $re[$link_node->getAttribute('href')] = $category_name;
                }
            }
        }
    }

    return $re;
}

function get_extension_name($file, $extensions) {
    $doc_dir = dirname($file);
    $current_file = basename($file);
    $files_checked = array();

    do {
        if (isset($extensions[$current_file])) {
            return $extensions[$current_file];
        }

        $doc = new DOMDocument;
        $doc->loadHTMLFile($doc_dir.'/'.$current_file);
        $xpath = new DOMXPath($doc);



        $up_link = $xpath->query('//ul[@class="breadcrumbs-container"]/li[position()>=2 and position() <= (last() - 1)]/a');
        if ($up_link->length == 0) {
            fwrite(STDERR, "\nWARNING: Can't find up link in ".$current_file.' started ascending from '.$file);
            return null;
        }

        $up_href = $up_link->item(0)->getAttribute('href');
        if ($current_file == $up_href) {
            fwrite(STDERR, "\nWARNING: up link traversal got stuck at ".$current_file." started ascending from ".$file);
            return null;
        }

        $files_checked[] = $current_file;
        $current_file = $up_href;

    } while ($current_file != 'index.html');

    fwrite(STDERR, "\nNOTICE: Can't find extension name for ".$file." files checked: ".join(", ", $files_checked));
    return '_unknow';
}

function array_index_by_col($arr, $col, $overwrite_duplicate = true) {
    $tmp = array();
    foreach ($arr as $i) {
        if (!isset($tmp[$i[$col]]) || $overwrite_duplicate) {
            $tmp[$i[$col]] = $i;
        }
    }
    return $tmp;
}

function vimstring_escape($str) {
    return str_replace("'", "''", $str);
}

function filenameize($str) {
	$clean = preg_replace('/[^a-zA-Z0-9\/_|+ -]/', '', $str);
	$clean = strtolower(trim($clean, '_'));
	$clean = preg_replace('/[\/_|+ -]+/', '_', $clean);

	return $clean;
}
