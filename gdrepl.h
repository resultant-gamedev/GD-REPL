/* gdrepl.h */

#ifndef GD_REPL_H
#define GD_REPL_H

#ifdef GDSCRIPT_ENABLED

#include "dictionary.h"
#include "map.h"
#include "reference.h"
#include "script_language.h"
#include "ustring.h"
#include "variant.h"

#include "modules/gdscript/gd_compiler.h"
#include "modules/gdscript/gd_parser.h"
#include "modules/gdscript/gd_script.h"

#include "scene/main/node.h"

#include "repl_parser.h"

class REPL : public Reference {
	OBJ_TYPE(REPL, Reference);

	ScriptLanguage* m_pScriptLanguage;

	// Script used to store the REPL object's state.
	Ref<Script> m_pScript;

	ScriptInstance* m_pScriptInstance;
	Node* m_pScriptInstanceObject;

	GDParser m_Parser;
	GDCompiler m_Compiler;

protected:
	static void _bind_methods();

public:
	REPL();
	virtual ~REPL();

	// Load a GDScript file, storing its content in the REPL's internal state.
	Error load_file(const String& p_filepath);

	Error load_string(const String& p_code);

	// Load the script code.
	Error reload();

	Variant eval(const String& p_code);
	Variant eval_variable(const String& p_variable);
	Variant eval_function_call(const String& p_function_call);

	Variant eval_expression(const String& p_expression);
	Variant eval_code_block(const String& p_code_block);

	void print_subclasses() const;
	void print_constants() const;
	void print_members() const;
	void print_member_functions() const;

	void print_member_function_code(const String& p_function_name) const;

private:
	Variant eval_function_call_using_node(const REPLParser::FunctionNode* p_node);
	//Variant eval_function_call_using_node(const REPLParser::BuiltInFunctionNode* p_node);

	Variant eval_tree(const REPLParser::Node* p_node);

	// Build a fake tool script to run the expression in a function.
	// The expression is used as the return value of e(), which is called in
	// REPL::eval().
	String build_script(const String& p_text, const bool p_enable_tool_mode = false) const;

	Variant run_script_code(const String& p_script_code);
};

#endif // GDSCRIPT_ENABLED

#endif // GD_REPL_H
