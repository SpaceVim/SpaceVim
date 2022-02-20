set jar_path=%1

set puml_src_path=%2
set output_dir_path=%3
set output_path=%4
set save_path=%5
set image_type=%6

java -Dapple.awt.UIElement=true -jar "%jar_path%" "%puml_src_path%" -t%image_type% -o "%output_dir_path%"
copy "%output_path%" "%save_path%"
