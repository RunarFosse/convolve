#!/bin/bash

# Display how to use script
help() {
    echo -e "Usage: $0 [input_dimensions] [kernel_size] [-s stride] [-p padding]\n"

    echo "Example: $0 24,24 5,3 -s 1,2 -p 4,3"
    echo -e "Output: 28,14\n"

    echo "Notes:"
    echo "Padding given is symmetric, meaning a padding of 2 adds a total of 4 extra rows/columns."
    echo "Arguments are given on the format m,n where m is the n.o. rows and n is the n.o. columns."
    echo "Stride and padding can also be given as a single integer, meaning that horizontal and vertical stride/padding is equal."
    echo "Padding input has to be non-positive, where as input, kernel and stride have to be strictly positive."
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

# Verify and format of input and kernel arguments
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

# Default optional argument values
stride_m=1
stride_n=1
padding_m=0
padding_n=0

# Verify and parse optional arguments
while getopts ":s:p:h" opt; do
    case $opt in
        s)
            stride=$OPTARG
            if [[ $stride =~ ^[0-9]+,[0-9]+$ ]]; then
                read -a strides <<< "$stride"
                stride_m=${strides[0]}
                stride_n=${strides[1]}
            elif [[ $stride =~ ^[0-9]+$ ]]; then
                stride_m=$stride
                stride_n=$stride
            else
                format_error
            fi
            ;;
        p)
            padding=$OPTARG
            if [[ $padding =~ ^[0-9]+,[0-9]+$ ]]; then
                read -a paddings <<< "$padding"
                padding_m=${paddings[0]}
                padding_n=${paddings[1]}
            elif [[ $padding =~ ^[0-9]+$ ]]; then
                padding_m=$padding
                padding_n=$padding
            else
                format_error
            fi
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
if [ $padding_m -lt 0 ] || [ $padding_n -lt 0 ]; then
    echo "Padding has to be non-negative."
    exit 1
fi

# Ensure that input + padding is bigger than or equal to kernel size. If not, convolution wouldn't work.
padded_input_m=$(($input_m + 2*$padding_m))
padded_input_n=$(($input_n + 2*$padding_n))
if [ $padded_input_m -lt $kernel_m ] || [ $padded_input_n -lt $kernel_n ]; then
    echo "Padded input dimensions have to be equal to or larger than kernel dimensions."
    exit 1
fi

# Perform main calculation
output_m=$((($input_m - $kernel_m + 2*$padding_m) / $stride_m + 1))
output_n=$((($input_n - $kernel_n + 2*$padding_n) / $stride_n + 1))

# Output result
echo "$output_m,$output_n"