extends EditorPlugin

# Constants


# Attributes

var m_REPL = null

var m_Variables = null
var m_Functions = null

# Methods

func _ready():
	init()
	set_focus_to_code_input()

	run_examples()

	pass


func init():
	m_REPL = REPL.new()

	m_Variables = {}
	m_Functions = {}

	get_node("VBoxContainer/CodeText").set_text("")
	get_node("VBoxContainer/OutputText").set_text("")


func run():
	repl_loop()


func repl_read():
	return get_node("VBoxContainer/CodeText").get_text()


func repl_eval(expression):
	var result = m_REPL.eval_expression(expression)

	return result


func repl_print(results):
	get_node("VBoxContainer/OutputText").set_text(results)


func repl_loop(expression):
	while (true):
		var expression = repl_read()
		var results = repl_eval(expression)
		repl_print(str(results))


func set_focus_to_code_input():
	get_node("VBoxContainer/CodeText").grab_focus()


func _on_ButtonExpression_pressed():
	#repl_loop(repl_read())
	var expression = repl_read()
	var results = m_REPL.eval_expression(expression)
	repl_print(str(results))


func _on_ButtonCodeBlock_pressed():
	#repl_loop(repl_read())
	var code_block = repl_read()
	var results = m_REPL.eval_code_block(code_block)
	repl_print(str(results))


func run_examples():
	# eval_expression()
	print("\n#####\n")
	print("EVAL_EXPRESSION()")
	print(str(m_REPL.eval_expression("10 * cos(PI)")))

	var v1 = [1, 2, 3]
	print(typeof(v1))

	var v2 = m_REPL.eval_expression("[1, 2, 3]")
	print(typeof(v2))
	for i in v2:
		print(i, " ")

	#eval_code_block()
	print("\n#####\n")
	print("EVAL_CODE_BLOCK()")
	print(str(m_REPL.eval_code_block("""
for i in range(0, 2):
	for j in range(3, 5):
		print(j)
	print(i)

var v = []
for i in range(0, 5):
	v.push_back(i)
print(str(v))
""")))

	#eval_code_block()
	print("\n#####\n")
	print("LOAD_FILE()")
	if (m_REPL.load_file("res://example.gd") == OK):
		print("File loaded.")
		m_REPL.print_subclasses()
		m_REPL.print_constants()
		m_REPL.print_members()
		m_REPL.print_member_functions()
		m_REPL.print_member_function_code("print_constants")

	print("\n#####\n")
	print("EVAL_VARIABLE()")
	print(m_REPL.eval_variable("m_DefaultValue"))
	print(m_REPL.eval_variable("m_Foo"))
	print(m_REPL.eval("m_Foo"))
