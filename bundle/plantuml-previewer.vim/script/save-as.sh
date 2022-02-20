#!/usr/bin/env bash
jar_path=$1

puml_src_path=$2
output_dir_path=$3
output_path=$4
save_path=$5
image_type=$6

java -Dapple.awt.UIElement=true -jar "$jar_path" "$puml_src_path" -t$image_type -o "$output_dir_path"
cp "$output_path" "$save_path"
