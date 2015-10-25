# QL Language Reference Manual

### Anshul Gupta (akg2155), Evan Tarrh (ert2123), Gary Lin (gml2153), Matt Piccolella (mjp2220), Mayank Mahajan (mm4399)

## 1.0 Introduction
JavaScript Object Notation (JSON) is an open-standard format that uses human-readable format to capture attribute-value pairs. JSON has gained prominence replacing XML encoded-data in browser-server communication, particularly with the explosion of RESTful APIs and AJAX requests that often make use of JSON.

While domain-specific languages like SQL and PostgreSQL work with relational databases, languages like AWK specialize in processing datatables, especially tab-separated files. We noticed a need for a language designed to interact with JSON data, to quickly search through JSON structures and run meaningful queries.

## 2.0 Data Types
### 2.1 Primitive Types
All primitive data types are passed by value. They can each be declared and then initialized later (their value is null in the interim) or declared and initialized in-line.

#### 2.1.1 Integers (`int`)
Integers are signed, 8-byte literals denoting a number as a sequence of digits e.g. `5`,`6`,`-1`,`0`.

#### 2.1.2 Floating Point Numbers (`float`)
Floats are signed, 8-byte single-precision floating point numbers e.g. `-3.14`, `4e10`, `.1`, `2.`.

#### 2.1.3 Boolean (`bool`)
Booleans are defined by the `true` and `false` keywords. Only boolean types can be used in logical expressions e.g. `true`, `false`.

#### 2.1.4 String (`string`)
Since our language doesn't contain characters, strings are the only way of expressing zero or more characters in the language. Each string is enclosed by two quotation marks e.g. `"e"`, `"Hello, world!"`.

### 2.2 Non-Primitive Types
All non-primitive data types are passed by a reference in memory. They can each be declared and initialized later (their value is null in the interim) or declared and initialized in line.


#### 2.2.1 Arrays (`array`)
Arrays represent multiple instances of one of the primitive data types represente as contiguous memory. The square bracket notation is used to create an array and then get direct access to elements. Each array must contain only a single type of primitives; for example, we can have either an array of `int`, an array of `float`, an array of `bool`, and an array of `string`, but no combinations of these types. The size of the array is fixed at the time of its creation e.g. `array(10)`.

#### 2.2.2 JSON (`json`)
Since the language must search and return results from JSON files, it supports Jsons as a non-primitive type. A `json` object can be created through multiple mechanisms. The first is directly from a filename of a valid JSON. For example, one could write: `json a = json("file1.json")`. This will check `file1.json` to ensure it is a valid JSON, and if so, will store the JSON in the variable `a`. The second way to obtain a JSON object is by using a subset of a current JSON. For example, say the following variable is already set:

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
```

## 3.0 Lexical Conventions
### 3.1 Identifiers
Identifiers are combinations of letters and numbers. They must start with a lowercase letter, and can be any combination of lowercase letters, uppercase letters, and numbers. Lowercase letters and uppercase letters are seen as being distinct. We also reject dashes in identifiers. Identifiers can refer to three things in our language: variables, functions, and function arguments.
### 3.2 Keywords
The following words are defined as keywords and are reserved for the use of the language; thus, they cannot be used as identifiers to name either a variable, a function, or a function argument:

```
int, float, bool, string, json, array, where, in, as, for, while, return, function, true, false, if, elseif, else, void, not
```
### 3.3 Comments
We reserve the symbol `#~~` to introduce a comment and the symbol `~~#` to close a comment. Comments cannot be nested, and they do not occur within string literals. A comment looks as follows:

```
#~~ This is a comment. ~~#
```

### 3.4 Literals
Our language supports several different types of literals.
#### 3.4.1 `int` literals
A string of numeric digits of arbitrary size that does not contain a decimal point with an optional ‘-’ to indicate a negative number.
#### 3.4.2 `float` literals
A string of numeric digits of arbitrary size, followed by a single ‘.’ digit character, followed by another string of numeric digits of arbitrary size. It can also contain an optional ‘-’ to indicate a negative number.
#### 3.4.3 `boolean` literals
Booleans can take on one of two values: `true` or `false`. `true` evaluates to an integer value of 1 and `false` evaluates to an integer value of  0. Thus, something like `true == 1` would evaluate to `true`, and something like `if(1)` would be valid.
#### 3.4.4 `string` literals
A sequence of ASCII characters surrounded by double quotation marks on both sides.

## 4.0 Syntax
### 4.1 Program Structure
A QL program consists of a series of statements. There is no concept of a `main` method in our language. The commands are run in order. We can also define functions, which must be defined earlier in the program than they are used. QL is not an object-oriented, so there is no concept of a class or an object. Similar to languages like Python or AWK, the execution of a QL script will simply run the expressions present in our file.
### 4.2 Punctuation
### 4.3 Operators
[] : attribute access

This can be used in two different ways:

- [int `index`]: accesses value at `index` of array
	* Return type is the same as the array’s type.

- [string `key`]: accesses value at `key` of JSON
	* Return type is inferred from the value in JSON. The type can be one of three things: a value (int, float, bool, string), an array, or a JSON.


This operator can nest, e.g.: [“data”][“views”][“total”]. It associates from left to right.

Here is a program containing different examples of the `[]` operator and their return values based on the following JSON:

```
#~~ [“data”][“views”][“total”] returns an int.

we iterate through each "data" object with a total viewcount less than 100 ~~#

where ([“data”][“views”][“total”] < 80) as item {
	#~~ item[“data”][“users”] returns an array ~~#
	array users = item[“data”][“users”]
	
	#~~ iterate through the array ~~#
	for (int i = 0; i < users.length; i++) {
		#~~ print the user at index i in the array ~~#
		print users[i]
	}
	
	#~~ item[“data”][“items”][“category”] returns a string ~~#
	if (item[“data”][“items”][“category”] == “News”) {
		where (true) as name {
			print “name”	
		} in users
	}
} in json(“file1.json”)


file1.json:

[{“data”: {
	“views”: {
		"total”: 80
	},
	“items: {
		“category”: “News”
	},
	“users”: [
		“Matt”,
		“Evan”,
		“Gary”
	]
},
{“data”: {
	“views”: {
		"total”: 1000
	},
	“items: {
		“category”: “Sports”
	}
}]
```
		
		% : mod
			`int` % `int`: returns int (remainder of ($1 divided by $3))

For all other combinations of types, we throw an error (incompatible data types).

		[ASTERISK] : multiplication
			`int` * `int`: returns int ($1 multiplied by $3)

`double` * `int`, `int` * `double`,  `double` * `double`: returns double ($1                                                                                                                                              multiplied by $3)

For all other combinations of types, we throw an error (incompatible data types).
		/ : division
			`int` / `int`: returns int (floor($1 divided by $3))

`double` * `int`, `int` * `double`,  `double` * `double`: returns double ($1  divided by $3)

For all other combinations of types, we throw an error (incompatible data types).

		[PLUS] : addition
			`int` / `int`: returns int ($1 added to $3)

`double` * `int`, `int` * `double`,  `double` * `double`: returns double ($1  added to $3)

For all other combinations of types, we throw an error (incompatible data types).


		[MINUS] : subtraction
			`int` / `int`: returns int ($1 minus $3)

`double` * `int`, `int` * `double`,  `double` * `double`: returns double ($1  minus $3)

For all other combinations of types, we throw an error (incompatible data types).
		
		= : assignment
			`anytype` = `anytype`: sets value of $1 to $3.

If the type of $1 is different from the type of $3, we throw an error (no casting).

		not : negation
not `bool` = returns a bool (if bool was true, return false; if bool was false, return true)

If this operator is used on anything other than a bool, we throw an error.

		== : equivalence,
		!= : non-equivalence,
		> : greater than, 
		< : less than, 
		>= : greater than or equal to,
		<= : less than or equal to

`anytype` OP `anytype`: returns a bool (true if $1 OP $3 e.g. `3 == 3` returns true)

			if $1 and $3 are strings, we do a lexical comparison

			if $1 and $3 are both ints, or both floats, we see if they are equal

if the types are anything else, throws an error (no casting)

		& :
`bool1` & `bool2`: returns true if they both are true, otherwise returns false

`expr1` & `expr2`: evaluates expr1 and expr2 as booleans (throws error if this is not possible), and returns true if they both evaluate to true; otherwise, returns false.

		| :
`bool1` | `bool2`: returns true if either bool1 or bool2 is true, otherwise returns false

`expr1` | `expr2`: evaluates expr1 and expr2 as booleans (throws error if this is not possible), and returns true if either evaluate to true; otherwise, returns false.


### 4.4 Declarations
### 4.5 Statements


<<<<<<< HEAD
## 5 Standard Library Functions

Standard library functions are included with the language for convenience for the user. The first few of these functions will give users the ability to perform basic modifying operations with arrays.

###5.0 `append`
```
function append(array arr, int x) : array {

}
```

The above function takes in an array and an integer as arguments and returns an array with size increased by 1 that contains that integer at the last index.

### 5.1 `unique`

```
function unique(array arr) : array {
	
}
```

The above function receives an array as argument and returns a copy of the array with duplicate values removed. Only the first appearance of each element will be conserved, and a resulting array is returned.

### 5.2 `sort`

```
function sort(array arr) : array {
	
}
```

The above function receives an array as argument and returns a copy of the array with all of the elements sorted in ascending order. To compare the elements of the array, the `>` operator is used. For example, the array [1,4,3,5,2] passed into the sort() method would return [1,2,3,4,5]. The array [“c”,”e”,”a”,”c”,”f”] would return [“a”,”c”,”d”,”e”,”f”].
=======
## 5.0 Standard Library Functions
>>>>>>> c5e97789ea88d74d94cfbd796a23b0c6c7b0396d
