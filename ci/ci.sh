#!/usr/bin/env bash

sources=(main.cpp greeter.h greeter.cpp)

for file in ${sources[@]}; do
  cp src/${file} upload/${file}
done
cd upload
zip example-zip.zip main.cpp greeter.h greeter.cpp

mkdir example-xmake
mv example.zip example-xmake/example.zip
cd example-xmake
unzip example.zip
cd ..

mkdir example-zip
mv example-zip.zip example-zip/example.zip
cd example-zip
unzip example.zip
cd ..

for file in ${sources[@]}; do
  diff example-xmake/${file} example-zip/${file}
done

rm -rf example-xmake
rm -rf example-zip

cd ..

rm -rf upload
