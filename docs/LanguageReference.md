# QL Language Reference Manual

### Anshul Gupta (akg2155), Evan Tarrh (ert2123), Gary Lin (gml2153), Matt Piccolella (mjp2220), Mayank Mahajan (mm4399)

##Table of Contents
### 1.0 Introduction
### 2.0 Lexical Conventions
#### 2.1 Identifiers
#### 2.2 Keywords
#### 2.3 Comments
#### 2.4 Literals
### 3.0 Data Types
#### 3.1 Primitive Types
#### 3.2 Non-Primitive Types
### 4.0 Syntax
#### 4.1 Punctuation
#### 4.2 Operators
#### 4.3 Expressions
#### 4.4 Statements
### 5.0 Standard Library Functions


## 1.0 Introduction
JavaScript Object Notation (JSON) is an open-standard format that uses human-readable format to capture attribute-value pairs. JSON has gained prominence replacing XML encoded-data in browser-server communication, particularly with the explosion of RESTful APIs and AJAX requests that often make use of JSON.

While domain-specific languages like SQL and PostgreSQL work with relational databases, languages like AWK specialize in processing datatables, especially tab-separated files. We noticed a need for a language designed to interact with JSON data, to quickly search through JSON structures and run meaningful queries on the JSON data, all the while using a syntax that aligned much more closely with the actual structure of the data we were using.

## 2.0 Lexical Conventions
### 2.1 Identifiers
Identifiers are combinations of letters and numbers. They must start with a lowercase letter, and can be any combination of lowercase letters, uppercase letters, and numbers. Lowercase letters and uppercase letters are seen as being distinct. Identifiers can refer to three things in our language: variables, functions, and function arguments.
### 2.2 Keywords
The following words are defined as keywords and are reserved for the use of the language; thus, they cannot be used as identifiers to name either a variable, a function, or a function argument:

```
int, float, bool, string, json, array, where, in, as, for, while, return, function, true, false, if, elseif, else, void, not
```
### 2.3 Comments
We reserve the symbol `#~~` to introduce a comment and the symbol `~~#` to close a comment. Comments cannot be nested, and they do not occur within string literals. A comment looks as follows:

```
#~~ This is a comment. ~~#
```

### 2.4 Literals
Our language supports several different types of literals.
#### 2.4.1 `int` literals
A string of numeric digits of arbitrary size that does not contain a decimal point.  Integers can have an optional ‘-’ at the beginning of the string of numbers to indicate a negative number.
#### 2.4.2 `float` literals
QL is following Brian Kernighan and Dennis Ritchie's explanation in *The C Programming Language*: "A floating constant consists of an integer part, a decimal part, a fraction part, an e, and an optionally signed integer exponent. The integer and fraction parts both consist of a sequence of digits. Either the integer part, or the fraction part (not both) may be missing; either the decimal point or the e and the exponent (not both) may be missing." Floats can also contain an optional ‘-’ at the beginning of the float to indicate a negative value.  
#### 2.4.3 `boolean` literals
Booleans can take on one of two values: `True` or `False`. Booleans in QL are capitalized.
#### 2.4.4 `string` literals
A sequence of ASCII characters surrounded by double quotation marks on both sides.

## 3.0 Data Types
### 3.1 Primitive Types
The primitive types in QL can be statically typed; in other words, the type of a variable is known at compile time. This occurs when the right side of the assignment is a literal of a data type. The primitive types can be declared and then initialized later (their value is null in the interim) or declared and initialized in-line. 

#### 3.1.1 Integers (`int`)
Integers are signed, 8-byte literals denoting a number as a sequence of digits e.g. `5`,`6`,`-1`,`0`.

#### 3.1.2 Floating Point Numbers (`float`)
Floats are signed, 8-byte single-precision floating point numbers e.g. `-3.14`, `4e10`, `.1`, `2.`.

#### 3.1.3 Boolean (`bool`)
Booleans are defined by the `True` and `False` keywords. Only boolean types can be used in logical expressions e.g. `True`, `False`.

#### 3.1.4 String (`string`)
Since our language doesn't contain characters, strings are the only way of expressing zero or more characters in the language. Each string is enclosed by two quotation marks e.g. `"e"`, `"Hello, world!"`.

### 3.2 Non-Primitive Types
All non-primitive data types are passed by a reference in memory. They can each be declared and initialized later (their value is null in the interim) or declared and initialized in line.


#### 3.2.1 Arrays (`array`)
Arrays represent multiple instances of one of the primitive data types represented as contiguous memory. Each array must contain only a single type of primitives; for example, we can have either an array of `int`, an array of `float`, an array of `bool`, and an array of `string`, but no combinations of these types. Note that nested arrays are not allowed in QL. The size of the array is fixed at the time of its creation e.g. `array(10)`. Arrays in QL are statically typed since the type of a variable is known at compile time.

#### 3.2.2 JSON (`json`)
Since the language must search and return results from JSON files, it supports Jsons as a non-primitive type. A `json` object can be created directly from a filename of a valid JSON. For example, one could write: `json a = json("file1.json")`. During runtime, the generated java code will check if the contents of the file make up a valid json. This means that Jsons are dynamically typed in QL. 

Jsons are statically inferred but checked dynamically typed in QL.  At compile time, 

<!-- The second way to obtain a JSON object is by using a subset of a current JSON. For example, say the following variable is already set:

```
b = {
    "size":10,
    "links": {
        "1": 1,
        "2": 2,
        "3": 3
    }
}
```

QL then allows for commands like `json links = b["links"]`. The links variable would then look as follows:

```
links = {
    "1" : 1,
    "2" : 2,
    "3" : 3
}
``` -->

## 4.0 Expressions

### 4.1 Data Type Literal
ANSHUL
### 4.2 Identifier
ANSHUL

### 4.3 Bracket Selector

This can be used in two different ways:

- [int `index`]: accesses value at `index` of an array variable
    * Return type is the same as the array’s type.
    * This square bracket notation can be used to assign a value into a variable.
    <FORMATTING>
    Example of QL Code:
    `array int a = [1;2;3;4]
    int b = a[2]`

    At the end of this program, b is equal to 3.
    </FORMATTING>

- [string `key`]: accesses value at `key` of a JSON variable
    * Return type is inferred from the value in JSON. The type can be one of two things: a value (int, float, bool, string) and an array.
    * QL performs static inferring when a declared variable is assigned to a json variable with bracket selectors. The program will check what the type of the left hand side of the assignment is and infer that the json with bracket selectors will resolve to that type.
    <FORMATTING>
    Example of QL Code:
    `json a = json("sample.json")
    int b = a["value"]`

    It is unclear what a["value"] is so our compiler infers that it will be an integer, since the left hand side of the assignment is an `int`.

This operator can be nested, e.g.: ["data"]["views"]["total"]. It associates from left to right.  This means that each additional bracket selector will go one level deeper into the json by getting the value of corresponding key.

Below is a program containing different examples of the `[]` operator. `file1.json` is the JSON file we will be using in this example.

file1.json:
```
{"data": {
    "views": {
        "total": 80
    },
    "items": {
        "category": "News"
    },
    "users": [
        "Matt",
        "Evan",
        "Gary"
    ]
}
```

bracket-example.ql:
```
json file1 = json("file1.json")

#~~ file1["data"]["views"]["total"] statically inferred as an int ~~#
int total = file1["data"]["views"]["total"]
print (total)
```

### 4.4 Binary Operator
#### 4.4.1 Multiplication: `*`
`*` : multiplication
- e1 * e2: 
<FORMATTING>
This operation is only valid when both e1 and e2 are integers or floats.
When e1 and e2 are ints, this operator will return an int.
When e1 and e2 are floats, this operator will return a float.

For all other combinations of types, we throw an error (incompatible data types).

Below is an example of the `*` operator:

```
int a = 5 * 6
print(a)

float b = 1.0 * 10.0
print(b)
```
The program above will print a as 30 and be as 10.0.

</FORMATTING>

#### 4.4.2 Division: `/`
- e1 / e2: 
<FORMATTING>
This operation is only valid when both e1 and e2 are integers or floats.
When e1 and e2 are ints, this operator will return an int.
When e1 and e2 are floats, this operator will return a float.

For all other combinations of types, we throw an error (incompatible data types).

Below is an example of the `/` operator:

```
int a = 10 / 2
print(a)

float b = 100.0 / 20.0
print(b)
```
The program above will print a as 5 and be as 5.0.

</FORMATTING>

#### 4.4.3 Addition: `+`
- e1 + e2: 
<FORMATTING>
This operation is only valid when both e1 and e2 are integers, floats, or strings.
When e1 and e2 are ints, this operator will return an int.
When e1 and e2 are floats, this operator will return a float.
When e1 and e2 are strings, this operator will return a string.

For all other combinations of types, we throw an error (incompatible data types).

Below is an example of the `+` operator:

```
int a = 1 + 2
print(a)

float b = 10.1 + 4.1
print(b)

string c = "hello " + "goat"
print(c)
```
The program above will print a as 3, b as 14.2, and c as "hello goat".

</FORMATTING>

#### 4.4.4 Subtraction: `-`
- e1 - e2: 
<FORMATTING>
This operation is only valid when both e1 and e2 are integers or floats.
When e1 and e2 are ints, this operator will return an int.
When e1 and e2 are floats, this operator will return a float.

For all other combinations of types, we throw an error (incompatible data types).

Below is an example of the `-` operator:

```
int a = 10 - 1
print(a)

float b = 10.0 - 1.9
print(b)
```
The program above will print a as 9 and b as 8.1.

### 4.5 Boolean Expressions

#### 4.5.1 `not` : negation

- not `expr` = evaluates `expr` as a boolean (throws error if this is not possible); returns the opposite of `expr` (if `expr` was true, return false; if `expr` was false, return true)

If this operator is used on anything other than a bool, we throw an error.

#### 4.5.2 Equivalency operators
- == : equivalence,
- != : non-equivalence,
- \> : greater than,
- < : less than,
- \>= : greater than or equal to,
- <= : less than or equal to

`anytype` OP `anytype`: returns a bool (true if $1 OP $3 e.g. `3 == 3` returns true)

- if $1 and $3 are strings, we do a lexical comparison

- if $1 and $3 are both ints, or both floats, we see if they are equal

If the types are anything other than these specified combinations, we throw an error.

#### 4.5.3 Logical operators

- `expr1` & `expr2`: evaluates `expr1` and `expr2` as booleans (throws error if this is not possible), and returns true if they both evaluate to true; otherwise, returns false.

- `expr1` | `expr2`: evaluates `expr1` and `expr2` as booleans (throws error if this is not possible), and returns true if either evaluate to true; otherwise, returns false.

#### --> needs to be Boolean Expression
ANSHUL
Our conditional statements behave as conditional statements in other languages do. They check the truth of a condition, executing a list of statements if the boolean condition provided is true. Only the `if` statement is required. We can provide an arbitrary number of `elseif` statements following the `if`, though there can also be none. Finally, we can follow an `if`/combination of `elseif`'s with a single `else`, though there can be only one.

```
if (__boolean condition__) {
    #~~ List of statements ~~#
}
elseif (__boolean condition__) {
    #~~ List of statements ~~#
} else {
    #~~ List of statements ~~#
}
```

### 4.6 Function Calls
A function-call invokes a previously declared function by matching the unique function name and the list of arguments, as follows:

```
<function_identifier>(<arg1>,<arg2>,...)
```

This transfers the control of the program execution to the invoked function and waits for it to return before proceeding with computation. Some examples of possible function calls are:

```
sort(a)
array a = append(a, int(2))
```

## 5.0 Statements
There are several different kinds of statements in QL, including both basic and compound statements. Basic statements can consist of three different types of expressions, including assignments, mathematical operations, and function calls. Statements are separated by the newline character `\n`, as follows:

```
expression \n
```

The effects of the expression are evaluated prior to the next expression being evaluated. The precedence of operators within the expression goes from highest to lowest. To determine which operator binds tighter than another, check the operator precedence above.

### 5.1 Declaring Variables
To declare a variable, a data type must be specified followed by the variable name and an equals sign.  After the equal sign, the user has to specify the datatype with the corresponding parameters to be passed into the constructor in parentheses.

```
<data_type> <variable_name> = <data_type>(<parameter>)
<parameter> = <identifier> | <literal>
```

Some examples of the declaration of variables would be:

```
array testArr = array(10)
int i = int(0)
float f = float(1.4e10)
bool b = bool(true)
string s = string("foo")
```

### 5.2 Updating Variables

### 5.3 Function Declaration

### 5.4 Return statements
A return statement ends the definition of a function which has a non-void return type. If there is no return statement at the bottom of the function block, it is evidence that there is a `void` return type for the function; if it's not a `void` return type, then we return a compiler error.

### 5.5 Loop statements
#### 5.5.1 `where` clauses
The where clause allows the user to search through a JSON and find all of the elements within that JSON that match a certain boolean condition. This condition can be related to the structure of the element; for example, the condition can impose a condition of the certain property or key of the element itself.

A where condition must start with the `where` keyword, followed by a boolean condition enclosed in parentheses. This condition will be checked against every element in the JSON. The next element is the `as __identifier__`, which allows the user to identify the element within the JSON that is currently being processed. This must be included. Following this is an `{`, which marks the beginning of the body code which is applied to each element. A closing `}` signifies the end of the body. The last section is the "in" keyword, which is followed by the JSON through which the clause will iterate to extract elements.

```
where (__boolean condition__) as __identifier__ {
    #~~ List of statements ~~#
} in __json__
```

#### 5.5.2 `for` loops
The for loop starts with the `for` keyword, followed by a set of three expressions separated by commas and enclosed by parentheses. The first expression is the initialization, where temporary variables can be initialized. The second expression is the boolean condition; at each iteration through the loop, the boolean condition will be checked. The loop will execute as long as the boolean condition is satisfied, and will exit as soon as the condition is evaluated to false. The third expression is the afterthought, where variables can be updated at each stage of the loop. Following these three expressions is an open `{` , followed by a list of statements, and then a close `}`.

```
for (__initialization__, __boolean condition__, __update__) {
    #~~ List of statements ~~#
}
```

#### 5.5.3 `while` loops
The while loop is initiated by the `while` keyword, followed by an open paren `(`, followed by a boolean expression, which is then followed by a close paren `)`. After this, there is a block of statements, enclosed by `{` and `}`, which are executed in succession until the condition inside the `while` parentheses is no longer satisfied. This behaves as `while` loops do in other languages.

```
while (__boolean condition__) {
    #~~ List of statements ~~#
}
```

## 6.0 Standard Library Functions

Standard library functions are included with the language for convenience for the user. The first few of these functions will give users the ability to perform basic modifying operations with arrays.

### 6.1 `append`
```
function append(array arr, int x) : array {

}
```

The above function takes in an array and an integer as arguments and returns an array with size increased by 1 that contains that integer at the last index.

### 6.2 `unique`

```
function unique(array arr) : array {

}
```

The above function receives an array as argument and returns a copy of the array with duplicate values removed. Only the first appearance of each element will be conserved, and a resulting array is returned.

### 6.3 `sort`

```
function sort(array arr) : array {

}
```

The above function receives an array as argument and returns a copy of the array with all of the elements sorted in ascending order. To compare the elements of the array, the `>` operator is used. For example, the array `[1,4,3,5,2]` passed into the sort() method would return `[1,2,3,4,5]`. The array `["c","e","a","c","f"]` would return `["a","c","d","e","f"]`.

### 6.4 `print`

We also include a built-in print function to print strings and primitive types.

```
print(toPrint)
```

Multiple primitives  may be printed to console in one statement, concatenated by a `+`:

```
print(toPrint1 + toPrint2)
```

Attempting to print something that is not a primitive wi llresult in an error.


-------
OLD STUFF DON'T KNOW IF WE STILL NEED

## 4.0 Syntax
The following sections define the specifics of the syntax of our language.

### 4.1 Punctuation

QL employs several different types of punctuation to signal certain directions of workflow or special blocks of code within programs.

####4.1.1 `()`: hierarchical evaluation, function arguments, `where` clauses

Parentheses can be used in three main cases:

- Numerical or Boolean statements: Forces the expression inside the parentheses to be evaluated before interacting with tokens outside of the parentheses. For example, in `1*(2-3)`, the expression `2-3` will be evaluated, and its result will then be multiplied with 1. These can also be nested, e.g. : (1 + (4-(5/3)*2)).

- Function arguments: When providing arguments during a function call, the arguments must be listed within parentheses directly after the name of the function. For examples, foo(array a, int b) involves a function foo() that takes in an array and an integer enclosed in parentheses. The parentheses are also used for marking the argument list in the function definition, i.e.

```
function foo(array a, int b) : array {
    #~~ code goes here ~~#
}

foo(arr1, myInt)
```

- `Where` clauses: In a `where` clause, the search criteria must be enclosed within parentheses, and the expression within the parentheses should evaluate to a boolean value. For example,

```
where(["size"] > 10 & ["weight"] < 4) as item {
    #~~ code goes here ~~#
}
```

####4.1.2 `{}`: function definitions, `where` clauses

Curly braces have two uses:

- Function definitions: When a function is defined, the procedural code to be run must be enclosed in curly braces.

- `where` clauses: In a `where` clause, immediately following the search criteria, curly braces enclose the code to be implemented. Using the `where` clause outlined above. The open and closed curly braces should contain all of the code to be run for each entry within the JSON that passes the filter.

####4.1.3 `:`: function return types
The colon has use in our language as the specifier of a function return type. Separated between our language identifier and its argument list, we specify a `:` to mark that we will not be specifying a return type. Immediately after this colon, then, comes our function return type, which can be any of the data types we described above.

