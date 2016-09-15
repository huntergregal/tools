#!/usr/bin/python
from pwn import xor
import argparse,sys

parser = argparse.ArgumentParser(description="Tool to XOR two files together.")

parser.add_argument('-a', '--first', dest='first', help='First file to XOR contents against', required=True)
parser.add_argument('-b', '--second', dest='second', help='Second file to XOR contents against', required=True)
parser.add_argument('-o', '--output', dest='output', help='Output file', required=True)
args = parser.parse_args()

if __name__ == '__main__':
	first = args.first
	second = args.second
	output = args.output

	with open(first, 'rb') as f, open(second, 'rb') as s, open(output, 'w') as o:
		payload = xor(f.read(),s.read())
		o.write(payload)

