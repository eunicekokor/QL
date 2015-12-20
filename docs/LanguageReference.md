# QL Language Reference Manual

### Anshul Gupta (akg2155), Evan Tarrh (ert2123), Gary Lin (gml2153), Matt Piccolella (mjp2220), Mayank Mahajan (mm4399)

##Table of Contents



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

Expressions in QL can be one of the following types. A statment in our language can be composed of just an expression but it's much more useful to use them in other statements like if-else constructs, loops and assign statements.

### 4.1 Data Type Literal
Expressions can be just a literal, as defined for our language in Section 2.4 above. This allows us to directly input a value where needed.

e.g in `int a = 5` the 5 on the right hand side of the assignment operator is a Data Type Literal of integer type, used to assign a value to the variable `a`.

### 4.2 Identifier
Expressions can be just an identifier, as defined for our language in Section 2.1 above. This allows us to use variables as values where needed.

e.g in `int b = a` the `a` on the right hand side of the assignment operator is an Identifier of integer type, used to assign a value to the variable `b`.

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

    It is unclear what a["value"] is so our compiler infers that it will be an integer, since the left hand side of the assignment is an `int`. This happens in our static semantic check.

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
`*` : multiplication (left associative)
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
`/` : division (left associative)
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
`+` : addition (left associative)
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
`-` : subtraction (left associative)
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

Boolean expressions are fundamentally important to the decision constructs used in our language, like the `if-else` block and inside the conditional statements for loops like `while`, `for` and `where`. Each boolean expression must evaluate to `True` or `False`. 

#### 4.5.1 Boolean Literal

Boolean expressions can be just a boolean literal, which could be the keyword `True` or `False`.

e.g in `if(True)` the `True` inside the `if` conditional is a Boolean Literal.

#### 4.5.2 Identifier of boolean variable

Expressions can be just an identifier, as defined for our language in Section 2.1 above. This allows us to use variables as values where needed. QL performs static semantic checking to ensure that the identifier used as a Boolean expression has been defined earlier with `bool` type. 

e.g in `if(a)` the `a` inside the `if` conditional is a Identifier that must be of bool type.

#### 4.5.3 `not` : negation

- `not bool_expr` evaluates `bool_expr` as a boolean first and then returns the opposite of the `bool_expr` (if `bool_expr` was true, return false; if `bool_expr` was false, return true)

If the `not` operator is used on anything other than a bool, we throw an error.

#### 4.5.4 Equivalency operators
- == : equivalence,
- != : non-equivalence,
- \> : greater than,
- < : less than,
- \>= : greater than or equal to,
- <= : less than or equal to

Each of these operators act on two operands, each of an `expr` as defined in Section 4.4 above. It is important to note that neither of the operands of the equivalency operator can acutally be of boolean types themselves. The operator returns a bool.

Our static semantic checker checks at compile time if the operands on either side of the equivalency operators are of the same data type or not. Since QL does not support type casting, in case the data types fail to match, the compiler reports an error.

Examples of this operator:

- `3 == 3`, checks for equality between the two integer literals
- `5.0 != 3`, fails to work because the two operands are of different data types
- `"anshul" >= "ninja"`, we do a lexical comparison since both the operands are strings
- `a == 5 + 4`, evaluates both operands, each an `expr` before applying the equivalency boolan operator. As such, the data type of `a` is obtained from the symbol table and then 5 + 4 is evaluated before checking for equality. In case, `a` is not of type `int` as inferred from the operand that evaluates to 9, the compiler reports an error.
- `a > 5 == 3` fails to work because although the precedence rules evalaute this boolean expression from left to right, `a > 5` returns a type of `bool` which cannot be used in the `==` operators.

#### 4.5.5 Logical operators

- `expr1` & `expr2`: evaluates `expr1` and `expr2` as booleans (throws error if this is not possible), and returns true if they both evaluate to true; otherwise, returns false.

- `expr1` | `expr2`: evaluates `expr1` and `expr2` as booleans (throws error if this is not possible), and returns true if either evaluate to true; otherwise, returns false.

### 4.6 Function Calls
A function-call invokes a previously declared function by matching the unique function name and the list of arguments, as follows:

```
<function_identifier>(<arg1>,<arg2>,...)
```

This transfers the control of the program execution to the invoked function and waits for it to return before proceeding with computation. Some examples of possible function calls are:

```
array int a = [4;2;1;3]
array int b = sort(a)
```

The int array in b is now equal to [1;2;3;4]

## 5.0 Statements
EVAN -- I dont think we need this, what do you think?
<!-- There are several different kinds of statements in QL, including both basic and compound statements. Basic statements can consist of three different types of expressions, including assignments, mathematical operations, and function calls. Statements are separated by the newline character `\n`. The newline character, which you will see code samples below as `\n` is produced by the return key.  The code below is the most primitive example of an expression.

```
expression \n
```

The effects of the expression are evaluated prior to the next expression being evaluated. The precedence of operators within the expression goes from highest to lowest. To determine which operator binds tighter than another, check the operator precedence above.
 -->
### 5.1 Declaring Variables
To declare a variable, a data type must be specified followed by the variable name and an equals sign.  The right side of the equals sign depends on what type of data type has been declared. If it is a primitive data type, then the user has to specify the corresponding literal of that data type.  If the data type is non-primitive, then the user has to enumerate either the array it is assigning into the variable or the json constructor with the corresponding JSON file name passed in. In addition, variables can be declared and assigned as another previously declared variable of the same data type.

EVAN - grammar rules have a diff formatting from code
This is the specific grammar for declaring a variable.
```
<assignment_data_type> <id> = <expr>
<expr> = <literal> | <id>
```
Some examples of the declaration of variables would be:

```
array testArr = array(10)
int i = 0
float f = 1.4
bool b = True
string s = "goats"
```

### 5.2 Updating Variables
To update a variable, the variable on the left side of the equals sign must already by declared.  The right side of the equals sign follows the same rules as section 5.1's explanation of declaring variables.  The only distinction is this time, there does not need to be a data type prior to the variable name on the left hand side of the equals sign.

EVAN - grammar rules have a diff formatting from code
This is the specific grammar for reassigning a variable.
```
<id> = <expr>
<expr> = <literal> | <id>
```
Some examples of the declaration of variables would be (note we are assuming these variables were previously declared as the correct corresponding type):

```
testArr = array(10)
i = 0
f = 1.4
b = True
s = "goats"
```

### 5.3 Function Declaration
Function declarations in QL all start with the keyword function, followed by the function identifier, parentheses with parameter declarations inside, a return type 

GARY

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
#### 5.5.4 `if/else` clauses

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

