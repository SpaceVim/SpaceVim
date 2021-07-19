* master
    * A separate setting for the leader key `:help g:vlime_leader`.
    * Use built-in terminal emulators to launch servers `:help g:vlime_cl_use_terminal`.
    * Overlays, and Slimv-like key mappings `:help vlime-mappings-overlays`.
    * Show quick references for Vlime buffers `:help vlime-mappings`.
    * .slime-secret support `:help vlime-slime-secret`.
    * SWANK-MREPL support `:help vlime-mrepl`.
    * Better and customizable auto indent `:help vlime-auto-indent`.

* v0.4.0
    * The trace dialog `:help vlime-trace-dialog`.
    * Colorful special buffers.
    * The AUTODOC feature `:help g:vlime_enable_autodoc`.
    * API documentation `:help vlime-api-intro`.
    * Experimental support for swank-kawa.scm.
    * Provide an option to use an existing Swank server.
    * More precise jumps to source locations
    * Move `vim/plugin/*.vim` to `vim/autoload/vlime/`, for better start-up performance.
    * Top-level API functions are renamed.

* v0.3.0
    * Browse input history in the input buffer `:help vlime-mappings-input`.
    * Provide one-off input mode for top-level APIs.
    * When jumping to source locations (e.g. xref), use existing windows by default. `:help vlime-mappings-xref`
    * Functions and mappings for feeding top-level forms to the server.
    * Better ways to handle conflicting key mappings. `:help vlime-key-conflict`
    * Functions and mappings for listing and closing Vlime windows. `:help vlime-mappings-close-window`
    * Support cusomizing the `ncat` command, and using other `netcat` clones. `:help g:vlime_neovim_connector`

* v0.2.0
    * Multiple enhancements & bug fixes.
    * Neovim support.
    * Going Beta. Yay!
