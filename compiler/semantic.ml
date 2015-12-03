(* Compile the program to Java. Does no compile time check for now*)
open Ast;;
open Environment;;

type data_type = Int | Float | Bool | String | Array | Json | AnyType

exception ReturnStatementMissing;;
exception ImproperBraceSelection;;
exception ImproperBraceSelectorType;;
exception MultiDimensionalArraysNotAllowed;;
exception NotBoolExpr;;
exception BadBinopType;;
exception IncorrectWhereType;;

(* write program to .java file *)
let write_to_file prog_str =
    let file = open_out "Test.java" in
        Printf.fprintf file "%s" prog_str

(* TODO: Try to get rid of this. Weird to have two different representations. *)
let ast_data_to_data (dt : Ast.data_type) = match dt
	with Int -> Int
	| Float -> Float
	| Bool -> Bool
	| String -> String
	| Array(i) -> Array
	| Json -> Json
	| _ -> AnyType

let data_to_ast_data (dt : data_type) = match dt
	with Int -> Ast.Int
	| Float -> Ast.Float
	| Bool -> Ast.Bool
	| String -> Ast.String
	| Array -> Ast.Array(Ast.Int)
	| Json -> Ast.Json
	| _ -> Ast.AnyType

let string_to_data_type (s : string) = match s
	with "int" -> Int
	| "float" -> Float
	| "bool" -> Bool
	| "string" -> String
	| "array" -> Array
	| "json" -> Json
	| _ -> raise (Failure "unsupported data type")

let check_binop_type (left_expr : data_type) (op : Ast.math_op) (right_expr : data_type) = match (left_expr, op, right_expr)
	with (Int, _, Int) -> Int
	| (Float, _, Float) -> Float
	| (String, Add, String) -> String
	| (_, _, _) -> raise (Failure "cannot perform binary operations with provided arguments")

(*Possibly add int/float comparison*)
let check_bool_expr_binop_type (left_expr : data_type) (op : Ast.bool_op) (right_expr : data_type) = match op
		with Equal | Neq -> (match (left_expr, right_expr)
			with (Int, Int) -> Bool
			| (Float, Float) -> Bool
			| (String, String) -> Bool
			| (Bool, Bool) -> Bool
			| (AnyType, _) -> Bool
			| (_, AnyType) -> Bool
			| _ -> raise (Failure "cannot perform binary operations with provided arguments")
			)
		| Less | Leq | Greater | Geq -> (match (left_expr, right_expr)
			with (Int, Int) -> Int
			| (Float, Float) -> Float
			| _ -> raise (Failure "cannot perform binary operations with provided arguments")
			)
		| _ -> raise BadBinopType

let rec check_bracket_select_type (d_type : data_type) (selectors : expr list) (env : symbol_table) (id : string) = match d_type
	with Json ->
		List.iter (fun expr ->
			let expr_type = check_expr_type (expr) (env) in
			if expr_type != String && expr_type != Int then raise ImproperBraceSelectorType
		) selectors;
		AnyType
	| Array ->
		if List.length selectors != 1 then raise MultiDimensionalArraysNotAllowed;
		if check_expr_type (List.hd selectors) (env) != Int then raise ImproperBraceSelectorType;
		let ast_array_type = array_type (id) (env) in
		ast_data_to_data ast_array_type
	(* Return the type being stored for this particular array *)
	| _ -> raise ImproperBraceSelection

and check_expr_type (expr : Ast.expr) (env: Environment.symbol_table) = match expr
	with Literal_int(i) -> Int
	| Literal_float(i) -> Float
	| Literal_bool(i) -> Bool
	| Literal_string(i) -> String
	| Literal_array(i) -> Array
	| Json_from_file(i) -> Json
	| Binop(left_expr, op, right_expr) -> check_binop_type (check_expr_type left_expr env) op (check_expr_type right_expr env)
	| Id(i) -> ast_data_to_data((var_type i env))
	| Call(func_name, arg_list) ->
		let arg_types = List.map (fun expr -> (data_to_ast_data((check_expr_type (expr) (env))))) arg_list in
		let func_return_type = func_return_type func_name env in
		ast_data_to_data(func_return_type)
	| Bracket_select(id, selectors) ->
		let selector_ast_data_type = var_type id env in
		let selector_data_type = ast_data_to_data selector_ast_data_type in
		check_bracket_select_type (selector_data_type) (selectors) (env) (id)

let equate e1 e2 =
	if (e1 != e2) && (e1 != AnyType) && (e2 != AnyType) then raise (Failure "data_type mismatch")

let string_data_literal (expr : Ast.expr) = match expr
		with Literal_int(i) -> string_of_int i
	| Literal_float(i) -> string_of_float i
	| Literal_bool(i) -> i
	| Literal_string(i) -> i
	| _ -> raise (Failure "we can't print this")

(* TODO: Get rid of this garbage function. *)
let output_file =
	open_out_gen [Open_creat; Open_text; Open_append] 0o640 "Test.java"

let print_to_file (prog_str : string) =
	let file = output_file in
		Printf.fprintf file "%s" prog_str;;

let print_header (class_name : string) =
	let prog_str = "public class " ^ class_name ^ " { public static void main(String[] args) { " in
	print_to_file prog_str

let handle_print_function (print_term : string) =
	let prog_str = "System.out.println(\"" ^ print_term  ^ "\"); " in
	print_to_file prog_str

let handle_expr_statement (expr : Ast.expr) (env: Environment.symbol_table) = match expr
	with Call(f_name, args) -> (match f_name
		with "print" -> handle_print_function (string_data_literal(List.hd args))
		| _ ->
			let arg_types = List.map (fun expr -> (data_to_ast_data((check_expr_type (expr) (env))))) args in
			verify_func_call f_name arg_types env)
	| _ -> ()

let handle_json (json_expr : Ast.expr) (env : Environment.symbol_table) = match json_expr
	with Id(i) -> (match var_type i env
		with Json -> Json
		| _ -> raise IncorrectWhereType)
	| Json_from_file(json) -> Json
	| _ -> raise IncorrectWhereType

(* This ensures that where_expr is correctly typed and returns AnyType if that check passes *)
let handle_where_expr (where_expr : Ast.where_expr) (env : Environment.symbol_table) =
	AnyType

let rec handle_bool_expr (bool_expr : Ast.bool_expr) (env : Environment.symbol_table) = match bool_expr
	with Literal_bool(i) -> Bool
	| Binop(e1, op, e2) -> (let exists =
		check_bool_expr_binop_type (check_expr_type e1 env) op (check_expr_type e2 env) in
			Bool)
	| Bool_binop(e1, conditional, e2) -> (let isBool1 = handle_bool_expr e1 env and
		isBool2 = handle_bool_expr e2 env in
			Bool)
	| Not(e1) -> (let isBool1 = handle_bool_expr e1 in
					Bool)
	| Id(i) -> (match var_type i env
				with Bool ->
					Bool
				| _ -> raise NotBoolExpr )

(* compile AST to java syntax *)
let rec check_statement (stmt : Ast.stmt) (env : Environment.symbol_table) = match stmt
	with Expr(e1) ->
		handle_expr_statement (e1) (env);
		env
	| Update_variable (id, e1) ->
		let ast_dt = var_type id env in
		let data_type = ast_data_to_data ast_dt in
			let right = check_expr_type (e1) (env) in
				equate data_type right;
				env;
    | If(bool_expr, then_stmt, else_stmt) ->
    	let is_boolean_expr = handle_bool_expr bool_expr env
    	and then_clause = check_statements then_stmt env
    	and else_clause = check_statements else_stmt env in
    		env
	| For(init_stmt, bool_expr, update_stmt, stmt_list) ->
		let init_env = check_statement init_stmt env in
			let is_boolean = handle_bool_expr bool_expr init_env
			and update_env = check_statement update_stmt init_env in
				let body_env = check_statements stmt_list init_env in
					env
	| While(bool_expr, body) ->
		let is_boolean_expr = handle_bool_expr bool_expr env
		and new_env = check_statements body env in
			env
	| Where(where_expr, id, stmt_list, json_object) ->
		let init_env = env in
			let is_where_expr = handle_where_expr where_expr init_env
			and update_env = declare_var id "json" init_env in
				let is_json = handle_json json_object init_env
				and body_env = check_statements stmt_list init_env in
					env
	| Assign(data_type, id, e1) ->
		let left = string_to_data_type(data_type) and right = check_expr_type (e1) (env) in
			equate left right;
			declare_var id data_type env;
	| Array_assign(expected_data_type, id, e1) ->
		let left = data_to_ast_data(string_to_data_type(expected_data_type)) in
			let inferred_type = List.map (fun expr -> data_to_ast_data (check_expr_type (expr) (env))) e1 in
				let declare_var_env = declare_var id "array" env in
					define_array_type (left) (inferred_type) (declare_var_env) (id)
	| Bool_assign(data_type, id, e1) ->
		let left = string_to_data_type(data_type) and right = handle_bool_expr (e1) (env) in
			equate left right;
			declare_var id data_type env;

	| Func_decl(func_name, arg_list, return_type, stmt_list) ->
		let func_env = declare_func func_name return_type arg_list env in
		let func_env_vars = define_func_vars arg_list func_env in
		(* TODO: Implement void functions *)
		if return_type != "void" && List.length arg_list == 0 then
			raise ReturnStatementMissing
		else
			check_function_statements (List.rev stmt_list) func_env_vars return_type;
			func_env
	| _ -> raise (Failure "Unimplemented functionality")

and check_statements stmts env = match stmts
    with [] -> env
  | [stmt] -> check_statement stmt env
  | stmt :: other_stmts ->
  		let env = check_statement stmt env in
  		check_statements other_stmts env

and check_function_statements stmts env return_type = match stmts
    with [] ->
    if return_type != "void" then raise ReturnStatementMissing else
    env
  | [stmt] ->
  	check_return_statement stmt env return_type
  | stmt :: other_stmts ->
  		let env = check_statement stmt env in
  		check_function_statements other_stmts env return_type

and check_return_statement (stmt : Ast.stmt) (env : Environment.symbol_table) (return_type : string) =
	if return_type != "void" then match stmt
		with Return(expr) ->
			let left = string_to_data_type(return_type) and right = check_expr_type (expr) (env) in
				equate left right;
				env
		| _ -> raise (Failure "Function must end with return statement")
	else
		check_statement stmt env

(* entry point into semantic checker *)
let check_program (stmt_list : Ast.program) =
	let env = Environment.create in
	check_statements stmt_list env;

