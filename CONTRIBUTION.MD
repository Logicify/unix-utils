# Contribution Guide

Please be aware that all code hosted in this repository is distributed under MIT license. In order to add new or modify existing tool you need to follow preparation instructions (see below).

## Creating new script: Prepare code

1. Ensure that your code works in linux environment. Doube check if it doesn't crash even when user provides incorrect input arguments.
1. For shell scripts:
	1. Ensure if script is compatible with commonly used terminal environments (sh or bash)
    1. Use the following shebang line `#!/usr/bin/env bash`
1. Make sure sour application/script provides usage instructions when it is invoked with wrong arguments or with `-h` flag.
1. Add the follwing line at the beging or at the end of the help text:

```
Version: <VERSION NUMBER>	Last update: <DATE>

MIT License
Copyright (C) <YEAR> <AUTHOR FIRST AND LAST NAME> (https://github.com/Logicify/unix-utils)"
```

1. Put the license information coment on the very begining of the file (don't forget to replace strings in brackets with real content):

```
#    <ONE LINE DESCRIPTION OF THE TOOL>
#    Copyright (C) <YEAR> <AUTHOR FIRST AND LAST NAME>
#
#    The MIT License (MIT)
#    Permission is hereby granted, free of charge, to any person obtaining
#    a copy of this software and associated documentation files
#    (the "Software"), to deal in the Software without restriction,
#    including without limitation the rights to use, copy, modify, merge,
#    publish, distribute, sublicense, and/or sell copies of the Software,
#    and to permit persons to whom the Software is furnished to do so,
#    subject to the following conditions:
#
#    The above copyright notice and this permission notice shall be
#    included in all copies or substantial portions of the Software.
#
#    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
#    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
#    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
#    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

## Creating new script: Describing your tool

You should supply your tool with comprehensive description which should be added to the README.MD file located in the root of this repository. 

Pay attention on the description section, it should contain comprehensive information about:

1. Purpose of the tool
1. Typical usage scenarios
1. Invocation syntax with examples
1. Information about contriutors
1. Information about version