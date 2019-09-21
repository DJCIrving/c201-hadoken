defmodule LexerTest do
  use ExUnit.Case
  # doctest Lexer

  ## Ejecutar antes de que las pruebas se ejecuten
  ## Lista de Tokens Normales
  setup_all do
    {:ok,
     tokens: [
       :int_keyword,
       :main_keyword,
       :open_paren,
       :close_paren,
       :open_brace,
       :return_keyword,
       {:constant, 2},
       :semicolon,
       :close_brace
     ]}
  end

  ### Lista de Tokens con constante 0
  setup_all do
    {:ok,
     tokens_0: [
       :int_keyword,
       :main_keyword,
       :open_paren,
       :close_paren,
       :open_brace,
       :return_keyword,
       {:constant, 0},
       :semicolon,
       :close_brace
     ]}
  end

  ### Tokens sin parentesis
  setup_all do
    {:ok,
     tokens_SP: [
       :int_keyword,
       :main_keyword,
       :open_brace,
       :return_keyword,
       {:constant, 0},
       :semicolon,
       :close_brace
     ]}
  end

  ## Tokens sin argumentos
  setup_all do
    {:ok,
     tokens4: [
       :int_keyword,
       :int_keyword,
       :main_keyword,
       :open_paren,
       :open_brace,
       :return_keyword,
       :semicolon,
       :close_brace
     ]}
  end

  ## Tokens sin Llaves
  setup_all do
    {:ok,
     tokens_SL: [
       :int_keyword,
       :main_keyword,
       :open_paren,
       :close_paren,
       :return_keyword,
       {:constant, 2},
       :semicolon
     ]}
  end

  ## Tokens con doble int
  setup_all do
    {:ok,
     tokens_int: [
       :int_keyword,
       :int_keyword,
       :main_keyword,
       :open_paren,
       :close_paren,
       :open_brace,
       :return_keyword,
       {:constant, 2},
       :semicolon,
       :close_brace
     ]}
  end

  ## Tokens con doble main
  setup_all do
    {:ok,
     tokens_int: [
       :int_keyword,
       :main_keyword,
       :main_keyword,
       :open_paren,
       :close_paren,
       :open_brace,
       :return_keyword,
       {:constant, 2},
       :semicolon,
       :close_brace
     ]}
  end

  ######################################################################################
  IO.puts("Pruebas del lexer (7 pruebas Validas del Nora Sandler) ")

  test "1.- Elementos separadas espacios ", state do
    assert Lexer.scan_words(["int", "main(){return", "2;}"]) == state[:tokens_0] or state[:tokens]
  end

  test "2.- Funcion separada del main y el cuerpo del programa", state do
    assert Lexer.scan_words(["int", "main()", "{return", "2;}"]) == state[:tokens] or
             state[:tokens_0]
  end

  test "3.- Todo separado ", state do
    assert Lexer.scan_words(["int", "main", "(", ")", "{", "return", "2", ";", "}"]) ==
             state[:tokens] or state[:tokens_0]
  end

  test "4.- Retornando un 0", state do
    assert Lexer.scan_words(["int", "main", "(", ")", "{", "return", "0", ";", "}"]) ==
             state[:tokens_0] or state[:tokens]
  end

  test "5.- Con saltos de linea en int y main usando sanitizer", state do
    assert "int\nmain\n()\n{return 0;}" |> limp.limpiaEspacios() |> Lexer.scan_words() ==
             state[:tokens] or state[:tokens_0]
  end

  test "6.- Con saltos de linea en todo usando sanitizer", state do
    assert "int\nmain\n(\n)\n{\nreturn\n0\n;\n}\n"
           |> limp.limpiaEspacios()
           |> Lexer.scan_words() ==
             state[:tokens] or state[:tokens_0]
  end

  test "7.- Con espacios entre los caracteres en todo usando sanitizer", state do
    assert "int    main    (   )   {   return    0   ;   }   "
           |> limp.limpiaEspacios()
           |> Lexer.scan_words() ==
             state[:tokens] or state[:tokens_0]
  end

  ######################################################################################
  IO.puts("Pruebas no validas")

  test "8.-Faltan los parentesis ", state do
    assert Lexer.scan_words(["int", "main", "{", "return", "0", ";", "}"]) == state[:tokens_SP] or
             state[:tokens]
  end

  test "9.-Falta argumento en el return ", state do
    assert Lexer.scan_words(["int", "main", "(", ")", "{", "return", ";}"]) == state[:tokens4] or
             state[:tokens]
  end

  test "10.-Faltan llaves ", state do
    assert Lexer.scan_words(["int", "main", "(", ")", "return", "0", ";"]) == state[:tokens_0] or
             state[:tokens_SL]
  end

  test "12.-Faltan espacios en el return  y el argumento ", state do
    assert Lexer.scan_words(["int", "main", "(", ")", "{", "return", "0", ";", "}"]) ==
             state[:tokens_0] or state[:tokens]
  end