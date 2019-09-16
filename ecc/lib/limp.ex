defmodule Limpiador do

  def limpiaEspacios(source) do
    limpio = String.trim(source)
    Regex.split(~r/\s+/, source)
  end

end
