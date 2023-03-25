#!/usr/bin/env bash
java=${1}
jar_path=${2}

puml_src_path=${3}
output_dir_path=${4}
output_path=${5}
save_path=${6}
image_type=${7}
include_path=${8}

$java -Dapple.awt.UIElement=true -Djava.awt.headless=true -Dplantuml.include.path="$include_path" -jar "$jar_path" "$puml_src_path" -t$image_type -o "$output_dir_path"
cp "$output_path" "$save_path"
