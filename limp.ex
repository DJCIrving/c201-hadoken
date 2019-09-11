defmodule Limpiador do

  def recibeCodigo do  #Esta función recibirá el archivo de texto
    "int main() {\nreturn 2;\n}" #no es necesario un return, se retorna la ultima linea
  end

  def creaToken do  #función que creará la lista de tokens
    codEntrada = recibeCodigo()
    tokens = String.split(codEntrada, ~r{\s+}) # Se corta la cadena cumpliendo la expresion reg
  tokens # Se imprime la lista de tokens
  end

end
