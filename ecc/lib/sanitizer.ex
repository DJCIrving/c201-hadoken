defmodule Sanitizer do
  @moduledoc false
  def clean_spaces(source) do #Quita los espacios en blanco incluyendo saltos de linea y tabuladores
    cleaned = String.trim(source)
    Regex.split(~r/\s+/, source)
  end

end
