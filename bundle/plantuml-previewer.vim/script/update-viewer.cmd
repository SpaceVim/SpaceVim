set java=%1
shift
set jar_path=%1
shift

set puml_src_path=%1
shift
set output_dir_path=%1
shift
set output_path=%1
shift
set finial_path=%1
shift
set image_type=%1
shift

set timestamp=%1
shift
set update_js_path=%1
shift
set include_path=%1
shift

%java% -Dapple.awt.UIElement=true -Dplantuml.include.path="%include_path%" -jar "%jar_path%" "%puml_src_path%" -t%image_type% -o "%output_dir_path%"
echo F | xcopy /S /Q /F /Y  "%output_path%" "%finial_path%"
echo window.updateDiagramURL('%timestamp%') > "%update_js_path%"
