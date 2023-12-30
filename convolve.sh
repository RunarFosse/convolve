#!/bin/bash

# Display how to use script
help() {
    echo -e "Usage: $0 [input_dimensions] [kernel_size] [-s stride] [-p padding]\n"

    echo "Example: $0 24,24 5,3 -s 1,2 -p 4,3"
    echo -e "Output: 28,14\n"

    echo "Notes:"
    echo "Padding given is symmetric, meaning a padding of 2 adds a total of 4 extra rows/columns."
    echo "Arguments are given on the format m,n where m is the n.o. rows and n is the n.o. columns."
}  

# Format error
format_error() {
    echo -e "Wrong format of arguments.\n" >&2
    help
    exit 1
}

# Verify number of required arguments
if [ "$#" -lt 2 ]; then
    echo "Not enough required arguments" >&2
    help
    exit 1
fi

# Specify variables
input=$1; shift
kernel=$1; shift
stride="1,1"
padding="0,0"

# Parse optional arguments
while getopts ":s:p:h" opt; do
    case $opt in
        s)
            stride=$OPTARG
            ;;
        p)
            padding=$OPTARG
            ;;
        h)
            help
            exit 0
            ;;
        ?)
            help
            exit 1
            ;;
    esac
done

# Verify and format of all passed arguments
IFS=","
if [[ $input =~ ^[0-9]+,[0-9]+$ ]]; then
    read -a inputs <<< "$input"
    input_m=${inputs[0]}
    input_n=${inputs[1]}
else
    format_error
fi
if [[ $kernel =~ ^[0-9]+,[0-9]+$ ]]; then
    read -a kernels <<< "$kernel"
    kernel_m=${kernels[0]}
    kernel_n=${kernels[1]}
else
    format_error
fi
if [[ $stride =~ ^[0-9]+,[0-9]+$ ]]; then
    read -a strides <<< "$stride"
    stride_m=${strides[0]}
    stride_n=${strides[1]}
else
    format_error
fi
if [[ $padding =~ ^[0-9]+,[0-9]+$ ]]; then
    read -a paddings <<< "$padding"
    padding_m=${paddings[0]}
    padding_n=${paddings[1]}
else
    format_error
fi

# Ensure that all arguments but padding are strictly positive
if [ $input_m -le 0 ] || [ $input_n -le 0 ]; then
    echo "Input dimensions have to be strictly positive."
    exit 1
fi
if [ $kernel_m -le 0 ] || [ $kernel_n -le 0 ]; then
    echo "Kernel dimensions have to be strictly positive."
    exit 1
fi
if [ $stride_m -le 0 ] || [ $stride_n -le 0 ]; then
    echo "Stride has to be strictly positive."
    exit 1
fi

# Perform main calculation
output_m=$((($input_m - $kernel_m + 2*$padding_m + 1) / $stride_m))
output_n=$((($input_n - $kernel_n + 2*$padding_n + 1) / $stride_n))

# Output
echo "$output_m,$output_n"