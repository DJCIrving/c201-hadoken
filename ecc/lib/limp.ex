defmodule Limpiador do
  @moduledoc false
  def limpia_espacios(source) do #Quita los espacios en blanco incluyendo saltos de linea y tabuladores
    limpio = String.trim(source)
    Regex.split(~r/\s+/, source)
  end

end
