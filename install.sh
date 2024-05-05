#!/bin/bash

echo "This action will purge current instalation!"
read -p "URL? " url

#wipe
rm ~/aethir
md ~/aethir
cd ~/aethir

#download
echo "Downloading binary."
wget $url aethir.tar
untar aethir.tar
rm aethir.tar

echo "Installation done."
