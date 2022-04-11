#!/usr/bin/env bash

java_path=$1
jar_path=$2

puml_src_path=$3
output_dir_path=$4
output_path=$5
finial_path=$6
image_type=$7

timestamp=$8
update_js_path=$9

"$java_path" -Dapple.awt.UIElement=true -jar "$jar_path" "$puml_src_path" -t$image_type -o "$output_dir_path"
cp "$output_path" "$finial_path"
echo "window.updateDiagramURL('$timestamp')" > "$update_js_path"
