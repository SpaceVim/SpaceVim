set jar_path=%1

set puml_src_path=%2
set output_dir_path=%3
set output_path=%4
set finial_path=%5
set image_type=%6

set timestamp=%7
set update_js_path=%8

java -Dapple.awt.UIElement=true -jar "%jar_path%" "%puml_src_path%" -t%image_type% -o "%output_dir_path%"
echo F | xcopy /S /Q /F /Y  "%output_path%" "%finial_path%"
echo window.updateDiagramURL('%timestamp%') > "%update_js_path%"
