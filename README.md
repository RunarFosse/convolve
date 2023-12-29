# Convolve
Compute output dimensions of convolutional layers given input dimensions and kernel size.

Add convolve to `PATH` or run shell script directly. For simplicity's sake, `README` is written assuming `convolve.sh` is linked to the command `convolve`.

------------

## Usage

```> convolve [input_dimensions] [kernel_size] [-s stride] [-p padding]```

------------

## Example

```
> convolve 24,24 5,3 -s 1,2 -p 4,3
  28,14
```

------------

## Notes
Padding given is symmetric, meaning a padding of 2 adds a total of 4 extra rows/columns.

Arguments are given on the format m,n where m is the n.o. rows and n is the n.o. columns.