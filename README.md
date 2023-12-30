# Convolve
Compute output dimensions of convolutional layers given input dimensions and kernel size.

Add convolve to `PATH` or run shell script directly. For simplicity's sake, `README` is written assuming `convolve.sh` is linked to the command `convolve`.

------------

## Add to PATH

### Linux or macOS

```
> cp convolve.sh /usr/local/bin/convolve
```

or add `alias convolve=<path to convolve.sh>` in `~/.bashrc`.

Note that convolve requires execute permissions.

### Windows

Open `Environment variables` and add the path to `convolve.sh`.

------------

## Usage

```> convolve [input_dimensions] [kernel_size] [-s stride] [-p padding]```

------------

## Examples

```
> convolve 9,9 4,4
  6,6
```

```
> convolve 4,4 2,2 -p 1,2
  5,7
```

```
> convolve 24,24 5,3 -s 1,2 -p 4,3
  28,14
```

------------

## How it works

The script simply uses the formula for calculating the output shape of a 2D convolutional layer given the input shape, aswell as stride and padding parameters.

$$ \text{Output shape} = \frac{\text{Input shape} - \text{Kernel size} + 2 \cdot \text{Padding}}{\text{Stride}} + 1 $$

------------

## Notes
Padding given is symmetric, meaning a padding of 2 adds a total of 4 extra rows/columns.

Arguments are given on the format m,n where m is the n.o. rows and n is the n.o. columns.

Padding input has to be non-positive, where as input, kernel and stride have to be strictly positive.