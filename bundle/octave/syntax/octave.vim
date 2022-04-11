" Vim syntax file
" Language:             Octave
" Maintainer:           Rik <rik@octave.org>
" Original Maintainers: Jaroslav Hajek <highegg@gmail.com>
"                       Francisco Castro <fcr@adinet.com.uy>
"                       Preben 'Peppe' Guldberg <peppe-vim@wielders.org>
" Original Author: Mario Eusebio
" Last Change: 19 Sep 2021
" Syntax matched to Octave Release: 6.3.0
" Add runtime configuration variables octave_highlight_operators,
" octave_highlight_variables, octave_highlight_tabs.
" Fix highlighting of classdef keywords which are also functions.
" Fix highlighting of complex numbers with capital I,J.
" Fix highlighting of user variables.
" Avoid changing vim variable "iskeyword" and regexp matching for local buffer.
" Performance improvements in regular expressions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Use case sensitive matching of keywords
syn case match

" Set iskeyword to guarantee portability
syntax iskeyword @,48-57,_,192-255

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax group definitions for Octave

" List of Octave keywords
syn keyword octaveBeginKeyword  if switch for parfor while do function classdef
syn keyword octaveBeginKeyword  try unwind_protect 

syn keyword octaveElseKeyword   else elseif catch unwind_protect_cleanup

syn keyword octaveEndKeyword    end endif endswitch endfor endparfor endwhile
syn keyword octaveEndKeyword    until endfunction endclassdef end_try_catch
syn keyword octaveEndKeyword    end_unwind_protect 
syn keyword octaveEndKeyword    endenumeration endevents endmethods
syn keyword octaveEndKeyword    endproperties

syn keyword octaveLabel         case otherwise

syn keyword octaveStatement     break continue global persistent return

syn keyword octaveVarKeyword    varargin varargout

syn keyword octaveReserved      __FILE__ __LINE__

" Use 'match', rather than 'keyword', because highlighting color depends on
" context and Vim 'keyword' cannot be overriden.
syn match octaveOOKeyword  "^\s*\%(enumeration\|events\|methods\|properties\)\>"

" List of commands (these don't require a parenthesis to invoke)
syn keyword octaveCommand contained  cd chdir clear clearvars close dbcont
syn keyword octaveCommand contained  dbquit dbstep demo diary doc echo edit
syn keyword octaveCommand contained  edit_history example format help history
syn keyword octaveCommand contained  hold ishold load lookfor ls mkoctfile
syn keyword octaveCommand contained  more pkg run run_history save shg test
syn keyword octaveCommand contained  type what which who whos 

" List of functions which can be called in some other manner:
" As a command OR as a read-only access of internal variables OR as functions.

" List of functions also used as commands
syn keyword octaveSetFcn contained  cd chdir clear clearvars close dbcont
syn keyword octaveSetFcn contained  dbquit dbstep demo diary doc echo edit
syn keyword octaveSetFcn contained  edit_history example format help history
syn keyword octaveSetFcn contained  hold ishold load lookfor ls mkoctfile
syn keyword octaveSetFcn contained  more pkg run run_history save shg test
syn keyword octaveSetFcn contained  type what which who whos 
" List of functions which initialize internal variables
syn keyword octaveSetFcn contained  EDITOR EXEC_PATH I IMAGE_PATH Inf J NA
syn keyword octaveSetFcn contained  NaN PAGER PAGER_FLAGS PS1 PS2 PS4 ans
syn keyword octaveSetFcn contained  auto_repeat_debug_command beep_on_error
syn keyword octaveSetFcn contained  built_in_docstrings_file
syn keyword octaveSetFcn contained  completion_append_char
syn keyword octaveSetFcn contained  confirm_recursive_rmdir
syn keyword octaveSetFcn contained  crash_dumps_octave_core debug_java
syn keyword octaveSetFcn contained  debug_jit debug_on_error
syn keyword octaveSetFcn contained  debug_on_interrupt debug_on_warning
syn keyword octaveSetFcn contained  disable_diagonal_matrix
syn keyword octaveSetFcn contained  disable_permutation_matrix disable_range
syn keyword octaveSetFcn contained  doc_cache_file e eps false
syn keyword octaveSetFcn contained  fixed_point_format gnuplot_binary
syn keyword octaveSetFcn contained  graphics_toolkit history history_control
syn keyword octaveSetFcn contained  history_file history_save history_size
syn keyword octaveSetFcn contained  history_timestamp_format_string i
syn keyword octaveSetFcn contained  ignore_function_time_stamp inf info_file
syn keyword octaveSetFcn contained  info_program j java_matrix_autoconversion
syn keyword octaveSetFcn contained  java_unsigned_autoconversion jit_enable
syn keyword octaveSetFcn contained  jit_failcnt jit_startcnt ls_command
syn keyword octaveSetFcn contained  makeinfo_program max_recursion_depth
syn keyword octaveSetFcn contained  max_stack_depth missing_component_hook
syn keyword octaveSetFcn contained  missing_function_hook nan nargin nargout
syn keyword octaveSetFcn contained  octave_core_file_limit
syn keyword octaveSetFcn contained  octave_core_file_name
syn keyword octaveSetFcn contained  octave_core_file_options
syn keyword octaveSetFcn contained  optimize_subsasgn_calls
syn keyword octaveSetFcn contained  output_max_field_width output_precision
syn keyword octaveSetFcn contained  page_output_immediately
syn keyword octaveSetFcn contained  page_screen_output path pi prefdir
syn keyword octaveSetFcn contained  print_empty_dimensions
syn keyword octaveSetFcn contained  print_struct_array_contents realmax
syn keyword octaveSetFcn contained  realmin save_default_options
syn keyword octaveSetFcn contained  save_header_format_string save_precision
syn keyword octaveSetFcn contained  sighup_dumps_octave_core
syn keyword octaveSetFcn contained  sigquit_dumps_octave_core
syn keyword octaveSetFcn contained  sigterm_dumps_octave_core
syn keyword octaveSetFcn contained  silent_functions sparse_auto_mutate
syn keyword octaveSetFcn contained  split_long_rows string_fill_char
syn keyword octaveSetFcn contained  struct_levels_to_print
syn keyword octaveSetFcn contained  suppress_verbose_help_message svd_driver
syn keyword octaveSetFcn contained  texi_macros_file true whos_line_format

" List of functions which get internal variables
syn keyword octaveGetFcn contained  EDITOR EXEC_PATH I IMAGE_PATH Inf J NA
syn keyword octaveGetFcn contained  NaN PAGER PAGER_FLAGS PS1 PS2 PS4 ans
syn keyword octaveGetFcn contained  auto_repeat_debug_command beep_on_error
syn keyword octaveGetFcn contained  built_in_docstrings_file
syn keyword octaveGetFcn contained  completion_append_char
syn keyword octaveGetFcn contained  confirm_recursive_rmdir
syn keyword octaveGetFcn contained  crash_dumps_octave_core debug_java
syn keyword octaveGetFcn contained  debug_jit debug_on_error
syn keyword octaveGetFcn contained  debug_on_interrupt debug_on_warning
syn keyword octaveGetFcn contained  disable_diagonal_matrix
syn keyword octaveGetFcn contained  disable_permutation_matrix disable_range
syn keyword octaveGetFcn contained  doc_cache_file e eps false
syn keyword octaveGetFcn contained  fixed_point_format gnuplot_binary
syn keyword octaveGetFcn contained  graphics_toolkit history history_control
syn keyword octaveGetFcn contained  history_file history_save history_size
syn keyword octaveGetFcn contained  history_timestamp_format_string i
syn keyword octaveGetFcn contained  ignore_function_time_stamp inf info_file
syn keyword octaveGetFcn contained  info_program j java_matrix_autoconversion
syn keyword octaveGetFcn contained  java_unsigned_autoconversion jit_enable
syn keyword octaveGetFcn contained  jit_failcnt jit_startcnt ls_command
syn keyword octaveGetFcn contained  makeinfo_program max_recursion_depth
syn keyword octaveGetFcn contained  max_stack_depth missing_component_hook
syn keyword octaveGetFcn contained  missing_function_hook nan nargin nargout
syn keyword octaveGetFcn contained  octave_core_file_limit
syn keyword octaveGetFcn contained  octave_core_file_name
syn keyword octaveGetFcn contained  octave_core_file_options
syn keyword octaveGetFcn contained  optimize_subsasgn_calls
syn keyword octaveGetFcn contained  output_max_field_width output_precision
syn keyword octaveGetFcn contained  page_output_immediately
syn keyword octaveGetFcn contained  page_screen_output path pi prefdir
syn keyword octaveGetFcn contained  print_empty_dimensions
syn keyword octaveGetFcn contained  print_struct_array_contents realmax
syn keyword octaveGetFcn contained  realmin save_default_options
syn keyword octaveGetFcn contained  save_header_format_string save_precision
syn keyword octaveGetFcn contained  sighup_dumps_octave_core
syn keyword octaveGetFcn contained  sigquit_dumps_octave_core
syn keyword octaveGetFcn contained  sigterm_dumps_octave_core
syn keyword octaveGetFcn contained  silent_functions sparse_auto_mutate
syn keyword octaveGetFcn contained  split_long_rows string_fill_char
syn keyword octaveGetFcn contained  struct_levels_to_print
syn keyword octaveGetFcn contained  suppress_verbose_help_message svd_driver
syn keyword octaveGetFcn contained  texi_macros_file true whos_line_format

" List of Read-Only variables
syn keyword octaveROFcn  F_DUPFD F_GETFD F_GETFL F_SETFD F_SETFL
syn keyword octaveROFcn  OCTAVE_EXEC_HOME OCTAVE_HOME OCTAVE_VERSION O_APPEND
syn keyword octaveROFcn  O_ASYNC O_CREAT O_EXCL O_NONBLOCK O_RDONLY O_RDWR
syn keyword octaveROFcn  O_SYNC O_TRUNC O_WRONLY P_tmpdir SEEK_CUR SEEK_END
syn keyword octaveROFcn  SEEK_SET SIG WCONTINUE WCOREDUMP WEXITSTATUS
syn keyword octaveROFcn  WIFCONTINUED WIFEXITED WIFSIGNALED WIFSTOPPED WNOHANG
syn keyword octaveROFcn  WSTOPSIG WTERMSIG WUNTRACED argv
syn keyword octaveROFcn  available_graphics_toolkits command_line_path groot
syn keyword octaveROFcn  have_window_system isieee isstudent
syn keyword octaveROFcn  loaded_graphics_toolkits matlabroot namelengthmax
syn keyword octaveROFcn  native_float_format pathsep program_invocation_name
syn keyword octaveROFcn  program_name pwd sizemax stderr stdin stdout tempdir 

" List of ordinary functions not in one of the other categories
syn keyword octaveFunction contained  S_ISBLK S_ISCHR S_ISDIR S_ISFIFO S_ISLNK
syn keyword octaveFunction contained  S_ISREG S_ISSOCK abs accumarray accumdim
syn keyword octaveFunction contained  acos acosd acosh acot acotd acoth acsc
syn keyword octaveFunction contained  acscd acsch add_input_event_hook
syn keyword octaveFunction contained  addlistener addpath addpref addproperty
syn keyword octaveFunction contained  addtodate airy all allchild amd ancestor
syn keyword octaveFunction contained  and angle annotation any arch_fit
syn keyword octaveFunction contained  arch_rnd arch_test area arg arma_rnd
syn keyword octaveFunction contained  arrayfun asctime asec asecd asech asin
syn keyword octaveFunction contained  asind asinh assert assignin atan atan2
syn keyword octaveFunction contained  atan2d atand atanh atexit audiodevinfo
syn keyword octaveFunction contained  audioformats audioinfo audioread
syn keyword octaveFunction contained  audiowrite autoload autoreg_matrix autumn
syn keyword octaveFunction contained  axes axis balance bandwidth bar barh
syn keyword octaveFunction contained  bartlett base2dec base64_decode
syn keyword octaveFunction contained  base64_encode beep bessel besselh besseli
syn keyword octaveFunction contained  besselj besselk bessely beta betainc
syn keyword octaveFunction contained  betaincinv betaln bicg bicgstab bin2dec
syn keyword octaveFunction contained  bincoeff bitand bitcmp bitget bitor
syn keyword octaveFunction contained  bitpack bitset bitshift bitunpack bitxor
syn keyword octaveFunction contained  blackman blanks blkdiag blkmm bone bounds
syn keyword octaveFunction contained  box brighten bsxfun bug_report builtin
syn keyword octaveFunction contained  bunzip2 bzip2 calendar camlight camlookat
syn keyword octaveFunction contained  camorbit campos camroll camtarget camup
syn keyword octaveFunction contained  camva camzoom canonicalize_file_name
syn keyword octaveFunction contained  cart2pol cart2sph cast cat caxis cbrt
syn keyword octaveFunction contained  ccolamd ceil cell cell2mat cell2struct
syn keyword octaveFunction contained  celldisp cellfun cellindexmat cellslices
syn keyword octaveFunction contained  cellstr center cgs char chol chol2inv
syn keyword octaveFunction contained  choldelete cholinsert cholinv cholshift
syn keyword octaveFunction contained  cholupdate circshift citation cla clabel
syn keyword octaveFunction contained  class clc clf clock closereq cmpermute
syn keyword octaveFunction contained  cmunique colamd colloc colon colorbar
syn keyword octaveFunction contained  colorcube colormap colperm colstyle
syn keyword octaveFunction contained  columns comet comet3 commandhistory
syn keyword octaveFunction contained  commandwindow common_size
syn keyword octaveFunction contained  commutation_matrix compan
syn keyword octaveFunction contained  compare_versions compass
syn keyword octaveFunction contained  completion_matches complex computer cond
syn keyword octaveFunction contained  condeig condest conj contour contour3
syn keyword octaveFunction contained  contourc contourf contrast conv conv2
syn keyword octaveFunction contained  convhull convhulln convn cool copper
syn keyword octaveFunction contained  copyfile copyobj corr corrcoef cos cosd
syn keyword octaveFunction contained  cosh cosint cot cotd coth cov cplxpair
syn keyword octaveFunction contained  cputime cross csc cscd csch cstrcat
syn keyword octaveFunction contained  csvread csvwrite csymamd ctime ctranspose
syn keyword octaveFunction contained  cubehelix cummax cummin cumprod cumsum
syn keyword octaveFunction contained  cumtrapz curl cylinder daspect daspk
syn keyword octaveFunction contained  daspk_options dasrt dasrt_options dassl
syn keyword octaveFunction contained  dassl_options date datenum datestr
syn keyword octaveFunction contained  datetick datevec dawson dbclear dbdown
syn keyword octaveFunction contained  dblist dblquad dbnext dbstack dbstatus
syn keyword octaveFunction contained  dbstop dbtype dbup dbwhere deal deblank
syn keyword octaveFunction contained  dec2base dec2bin dec2hex decic deconv
syn keyword octaveFunction contained  deg2rad del2 delaunay delaunayn delete
syn keyword octaveFunction contained  dellistener det detrend diag dialog diff
syn keyword octaveFunction contained  diffpara diffuse dir dir_in_loadpath
syn keyword octaveFunction contained  discrete_cdf discrete_inv discrete_pdf
syn keyword octaveFunction contained  discrete_rnd disp display divergence
syn keyword octaveFunction contained  dlmread dlmwrite dmperm do_string_escapes
syn keyword octaveFunction contained  doc_cache_create dos dot double drawnow
syn keyword octaveFunction contained  dsearch dsearchn dup2 duplication_matrix
syn keyword octaveFunction contained  durbinlevinson eig eigs ellipj ellipke
syn keyword octaveFunction contained  ellipsoid empirical_cdf empirical_inv
syn keyword octaveFunction contained  empirical_pdf empirical_rnd endgrent
syn keyword octaveFunction contained  endpwent eomday eq erase erf erfc erfcinv
syn keyword octaveFunction contained  erfcx erfi erfinv errno errno_list error
syn keyword octaveFunction contained  error_ids errorbar errordlg etime etree
syn keyword octaveFunction contained  etreeplot eval evalc evalin exec exist
syn keyword octaveFunction contained  exit exp expint expm expm1 eye ezcontour
syn keyword octaveFunction contained  ezcontourf ezmesh ezmeshc ezplot ezplot3
syn keyword octaveFunction contained  ezpolar ezsurf ezsurfc factor factorial
syn keyword octaveFunction contained  fail fclear fclose fcntl fdisp feather
syn keyword octaveFunction contained  feof ferror feval fflush fft fft2 fftconv
syn keyword octaveFunction contained  fftfilt fftn fftshift fftw fgetl fgets
syn keyword octaveFunction contained  fieldnames figure file_in_loadpath
syn keyword octaveFunction contained  file_in_path fileattrib filebrowser
syn keyword octaveFunction contained  fileparts fileread filesep fill filter
syn keyword octaveFunction contained  filter2 find findall findfigs findobj
syn keyword octaveFunction contained  findstr fix flag flintmax flip flipdim
syn keyword octaveFunction contained  fliplr flipud floor fminbnd fminsearch
syn keyword octaveFunction contained  fminunc fopen fork fplot fprintf fputs
syn keyword octaveFunction contained  fractdiff frame2im fread freport freqz
syn keyword octaveFunction contained  freqz_plot frewind fscanf fseek fskipl
syn keyword octaveFunction contained  fsolve ftell full fullfile func2str
syn keyword octaveFunction contained  functions fwrite fzero gallery gamma
syn keyword octaveFunction contained  gammainc gammaincinv gammaln gca gcbf
syn keyword octaveFunction contained  gcbo gcd gcf gco ge genpath genvarname
syn keyword octaveFunction contained  get get_first_help_sentence get_help_text
syn keyword octaveFunction contained  get_help_text_from_file
syn keyword octaveFunction contained  get_home_directory getappdata getegid
syn keyword octaveFunction contained  getenv geteuid getfield getframe getgid
syn keyword octaveFunction contained  getgrent getgrgid getgrnam gethostname
syn keyword octaveFunction contained  getpgrp getpid getppid getpref getpwent
syn keyword octaveFunction contained  getpwnam getpwuid getrusage getuid ginput
syn keyword octaveFunction contained  givens glob glpk gls gmres gmtime gplot
syn keyword octaveFunction contained  grabcode gradient gray gray2ind grid
syn keyword octaveFunction contained  griddata griddata3 griddatan gsvd gt
syn keyword octaveFunction contained  gtext gui_mainfcn guidata guihandles
syn keyword octaveFunction contained  gunzip gzip hadamard hamming hankel
syn keyword octaveFunction contained  hanning hash hdl2struct helpdlg hess
syn keyword octaveFunction contained  hex2dec hex2num hggroup hgload hgsave
syn keyword octaveFunction contained  hgtransform hidden hilb hist histc home
syn keyword octaveFunction contained  horzcat hot housh hsv hsv2rgb humps hurst
syn keyword octaveFunction contained  hypot ichol idivide ifelse ifft ifft2
syn keyword octaveFunction contained  ifftn ifftshift ilu im2double im2frame
syn keyword octaveFunction contained  imag image imagesc imfinfo imformats
syn keyword octaveFunction contained  import importdata imread imshow imwrite
syn keyword octaveFunction contained  ind2gray ind2rgb ind2sub index inferiorto
syn keyword octaveFunction contained  info inpolygon input inputParser inputdlg
syn keyword octaveFunction contained  inputname int16 int2str int32 int64 int8
syn keyword octaveFunction contained  integral integral2 integral3 interp1
syn keyword octaveFunction contained  interp2 interp3 interpft interpn
syn keyword octaveFunction contained  intersect intmax intmin inv inverse
syn keyword octaveFunction contained  invhilb ipermute iqr is_absolute_filename
syn keyword octaveFunction contained  is_dq_string is_function_handle
syn keyword octaveFunction contained  is_leap_year is_rooted_relative_filename
syn keyword octaveFunction contained  is_same_file is_sq_string
syn keyword octaveFunction contained  is_valid_file_id isa isalnum isalpha
syn keyword octaveFunction contained  isappdata isargout isascii isaxes
syn keyword octaveFunction contained  isbanded isbool iscell iscellstr ischar
syn keyword octaveFunction contained  iscntrl iscolormap iscolumn iscomplex
syn keyword octaveFunction contained  isdebugmode isdefinite isdeployed isdiag
syn keyword octaveFunction contained  isdigit isdir isempty isequal isequaln
syn keyword octaveFunction contained  isequalwithequalnans isfield isfigure
syn keyword octaveFunction contained  isfile isfinite isfloat isfolder isglobal
syn keyword octaveFunction contained  isgraph isgraphics isguirunning ishandle
syn keyword octaveFunction contained  ishermitian ishghandle isindex isinf
syn keyword octaveFunction contained  isinteger isjava iskeyword isletter
syn keyword octaveFunction contained  islogical islower ismac ismatrix ismember
syn keyword octaveFunction contained  ismethod isna isnan isnull isnumeric
syn keyword octaveFunction contained  isobject isocaps isocolors isonormals
syn keyword octaveFunction contained  isosurface ispc ispref isprime isprint
syn keyword octaveFunction contained  isprop ispunct isreal isrow isscalar
syn keyword octaveFunction contained  issorted isspace issparse issquare isstr
syn keyword octaveFunction contained  isstring isstrprop isstruct issymmetric
syn keyword octaveFunction contained  istril istriu isunix isupper isvarname
syn keyword octaveFunction contained  isvector isxdigit javaArray javaMethod
syn keyword octaveFunction contained  javaObject java_get java_set javaaddpath
syn keyword octaveFunction contained  javachk javaclasspath javamem javarmpath
syn keyword octaveFunction contained  jet kbhit kendall keyboard kill kron
syn keyword octaveFunction contained  krylov kurtosis lasterr lasterror
syn keyword octaveFunction contained  lastwarn lcm ldivide le legend legendre
syn keyword octaveFunction contained  length lgamma license light lightangle
syn keyword octaveFunction contained  lighting lin2mu line lines link linkaxes
syn keyword octaveFunction contained  linkprop linsolve linspace
syn keyword octaveFunction contained  list_in_columns list_primes listdlg
syn keyword octaveFunction contained  loadobj localfunctions localtime log
syn keyword octaveFunction contained  log10 log1p log2 logical loglog loglogerr
syn keyword octaveFunction contained  logm logspace lookup lower lscov lsode
syn keyword octaveFunction contained  lsode_options lsqnonneg lstat lt lu
syn keyword octaveFunction contained  luupdate mad magic make_absolute_filename
syn keyword octaveFunction contained  mat2cell mat2str material matrix_type max
syn keyword octaveFunction contained  mean meansq median menu merge mesh meshc
syn keyword octaveFunction contained  meshgrid meshz metaclass mex mexext
syn keyword octaveFunction contained  mfilename mgorth min minus mislocked
syn keyword octaveFunction contained  mkdir mkfifo mkpp mkstemp mktime mldivide
syn keyword octaveFunction contained  mlock mod mode moment movefile movegui
syn keyword octaveFunction contained  movfun movie movmad movmax movmean
syn keyword octaveFunction contained  movmedian movmin movprod movslice movstd
syn keyword octaveFunction contained  movsum movvar mpoles mpower mrdivide
syn keyword octaveFunction contained  msgbox mtimes mu2lin munlock mustBeFinite
syn keyword octaveFunction contained  mustBeGreaterThan
syn keyword octaveFunction contained  mustBeGreaterThanOrEqual mustBeInteger
syn keyword octaveFunction contained  mustBeLessThan mustBeLessThanOrEqual
syn keyword octaveFunction contained  mustBeMember mustBeNegative mustBeNonNan
syn keyword octaveFunction contained  mustBeNonempty mustBeNonnegative
syn keyword octaveFunction contained  mustBeNonpositive mustBeNonsparse
syn keyword octaveFunction contained  mustBeNonzero mustBeNumeric
syn keyword octaveFunction contained  mustBeNumericOrLogical mustBePositive
syn keyword octaveFunction contained  mustBeReal namedargs2cell nargchk
syn keyword octaveFunction contained  narginchk nargoutchk native2unicode
syn keyword octaveFunction contained  nchoosek ndgrid ndims ne newline newplot
syn keyword octaveFunction contained  news nextpow2 nnz nonzeros norm normest
syn keyword octaveFunction contained  normest1 not now nproc nth_element
syn keyword octaveFunction contained  nthargout nthroot null num2cell num2hex
syn keyword octaveFunction contained  num2str numel numfields nzmax ocean
syn keyword octaveFunction contained  ode15i ode15s ode23 ode23s ode45 odeget
syn keyword octaveFunction contained  odeplot odeset ols onCleanup ones open
syn keyword octaveFunction contained  openfig openvar optimget optimset or
syn keyword octaveFunction contained  ordeig orderfields ordschur orient orth
syn keyword octaveFunction contained  oruntests ostreamtube ostrsplit pack
syn keyword octaveFunction contained  padecoef pan pareto parseparams pascal
syn keyword octaveFunction contained  patch pathdef pause pbaspect pcg pchip
syn keyword octaveFunction contained  pclose pcolor pcr peaks periodogram perl
syn keyword octaveFunction contained  perms permute pie pie3 pink pinv pipe
syn keyword octaveFunction contained  planerot plot plot3 plotmatrix plotyy
syn keyword octaveFunction contained  plus pol2cart polar poly polyaffine
syn keyword octaveFunction contained  polyarea polyder polyeig polyfit polygcd
syn keyword octaveFunction contained  polyint polyout polyreduce polyval
syn keyword octaveFunction contained  polyvalm popen popen2 postpad pow2 power
syn keyword octaveFunction contained  powerset ppder ppint ppjumps ppval
syn keyword octaveFunction contained  pqpnonneg prctile preferences prepad
syn keyword octaveFunction contained  primes print print_usage printd printf
syn keyword octaveFunction contained  prism prod profexplore profexport profile
syn keyword octaveFunction contained  profshow psi publish putenv puts python
syn keyword octaveFunction contained  qmr qp qr qrdelete qrinsert qrshift
syn keyword octaveFunction contained  qrupdate quad quad2d quad_options quadcc
syn keyword octaveFunction contained  quadgk quadl quadv quantile questdlg quit
syn keyword octaveFunction contained  quiver quiver3 qz qzhess rad2deg rainbow
syn keyword octaveFunction contained  rand rande randg randi randn randp
syn keyword octaveFunction contained  randperm range rank ranks rat rats rcond
syn keyword octaveFunction contained  rdivide readdir
syn keyword octaveFunction contained  readline_re_read_init_file
syn keyword octaveFunction contained  readline_read_init_file readlink real
syn keyword octaveFunction contained  reallog realpow realsqrt record rectangle
syn keyword octaveFunction contained  rectint recycle reducepatch reducevolume
syn keyword octaveFunction contained  refresh refreshdata regexp regexpi
syn keyword octaveFunction contained  regexprep regexptranslate
syn keyword octaveFunction contained  register_graphics_toolkit rehash rem
syn keyword octaveFunction contained  remove_input_event_hook rename repelem
syn keyword octaveFunction contained  repelems repmat rescale reset reshape
syn keyword octaveFunction contained  residue resize restoredefaultpath rethrow
syn keyword octaveFunction contained  rgb2gray rgb2hsv rgb2ind rgbplot ribbon
syn keyword octaveFunction contained  rindex rmappdata rmdir rmfield rmpath
syn keyword octaveFunction contained  rmpref roots rose rosser rot90 rotate
syn keyword octaveFunction contained  rotate3d rotdim rotx roty rotz round
syn keyword octaveFunction contained  roundb rows rref rsf2csf rticks run_count
syn keyword octaveFunction contained  rundemos runlength runtests saveas
syn keyword octaveFunction contained  savefig saveobj savepath scanf scatter
syn keyword octaveFunction contained  scatter3 schur sec secd sech semilogx
syn keyword octaveFunction contained  semilogxerr semilogy semilogyerr set
syn keyword octaveFunction contained  setappdata setdiff setenv setfield
syn keyword octaveFunction contained  setgrent setpref setpwent setstr setxor
syn keyword octaveFunction contained  shading shift shiftdim shrinkfaces sign
syn keyword octaveFunction contained  signbit sin sinc sind sinetone sinewave
syn keyword octaveFunction contained  single sinh sinint size size_equal sizeof
syn keyword octaveFunction contained  skewness slice smooth3 sombrero sort
syn keyword octaveFunction contained  sortrows sound soundsc source spalloc
syn keyword octaveFunction contained  sparse spaugment spconvert spdiags
syn keyword octaveFunction contained  spearman spectral_adf spectral_xdf
syn keyword octaveFunction contained  specular speed spencer speye spfun
syn keyword octaveFunction contained  sph2cart sphere spinmap spline splinefit
syn keyword octaveFunction contained  spones spparms sprand sprandn sprandsym
syn keyword octaveFunction contained  sprank spring sprintf spstats spy sqp
syn keyword octaveFunction contained  sqrt sqrtm squeeze sscanf stairs stat
syn keyword octaveFunction contained  statistics std stem stem3 stemleaf stft
syn keyword octaveFunction contained  str2double str2func str2num strcat strchr
syn keyword octaveFunction contained  strcmp strcmpi stream2 stream3 streamline
syn keyword octaveFunction contained  streamtube strfind strftime strjoin
syn keyword octaveFunction contained  strjust strmatch strncmp strncmpi
syn keyword octaveFunction contained  strptime strread strrep strsplit strtok
syn keyword octaveFunction contained  strtrim strtrunc struct struct2cell
syn keyword octaveFunction contained  struct2hdl structfun strvcat sub2ind
syn keyword octaveFunction contained  subplot subsasgn subsindex subspace
syn keyword octaveFunction contained  subsref substr substruct sum summer sumsq
syn keyword octaveFunction contained  superiorto surf surface surfc surfl
syn keyword octaveFunction contained  surfnorm svd svds swapbytes sylvester
syn keyword octaveFunction contained  symamd symbfact symlink symrcm symvar
syn keyword octaveFunction contained  synthesis system tan tand tanh tar
syn keyword octaveFunction contained  tempname terminal_size tetramesh text
syn keyword octaveFunction contained  textread textscan tfqmr thetaticks tic
syn keyword octaveFunction contained  tilde_expand time times title tmpfile toc
syn keyword octaveFunction contained  toeplitz tolower toupper trace transpose
syn keyword octaveFunction contained  trapz treelayout treeplot tril trimesh
syn keyword octaveFunction contained  triplequad triplot trisurf triu tsearch
syn keyword octaveFunction contained  tsearchn typecast typeinfo uibuttongroup
syn keyword octaveFunction contained  uicontextmenu uicontrol uigetdir
syn keyword octaveFunction contained  uigetfile uimenu uint16 uint32 uint64
syn keyword octaveFunction contained  uint8 uipanel uipushtool uiputfile
syn keyword octaveFunction contained  uiresume uisetfont uitable uitoggletool
syn keyword octaveFunction contained  uitoolbar uiwait umask uminus uname
syn keyword octaveFunction contained  undo_string_escapes unicode2native
syn keyword octaveFunction contained  unicode_idx union unique unix unlink
syn keyword octaveFunction contained  unmkpp unpack unsetenv untabify untar
syn keyword octaveFunction contained  unwrap unzip uplus upper urlread urlwrite
syn keyword octaveFunction contained  usejava validateattributes validatestring
syn keyword octaveFunction contained  vander var vec vech vecnorm vectorize ver
syn keyword octaveFunction contained  verLessThan version vertcat view viridis
syn keyword octaveFunction contained  voronoi voronoin waitbar waitfor
syn keyword octaveFunction contained  waitforbuttonpress waitpid warndlg
syn keyword octaveFunction contained  warning warning_ids warranty waterfall
syn keyword octaveFunction contained  web weboptions webread webwrite weekday
syn keyword octaveFunction contained  white whitebg wilkinson winqueryreg
syn keyword octaveFunction contained  winter workspace xlabel xlim xor
syn keyword octaveFunction contained  xticklabels xticks yes_or_no ylabel ylim
syn keyword octaveFunction contained  yticklabels yticks yulewalker zeros zip
syn keyword octaveFunction contained  zlabel zlim zoom zscore zticklabels
syn keyword octaveFunction contained  zticks

" classdef keywords that may also be used as functions
syn keyword octaveFunction contained  enumeration events methods properties 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Add functions defined in .m file being read to list of highlighted functions
function! s:CheckForFunctions()
  let i = 1
  while i <= line('$')
    let line = getline(i)
    " Only look for functions at start of line.
    " Commented function, '# function', will not trigger as match returns 3
    if match(line, '\Cfunction') == 0
      let line = substitute(line, '\vfunction *([^(]*\= *)?', '', '')
      let nfun = matchstr(line, '^\h\w*')
      if !empty(nfun)
        execute "syn keyword octaveFunction" nfun
      endif
    " Include anonymous functions 'func = @(...)'.
    elseif match(line, '\<\%(\h\w*\)\s*=\s*@\s*(') != -1
      let list = matchlist(line, '\<\(\h\w*\)\s*=\s*@\s*(')
      let nfun = list[1]
      if !empty(nfun)
        " Use contained keyword to prevent highlighting on LHS of '='
        execute "syn keyword octaveFunction contained" nfun
      endif
    endif
    let i = i + 1
  endwhile
endfunction

call s:CheckForFunctions()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User Variables.  (Appears early as a rule so it can be overridden)
syn match octaveUserVar  "\<\h\k*\>"

" Define clusters for ease of writing subsequent rules
syn cluster AllGetWords contains=octaveUserVar,octaveCommand,octaveGetFcn,octaveFunction
syn cluster AllSetWords contains=octaveUserVar,octaveCommand,octaveSetFcn,octaveFunction

" Switch highlighting of variables based on coding use
" Get -> Constant or Statement highlighting, Set -> Function highlighting
" order of items is is important here
syn match octaveSetUse  "\<\h\k*\>\s*("me=e-1  contains=@AllSetWords
syn match octaveGetUse  "\<\h\k*\>\%(\s*\)\@>\ze\%([^(]\|(\s*)\|$\)"  contains=@AllGetWords

" Don't highlight Octave keywords on LHS of '=', these are user variables
syn match octaveUserVar  "\<\h\k*\>\ze\s*\%(([^)]\+)\)\?\s*==\@!"
" Special characters i,j,I,J on LHS of relational operator are user variables
syn match octaveUserVar  "\<[ijIJ]\ze\s*[<>!~=]=\?"

" Extend highlight across entire structs
syn match octaveStruct  "\<\h\k*\.\h\%(\k\|\.\)*\>"

" Struct with invalid identifier starting with number (Example: 1ab. or a.1b)
syn region octaveError  start="\<\d\+\ze\h\+\."  end=""  oneline
syn region octaveError  start="\<\h\%(\k\|\.\)\{-}\.\d"hs=e  end="\_\D"he=s-1  oneline

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Strings
syn region octaveString  start=/'/  skip=/''/  end=/'/ contains=octaveStrError,@Spell keepend
syn region octaveString  start=/"/  skip=/\\"/ end=/"/ contains=octaveLineContinuation,octaveStrError,@Spell keepend
" Highlight run-away strings
syn region octaveStrError start=/$/ matchgroup=octaveString end=/'/ end=/"/ contained

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Numbers

" Integer numbers
syn match octaveNumber  "\<\d\+\%([edED][-+]\?\d\+\)\?[ijIJ]\?\>"
" Hex numbers
syn match octaveNumber  "\<0[xX]\x\+\>"
" Binary numbers
syn match octaveNumber  "\<0[bB][01]\+\>"

" BAD numbers with decimal and then text (Example: 1.ab)
syn region octaveError  start="\<\d\+\.\ze\I"  end="\I"he=s-1  oneline
" Floating point number, with dot, optional exponent
syn match octaveFloat   "\<\d\+\.\%(\d\+\)\?\%([edED][-+]\?\d\+\)\?[ijIJ]\?\>"
" Floating point number, starting with a dot, optional exponent
syn match octaveFloat   "\.\d\+\%([edED][-+]\?\d\+\)\?[ijIJ]\?\>"
" BAD numbers with double decimal points (Example: 1.2.3)
syn region octaveError  start="\<\d\+\.\d\+\.[^*/\\^]"hs=e-1 end="\>"  oneline
syn region octaveError  start="\<\d\+\.\d\+[eEdD][-+]\?\d\+\.[^*/\\^]"hs=e-1 end="\>"  oneline

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Optionally highlight Operators

" Transpose must always match to prevent run-away strings
syn match octaveTransposeOperator   "[\])}[:alnum:]_]\@1<=\.\?'"
if exists("octave_highlight_operators")
  " special case for "~/" which is file, not logical operator
  syn match octaveLogicalOperator     "\%([&|!]\|\~\ze[^/]\)"
  syn match octaveArithmeticOperator  "\.\?[-+*/\\^]"
  syn match octaveRelationalOperator  "[=!~]="
  syn match octaveRelationalOperator  "[<>]=\?"
endif

" Improper Operators
" FIXME: More operator error highlighting would be nice
" FIXME: "**" Fortran exponentiation operator should be removed in version 7.0
syn match octaveError "[&|*]\{2}[&|*/\\^]\+"
syn match octaveError "[&|*/\\^][/\\^]\+"
syn match octaveError "[-+]\{2}[\-+&|!~*/\\^]\+"
syn match octaveError "[<>]\{2,}\|[<>=!~]=[<>=]\+\|[!~]\{2}"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Miscellaneous formatting elements

" Delimiters
syn match octaveDelimiter  "[(){}[\]@]"

" Tabs, for possibly highlighting as errors
if exists("octave_highlight_tabs")
  syn match octaveTab  "\t"
endif

" Other special constructs
syn match octaveSemicolon  ";"
syn match octaveTilde  "\~\s*[,\]]"me=s+1

" Line continuations, order of matches is important here
" FIXME: "..." line continuation for strings should be removed for version 7.0
syn match octaveLineContinuation  "\.\{3}$"
syn match octaveLineContinuation  "\\$"
" Trailing characters after line continuation are an error
syn match octaveError  "\.\{3}.\+$"hs=s+3
syn match octaveError  "\\\s\+$"hs=s+1
" Line continuations w/comments are allowed
syn match octaveLineContinuation  "\.\{3}\s*[#%]"me=e-1
syn match octaveLineContinuation  "\\\s*[#%]"me=e-1

" Comments, order of matches is important here
syn keyword octaveFIXME contained  FIXME TODO
syn cluster AllComment contains=octaveFIXME,octaveTab,@Spell
syn match octaveComment  "[%#].*$" contains=@AllComment
syn region octaveBlockComment  start="^\s*[#%]{"ms=s-2  end="^\s*[#%]}" contains=octaveBadBlockCommentStart,@AllComment nextgroup=octaveBadBlockCommentEnd
syn match octaveBadBlockCommentStart "[#%]{\zs\s*\S.*$" contained
syn match octaveBadBlockCommentEnd  "\s*\S.*$" contained

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Apply highlight groups to syntax groups defined above

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_octave_syntax_inits")
  if version < 508
    let did_octave_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi link <args>
  endif

  " All keywords typically result in Statement class highlighting
  HiLink octaveBeginKeyword             Statement
  HiLink octaveElseKeyword              Statement
  HiLink octaveEndKeyword               Statement
  HiLink octaveOOKeyword                Statement
  HiLink octaveLabel                    Label
  HiLink octaveStatement                Statement
  HiLink octaveVarKeyword               Keyword
  HiLink octaveReserved                 Keyword

  " Commands, Functions, and Get/Set functions
  HiLink octaveCommand                  Statement
  HiLink octaveGetFcn                   Constant
  HiLink octaveROFcn                    Constant
  HiLink octaveSetFcn                   Function
  HiLink octaveFunction                 Function

  " Identifiers
  HiLink octaveStruct                   octaveUserVar
  HiLink octaveString                   String
  HiLink octaveStrError                 octaveError
  HiLink octaveNumber                   Number
  HiLink octaveFloat                    Number
  HiLink octaveComment                  Comment
  HiLink octaveBlockComment             Comment
  HiLink octaveBadBlockCommentStart     octaveError 
  HiLink octaveBadBlockCommentEnd       octaveError 
  HiLink octaveFIXME                    Todo
  HiLink octaveDelimiter                Identifier
  HiLink octaveSemicolon                Special
  HiLink octaveTilde                    Special
  HiLink octaveLineContinuation         Special
  HiLink octaveError                    Error

  " Link all operators to one group which can be turned on/off below
  HiLink octaveTransposeOperator        octaveOperator
  HiLink octaveArithmeticOperator       octaveOperator
  HiLink octaveRelationalOperator       octaveOperator
  HiLink octaveLogicalOperator          octaveOperator

  " Optional highlighting
  if exists("octave_highlight_variables")
    HiLink octaveUserVar                PreProc
  else
    HiLink octaveUserVar                None
  endif
  if exists("octave_highlight_operators")
    HiLink octaveOperator               Operator
  endif
  if exists("octave_highlight_tabs")
    " Link to a different class to show tabs not as Errors
    HiLink octaveTab                    octaveError
  endif

  delcommand HiLink
endif

let b:current_syntax = "octave"

"EOF	vim: ts=2 et tw=80 sw=2 sts=0
