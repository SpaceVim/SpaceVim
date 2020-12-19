# result of neovim `api_info()`
API_INFO = {
    "version": {
        "major": 0,
        "api_level": 1,
        "api_prerelease": False,
        "patch": 7,
        "api_compatible": 0,
        "minor": 1
    },
    "types": {
        "Window": {
            "id": 1,
            "prefix": "nvim_win_"
        },
        "Tabpage": {
            "id": 2,
            "prefix": "nvim_tabpage_"
        },
        "Buffer": {
            "id": 0,
            "prefix": "nvim_buf_"
        }
    },
    "functions": [
        {
            "method": True,
            "name": "nvim_buf_line_count",
            "return_type": "Integer",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "buffer_get_line",
            "return_type": "String",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "Integer",
                    "index"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "buffer_set_line",
            "return_type": "void",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "Integer",
                    "index"
                ],
                [
                    "String",
                    "line"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "buffer_del_line",
            "return_type": "void",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "Integer",
                    "index"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "buffer_get_line_slice",
            "return_type": "ArrayOf(String)",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "Integer",
                    "start"
                ],
                [
                    "Integer",
                    "end"
                ],
                [
                    "Boolean",
                    "include_start"
                ],
                [
                    "Boolean",
                    "include_end"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "name": "nvim_buf_get_lines",
            "return_type": "ArrayOf(String)",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "Integer",
                    "start"
                ],
                [
                    "Integer",
                    "end"
                ],
                [
                    "Boolean",
                    "strict_indexing"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "buffer_set_line_slice",
            "return_type": "void",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "Integer",
                    "start"
                ],
                [
                    "Integer",
                    "end"
                ],
                [
                    "Boolean",
                    "include_start"
                ],
                [
                    "Boolean",
                    "include_end"
                ],
                [
                    "ArrayOf(String)",
                    "replacement"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "name": "nvim_buf_set_lines",
            "return_type": "void",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "Integer",
                    "start"
                ],
                [
                    "Integer",
                    "end"
                ],
                [
                    "Boolean",
                    "strict_indexing"
                ],
                [
                    "ArrayOf(String)",
                    "replacement"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_buf_get_var",
            "return_type": "Object",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_buf_set_var",
            "return_type": "void",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "String",
                    "name"
                ],
                [
                    "Object",
                    "value"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_buf_del_var",
            "return_type": "void",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "buffer_set_var",
            "return_type": "Object",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "String",
                    "name"
                ],
                [
                    "Object",
                    "value"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "buffer_del_var",
            "return_type": "Object",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "name": "nvim_buf_get_option",
            "return_type": "Object",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_buf_set_option",
            "return_type": "void",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "String",
                    "name"
                ],
                [
                    "Object",
                    "value"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_buf_get_number",
            "return_type": "Integer",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_buf_get_name",
            "return_type": "String",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_buf_set_name",
            "return_type": "void",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_buf_is_valid",
            "return_type": "Boolean",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "buffer_insert",
            "return_type": "void",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "Integer",
                    "lnum"
                ],
                [
                    "ArrayOf(String)",
                    "lines"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "name": "nvim_buf_get_mark",
            "return_type": "ArrayOf(Integer, 2)",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_buf_add_highlight",
            "return_type": "Integer",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "Integer",
                    "src_id"
                ],
                [
                    "String",
                    "hl_group"
                ],
                [
                    "Integer",
                    "line"
                ],
                [
                    "Integer",
                    "col_start"
                ],
                [
                    "Integer",
                    "col_end"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_buf_clear_highlight",
            "return_type": "void",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "Integer",
                    "src_id"
                ],
                [
                    "Integer",
                    "line_start"
                ],
                [
                    "Integer",
                    "line_end"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_tabpage_list_wins",
            "return_type": "ArrayOf(Window)",
            "parameters": [
                [
                    "Tabpage",
                    "tabpage"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_tabpage_get_var",
            "return_type": "Object",
            "parameters": [
                [
                    "Tabpage",
                    "tabpage"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_tabpage_set_var",
            "return_type": "void",
            "parameters": [
                [
                    "Tabpage",
                    "tabpage"
                ],
                [
                    "String",
                    "name"
                ],
                [
                    "Object",
                    "value"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_tabpage_del_var",
            "return_type": "void",
            "parameters": [
                [
                    "Tabpage",
                    "tabpage"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "tabpage_set_var",
            "return_type": "Object",
            "parameters": [
                [
                    "Tabpage",
                    "tabpage"
                ],
                [
                    "String",
                    "name"
                ],
                [
                    "Object",
                    "value"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "tabpage_del_var",
            "return_type": "Object",
            "parameters": [
                [
                    "Tabpage",
                    "tabpage"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "name": "nvim_tabpage_get_win",
            "return_type": "Window",
            "parameters": [
                [
                    "Tabpage",
                    "tabpage"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_tabpage_get_number",
            "return_type": "Integer",
            "parameters": [
                [
                    "Tabpage",
                    "tabpage"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_tabpage_is_valid",
            "return_type": "Boolean",
            "parameters": [
                [
                    "Tabpage",
                    "tabpage"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_ui_attach",
            "return_type": "void",
            "parameters": [
                [
                    "Integer",
                    "width"
                ],
                [
                    "Integer",
                    "height"
                ],
                [
                    "Dictionary",
                    "options"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "ui_attach",
            "return_type": "void",
            "parameters": [
                [
                    "Integer",
                    "width"
                ],
                [
                    "Integer",
                    "height"
                ],
                [
                    "Boolean",
                    "enable_rgb"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "name": "nvim_ui_detach",
            "return_type": "void",
            "parameters": [],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_ui_try_resize",
            "return_type": "void",
            "parameters": [
                [
                    "Integer",
                    "width"
                ],
                [
                    "Integer",
                    "height"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_ui_set_option",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "name"
                ],
                [
                    "Object",
                    "value"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_command",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "command"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_feedkeys",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "keys"
                ],
                [
                    "String",
                    "mode"
                ],
                [
                    "Boolean",
                    "escape_csi"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_input",
            "return_type": "Integer",
            "parameters": [
                [
                    "String",
                    "keys"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_replace_termcodes",
            "return_type": "String",
            "parameters": [
                [
                    "String",
                    "str"
                ],
                [
                    "Boolean",
                    "from_part"
                ],
                [
                    "Boolean",
                    "do_lt"
                ],
                [
                    "Boolean",
                    "special"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_command_output",
            "return_type": "String",
            "parameters": [
                [
                    "String",
                    "str"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_eval",
            "return_type": "Object",
            "parameters": [
                [
                    "String",
                    "expr"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_call_function",
            "return_type": "Object",
            "parameters": [
                [
                    "String",
                    "fname"
                ],
                [
                    "Array",
                    "args"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_strwidth",
            "return_type": "Integer",
            "parameters": [
                [
                    "String",
                    "str"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_list_runtime_paths",
            "return_type": "ArrayOf(String)",
            "parameters": [],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_set_current_dir",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "dir"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_get_current_line",
            "return_type": "String",
            "parameters": [],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_set_current_line",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "line"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_del_current_line",
            "return_type": "void",
            "parameters": [],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_get_var",
            "return_type": "Object",
            "parameters": [
                [
                    "String",
                    "name"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_set_var",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "name"
                ],
                [
                    "Object",
                    "value"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_del_var",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "name"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_set_var",
            "return_type": "Object",
            "parameters": [
                [
                    "String",
                    "name"
                ],
                [
                    "Object",
                    "value"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_del_var",
            "return_type": "Object",
            "parameters": [
                [
                    "String",
                    "name"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "name": "nvim_get_vvar",
            "return_type": "Object",
            "parameters": [
                [
                    "String",
                    "name"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_get_option",
            "return_type": "Object",
            "parameters": [
                [
                    "String",
                    "name"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_set_option",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "name"
                ],
                [
                    "Object",
                    "value"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_out_write",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "str"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_err_write",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "str"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_err_writeln",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "str"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_list_bufs",
            "return_type": "ArrayOf(Buffer)",
            "parameters": [],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_get_current_buf",
            "return_type": "Buffer",
            "parameters": [],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_set_current_buf",
            "return_type": "void",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_list_wins",
            "return_type": "ArrayOf(Window)",
            "parameters": [],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_get_current_win",
            "return_type": "Window",
            "parameters": [],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_set_current_win",
            "return_type": "void",
            "parameters": [
                [
                    "Window",
                    "window"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_list_tabpages",
            "return_type": "ArrayOf(Tabpage)",
            "parameters": [],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_get_current_tabpage",
            "return_type": "Tabpage",
            "parameters": [],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_set_current_tabpage",
            "return_type": "void",
            "parameters": [
                [
                    "Tabpage",
                    "tabpage"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_subscribe",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "event"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_unsubscribe",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "event"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_get_color_by_name",
            "return_type": "Integer",
            "parameters": [
                [
                    "String",
                    "name"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_get_color_map",
            "return_type": "Dictionary",
            "parameters": [],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_get_api_info",
            "return_type": "Array",
            "parameters": [],
            "since": 1
        },
        {
            "method": False,
            "name": "nvim_call_atomic",
            "return_type": "Array",
            "parameters": [
                [
                    "Array",
                    "calls"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_win_get_buf",
            "return_type": "Buffer",
            "parameters": [
                [
                    "Window",
                    "window"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_win_get_cursor",
            "return_type": "ArrayOf(Integer, 2)",
            "parameters": [
                [
                    "Window",
                    "window"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_win_set_cursor",
            "return_type": "void",
            "parameters": [
                [
                    "Window",
                    "window"
                ],
                [
                    "ArrayOf(Integer, 2)",
                    "pos"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_win_get_height",
            "return_type": "Integer",
            "parameters": [
                [
                    "Window",
                    "window"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_win_set_height",
            "return_type": "void",
            "parameters": [
                [
                    "Window",
                    "window"
                ],
                [
                    "Integer",
                    "height"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_win_get_width",
            "return_type": "Integer",
            "parameters": [
                [
                    "Window",
                    "window"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_win_set_width",
            "return_type": "void",
            "parameters": [
                [
                    "Window",
                    "window"
                ],
                [
                    "Integer",
                    "width"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_win_get_var",
            "return_type": "Object",
            "parameters": [
                [
                    "Window",
                    "window"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_win_set_var",
            "return_type": "void",
            "parameters": [
                [
                    "Window",
                    "window"
                ],
                [
                    "String",
                    "name"
                ],
                [
                    "Object",
                    "value"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_win_del_var",
            "return_type": "void",
            "parameters": [
                [
                    "Window",
                    "window"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 1
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "window_set_var",
            "return_type": "Object",
            "parameters": [
                [
                    "Window",
                    "window"
                ],
                [
                    "String",
                    "name"
                ],
                [
                    "Object",
                    "value"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "window_del_var",
            "return_type": "Object",
            "parameters": [
                [
                    "Window",
                    "window"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "name": "nvim_win_get_option",
            "return_type": "Object",
            "parameters": [
                [
                    "Window",
                    "window"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_win_set_option",
            "return_type": "void",
            "parameters": [
                [
                    "Window",
                    "window"
                ],
                [
                    "String",
                    "name"
                ],
                [
                    "Object",
                    "value"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_win_get_position",
            "return_type": "ArrayOf(Integer, 2)",
            "parameters": [
                [
                    "Window",
                    "window"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_win_get_tabpage",
            "return_type": "Tabpage",
            "parameters": [
                [
                    "Window",
                    "window"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_win_get_number",
            "return_type": "Integer",
            "parameters": [
                [
                    "Window",
                    "window"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "name": "nvim_win_is_valid",
            "return_type": "Boolean",
            "parameters": [
                [
                    "Window",
                    "window"
                ]
            ],
            "since": 1
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "buffer_line_count",
            "return_type": "Integer",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "buffer_get_lines",
            "return_type": "ArrayOf(String)",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "Integer",
                    "start"
                ],
                [
                    "Integer",
                    "end"
                ],
                [
                    "Boolean",
                    "strict_indexing"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "buffer_set_lines",
            "return_type": "void",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "Integer",
                    "start"
                ],
                [
                    "Integer",
                    "end"
                ],
                [
                    "Boolean",
                    "strict_indexing"
                ],
                [
                    "ArrayOf(String)",
                    "replacement"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "buffer_get_var",
            "return_type": "Object",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "buffer_get_option",
            "return_type": "Object",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "buffer_set_option",
            "return_type": "void",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "String",
                    "name"
                ],
                [
                    "Object",
                    "value"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "buffer_get_number",
            "return_type": "Integer",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "buffer_get_name",
            "return_type": "String",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "buffer_set_name",
            "return_type": "void",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "buffer_is_valid",
            "return_type": "Boolean",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "buffer_get_mark",
            "return_type": "ArrayOf(Integer, 2)",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "buffer_add_highlight",
            "return_type": "Integer",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "Integer",
                    "src_id"
                ],
                [
                    "String",
                    "hl_group"
                ],
                [
                    "Integer",
                    "line"
                ],
                [
                    "Integer",
                    "col_start"
                ],
                [
                    "Integer",
                    "col_end"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "buffer_clear_highlight",
            "return_type": "void",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ],
                [
                    "Integer",
                    "src_id"
                ],
                [
                    "Integer",
                    "line_start"
                ],
                [
                    "Integer",
                    "line_end"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "tabpage_get_windows",
            "return_type": "ArrayOf(Window)",
            "parameters": [
                [
                    "Tabpage",
                    "tabpage"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "tabpage_get_var",
            "return_type": "Object",
            "parameters": [
                [
                    "Tabpage",
                    "tabpage"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "tabpage_get_window",
            "return_type": "Window",
            "parameters": [
                [
                    "Tabpage",
                    "tabpage"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "tabpage_is_valid",
            "return_type": "Boolean",
            "parameters": [
                [
                    "Tabpage",
                    "tabpage"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "ui_detach",
            "return_type": "void",
            "parameters": [],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "ui_try_resize",
            "return_type": "Object",
            "parameters": [
                [
                    "Integer",
                    "width"
                ],
                [
                    "Integer",
                    "height"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_command",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "command"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_feedkeys",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "keys"
                ],
                [
                    "String",
                    "mode"
                ],
                [
                    "Boolean",
                    "escape_csi"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_input",
            "return_type": "Integer",
            "parameters": [
                [
                    "String",
                    "keys"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_replace_termcodes",
            "return_type": "String",
            "parameters": [
                [
                    "String",
                    "str"
                ],
                [
                    "Boolean",
                    "from_part"
                ],
                [
                    "Boolean",
                    "do_lt"
                ],
                [
                    "Boolean",
                    "special"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_command_output",
            "return_type": "String",
            "parameters": [
                [
                    "String",
                    "str"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_eval",
            "return_type": "Object",
            "parameters": [
                [
                    "String",
                    "expr"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_call_function",
            "return_type": "Object",
            "parameters": [
                [
                    "String",
                    "fname"
                ],
                [
                    "Array",
                    "args"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_strwidth",
            "return_type": "Integer",
            "parameters": [
                [
                    "String",
                    "str"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_list_runtime_paths",
            "return_type": "ArrayOf(String)",
            "parameters": [],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_change_directory",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "dir"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_get_current_line",
            "return_type": "String",
            "parameters": [],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_set_current_line",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "line"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_del_current_line",
            "return_type": "void",
            "parameters": [],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_get_var",
            "return_type": "Object",
            "parameters": [
                [
                    "String",
                    "name"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_get_vvar",
            "return_type": "Object",
            "parameters": [
                [
                    "String",
                    "name"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_get_option",
            "return_type": "Object",
            "parameters": [
                [
                    "String",
                    "name"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_set_option",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "name"
                ],
                [
                    "Object",
                    "value"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_out_write",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "str"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_err_write",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "str"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_report_error",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "str"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_get_buffers",
            "return_type": "ArrayOf(Buffer)",
            "parameters": [],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_get_current_buffer",
            "return_type": "Buffer",
            "parameters": [],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_set_current_buffer",
            "return_type": "void",
            "parameters": [
                [
                    "Buffer",
                    "buffer"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_get_windows",
            "return_type": "ArrayOf(Window)",
            "parameters": [],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_get_current_window",
            "return_type": "Window",
            "parameters": [],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_set_current_window",
            "return_type": "void",
            "parameters": [
                [
                    "Window",
                    "window"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_get_tabpages",
            "return_type": "ArrayOf(Tabpage)",
            "parameters": [],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_get_current_tabpage",
            "return_type": "Tabpage",
            "parameters": [],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_set_current_tabpage",
            "return_type": "void",
            "parameters": [
                [
                    "Tabpage",
                    "tabpage"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_subscribe",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "event"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_unsubscribe",
            "return_type": "void",
            "parameters": [
                [
                    "String",
                    "event"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_name_to_color",
            "return_type": "Integer",
            "parameters": [
                [
                    "String",
                    "name"
                ]
            ],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_get_color_map",
            "return_type": "Dictionary",
            "parameters": [],
            "since": 0
        },
        {
            "method": False,
            "deprecated_since": 1,
            "name": "vim_get_api_info",
            "return_type": "Array",
            "parameters": [],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "window_get_buffer",
            "return_type": "Buffer",
            "parameters": [
                [
                    "Window",
                    "window"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "window_get_cursor",
            "return_type": "ArrayOf(Integer, 2)",
            "parameters": [
                [
                    "Window",
                    "window"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "window_set_cursor",
            "return_type": "void",
            "parameters": [
                [
                    "Window",
                    "window"
                ],
                [
                    "ArrayOf(Integer, 2)",
                    "pos"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "window_get_height",
            "return_type": "Integer",
            "parameters": [
                [
                    "Window",
                    "window"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "window_set_height",
            "return_type": "void",
            "parameters": [
                [
                    "Window",
                    "window"
                ],
                [
                    "Integer",
                    "height"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "window_get_width",
            "return_type": "Integer",
            "parameters": [
                [
                    "Window",
                    "window"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "window_set_width",
            "return_type": "void",
            "parameters": [
                [
                    "Window",
                    "window"
                ],
                [
                    "Integer",
                    "width"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "window_get_var",
            "return_type": "Object",
            "parameters": [
                [
                    "Window",
                    "window"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "window_get_option",
            "return_type": "Object",
            "parameters": [
                [
                    "Window",
                    "window"
                ],
                [
                    "String",
                    "name"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "window_set_option",
            "return_type": "void",
            "parameters": [
                [
                    "Window",
                    "window"
                ],
                [
                    "String",
                    "name"
                ],
                [
                    "Object",
                    "value"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "window_get_position",
            "return_type": "ArrayOf(Integer, 2)",
            "parameters": [
                [
                    "Window",
                    "window"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "window_get_tabpage",
            "return_type": "Tabpage",
            "parameters": [
                [
                    "Window",
                    "window"
                ]
            ],
            "since": 0
        },
        {
            "method": True,
            "deprecated_since": 1,
            "name": "window_is_valid",
            "return_type": "Boolean",
            "parameters": [
                [
                    "Window",
                    "window"
                ]
            ],
            "since": 0
        }
    ],
    "error_types": {
        "Validation": {
            "id": 1
        },
        "Exception": {
            "id": 0
        }
    }
}
