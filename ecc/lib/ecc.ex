defmodule Compilers do
  @moduledoc """
  Documentation for Compilador
  """
  @commands %{
    "help" => "Help",
    "t" => "Lexer",
    "a" => "Parser",
    "s" => "Assembly",
    "o  nombre_ejecutable" => "Cambio nombre ejecutable"
  }

  def main(args) do
    args
    |> parse_args()
    |> process_args()
  end

  def parse_args(args) do
    OptionParser.parse(args, switches: [help: :boolean])
  end

  defp process_args({[help: true], _, _}) do
    print_help_message()
  end

  defp process_args({_, [file_name], _}) do
    compile_file(file_name)
  end

  defp process_args({_, ["t", file_name], _}) do
    print_token_list(file_name)
  end

  defp process_args({_, ["a", file_name], _}) do
    print_ast(file_name)
  end

  defp process_args({_, ["s", file_name], _}) do
    print_assembler(file_name)
  end

  defp process_args({_, ["t", "a", file_name], _}) do
    print_token_list(file_name)
    print_ast(file_name)
  end

  defp process_args({_, ["a", "t", file_name], _}) do
    print_ast(file_name)
    print_token_list(file_name)
  end

  defp process_args({_, ["a", "s", file_name], _}) do
    print_ast(file_name)
    print_assembler(file_name)
  end

  defp process_args({_, ["s", "a", file_name], _}) do
    print_assembler(file_name)
    print_ast(file_name)
  end

  defp process_args({_, ["t", "s", file_name], _}) do
    print_token_list(file_name)
    print_assembler(file_name)
  end

  defp process_args({_, ["s", "t", file_name], _}) do
    print_assembler(file_name)
    print_token_list(file_name)
  end

  defp compile_file(file_path) do
    IO.puts("Compiling file: " <> file_path)
    assembly = String.replace_trailing(file_path, ".c", ".s")

    listaTokens =
      File.read!(file_path)
      |> Limpiador.limpiaEspacios()
      |> IO.inspect(label: "\nSanitizer output")
      |> Lexer.scan_words()
      |> IO.inspect(label: "\nLexer output")

    filtro = Reorganizer.alister(listaTokens)

    if filtro == [] do
      tree =
        listaTokens
        |> Parser.parse_program()
        |> IO.inspect(label: "\nParser output")

      if is_map(tree) do
        tree
        |> CodeGenerator.generateCode()
        |> IO.inspect(label: "\nGenertor output")
        |> Linker.generate_binary(assembly)
      else
        IO.puts("Error de Sintáxis")
      end
    else
      IO.puts("Error Léxico")
      IO.puts("Error: elemento no reconocido")
      IO.inspect(filtro)
    end
  end

  defp print_token_list(file_path) do
    IO.puts("Compiling file: " <> file_path)

    File.read!(file_path)
    |> Limpiador.limpiaEspacios()
    |> Lexer.scan_words()
    |> IO.inspect(label: "\nLexer output")
  end

  defp print_ast(file_path) do
    IO.puts("Compiling file: " <> file_path)

    File.read!(file_path)
    |> Limpiador.limpiaEspacios()
    |> Lexer.scan_words()
    |> Parser.parse_program()
    |> IO.inspect(label: "\nParser output")
  end

  defp print_assembler(file_path) do
    IO.puts("Compiling file: " <> file_path)

    File.read!(file_path)
    |> Limpiador.limpiaEspacios()
    |> Lexer.scan_words()
    |> Parser.parse_program()
    |> CodeGenerator.generateCode()
    |> IO.inspect(label: "\nCode_Genertor output")
  end

  defp print_help_message do
    IO.puts("\nCompilator --help file_name \n")

    IO.puts("\nPuede utilizar las siguientes banderas en este compilador:\n")

    @commands
    |> Enum.map(fn {command, description} -> IO.puts("  #{command} - #{description}") end)
  end

  def parser_test(file_path) do
    File.read!(file_path)
    |> Limpiador.limpiaEspacios()
    |> Lexer.scan_words()
   #  |> Parser.parse_program()
   end


end
