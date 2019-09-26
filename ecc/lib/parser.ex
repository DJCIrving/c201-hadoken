defmodule Parser do
  @moduledoc """
    <program> ::= <function>
    <function> ::= "int" <id> "(" ")" "{" <statement> "}"
    <statement> ::= "return" <exp> ";"
    <exp> ::= <term> { ("+" | "-") <term> }
    <term> ::= <factor> { ("*" | "/") <factor> }
    <factor> ::= "(" <exp> ")" | <unary_op> <factor> | <int>
    """
  def parse_program(token_list) do
    function = parse_function(token_list,0)
    case function do
      {{:error,error_message,linea,problem}, _rest} ->
        {:error, error_message, linea,problem}

      {function_node, rest} ->
        if rest == [] do
          %AST{node_name: :program, left_node: function_node}
        else
          {:error, "Error: hay mas elementos al final de la funcion",0,"mas elementos"}
        end
    end
  end

  def parse_function([{next_token,num_line} | rest],count) do
    if rest != [] do
      case count do
        0->
          if next_token == :int_keyword do
            count = count + 1
            parse_function(rest,count)
          else
            {{:error, "Error #1",num_line,next_token},rest}
          end
        1->
          if next_token == :main_keyword do
            count = count + 1
            parse_function(rest,count)
          else
            {{:error, "Error, #2",num_line,next_token},rest}
          end
        2->
          if next_token == :open_paren do
            count = count + 1
            parse_function(rest,count)
          else
            {{:error, "Error, #3",num_line,next_token},rest}
          end
        3->
          if next_token == :close_paren do
            count = count + 1
            parse_function(rest,count)
          else
            {{:error, "Error, #4",num_line,next_token},rest}
          end
        4->
          if next_token == :open_brace do
            statement = parse_statement(rest)
            case statement do
              {{:error, error_message,num_line,next_token}, rest} ->
                {{:error, error_message,num_line,next_token}, rest}

              {statement_node,remaining_list} ->
                [{next_token,num_line}|rest]=remaining_list
                if next_token == :close_brace do
                  {%AST{node_name: :function, value: :main, left_node: statement_node}, rest}
                else
                  {{:error, "Error #5",num_line,next_token}, rest}
                end
            end
          end
        end
      else
        {{:error, "Error #6",num_line,next_token}, []}
      end
  end

  def parse_statement([{next_token,num_line} | rest]) do
      if next_token == :return_keyword do
        expression = parse_expression(rest,1)
        case expression do
          {{:error, error_message,num_line,next_token}, rest} ->
            {{:error, error_message,num_line,next_token}, rest}

          {exp_node,remaining_list} ->
            [{next_token,num_line}|rest]=remaining_list
            if next_token == :semicolon do
              {%AST{node_name: :return, left_node: exp_node}, rest}
            else
              {{:error, "Error #7",num_line,next_token}, rest}
            end
        end
      else
        {{:error, "Error #8",num_line,next_token}, rest}
      end
  end

  def parse_expression(token_list, cExp) do
    [{next_token,num_line} | rest]=token_list

      term = parse_term(token_list,1)
      {expression_node,remaining_list}=term
      [{next_tok,num_line}|rest]=remaining_list
      case next_tok do
      :addition ->
        sTree=%AST{node_name: :addition}
        top = parse_expression(rest,1)
        {node,remaining_list}=top
        [{next_tok,num_line}|restop]=remaining_list
        {%{sTree | left_node: expression_node, right_node: node }, remaining_list}
      :negative_keyword->
        sTree=%AST{node_name: :rest}
        top = parse_expression(rest,1)
        {node,remaining_list}=top
      [{next_tok,num_line}|restop]=remaining_list
      {%{sTree | left_node: expression_node, right_node: node }, remaining_list}
      _->
      term
    end
  end

  def parse_term(ast, cTerm) do
    [{next_token,num_line} | rest]=ast
          factor = parse_factor(ast)
          {expression_node,remaining_list}=factor
          [{sig_tok,num_line}|rest]=remaining_list
          case sig_tok do
          :multiplication ->
              sTree=%AST{node_name: :multiplication}
              top = parse_expression(rest,1)
              {node,remaining_list}=top
              [{sig_tok,num_line}|restop]=remaining_list
              {%{sTree | left_node: expression_node, right_node: node }, remaining_list}
            :division->
              sTree=%AST{node_name: :division}
              top = parse_expression(rest,1)
              {node,remaining_list}=top
              [{sig_tok,num_line}|restop]=remaining_list
              {%{sTree | left_node: expression_node, right_node: node }, remaining_list}
          _->
            factor
          end
  end

  def parse_factor(ast) do
      [{next_token,num_line} | rest]=ast
      case next_token do
        :open_paren->
          if next_token==:open_paren do
            expression=parse_expression(rest,1)
            case expression do
              {{:error, error_message}, rest} ->
                  {{:error, error_message}, rest}

              {expression_node,remaining_list} ->
                    [{next_token,num_line}|rest]=remaining_list
                if next_token == :close_paren do
                    {expression_node, rest}
                  else
                    express=parse_expression(rest,1)
                    {node_expression,remaining_list_expression}=expression
                    {node,remaining_list_node}=express
                    [_|lista_sin_open_parent]=remaining_list_node
                    {%{node_expression | left_node: node}, lista_sin_open_parent}
                  end
            end
          else
            {{:error, "Error: factor '(' ",num_line,next_token}, rest}
          end
          :complement_keyword->
        unary_op([{next_token,num_line} | rest])
          :negative_keyword->
        unary_op([{next_token,num_line} | rest])
          :negative_logical ->
        unary_op([{next_token,num_line} | rest])

        {:constant, value} ->

          {%AST{node_name: :constant, value: value}, rest}
        _->
        {{:error, "Error: factor (mas elementos)",num_line,next_token}, rest}

      end
  end

  def unary_op([{next_token,num_line} | rest]) do
    case next_token do
      :negative_keyword ->
        parexpres=parse_factor(rest)
        {nodo,rest_necesario}=parexpres
        {%AST{node_name: :unary_negative, left_node: nodo}, rest_necesario}
      :complement_keyword ->
        parexpres=parse_factor(rest)
        {nodo,rest_necesario}=parexpres
        {%AST{node_name: :unary_complement, left_node: nodo}, rest_necesario}
      :negative_logical ->
        parexpres=parse_factor(rest)
        {nodo,rest_necesario}=parexpres
        {%AST{node_name: :negative_logical, left_node: nodo}, rest_necesario}
      _ -> {{:error, "Error en arbol 1",num_line,next_token}, rest}
    end
  end
end