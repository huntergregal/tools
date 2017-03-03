#!/bin/bash

echo 'Monitors current directory for any changes using git'
git init
git add .
git commit -m "inital commit"
clear
watch -n 10 'git status'
