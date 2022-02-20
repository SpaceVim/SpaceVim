set java_path=%1
set jar_path=%2

set puml_src_path=%3
set output_dir_path=%4
set output_path=%5
set finial_path=%6
set image_type=%7

set timestamp=%8
set update_js_path=%9

"%java_path%" -Dapple.awt.UIElement=true -jar "%jar_path%" "%puml_src_path%" -t%image_type% -o "%output_dir_path%"
echo F | xcopy /S /Q /F /Y  "%output_path%" "%finial_path%"
echo window.updateDiagramURL('%timestamp%') > "%update_js_path%"
