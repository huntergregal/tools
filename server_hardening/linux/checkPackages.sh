#!/bin/bash

echo 'Requires debsums - apt-get install debsums'
echo 'Only prints packages that fail the check - May take a while'
echo 'running...'
debsums | grep -v "OK$"
