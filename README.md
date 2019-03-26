# vcpkg-ports

Additional ports for vcpkg.

## Installation

Copy the vcpkg/ports/* directories into your vcpkg/ports/ directory to make the packages available in your vcpkg setup. You may install the packages in the same way you are installing any other package using vcpkg:

```
.\vcpkg install <PACKAGE>
```

## Usage

See the usage files for each package to learn how to use repective packages.

## Additional Notes

The currently available port for librsvg uses the deprecated version 2.40.20. More recent versions of librsvg are based on rust making to installation more complex. Feel free to contribute portfiles for these versions.
