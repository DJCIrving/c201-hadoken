defmodule Limpiador do

<<<<<<< HEAD
  def limpiaEspacios(source) do
=======
  def limpiaEspacios(source) do #Quita los espacios en blanco incluyendo saltos de linea y tabuladores
>>>>>>> Removidos archivos del IDE y agregados el generador de c´odigo y el parser
    limpio = String.trim(source)
    Regex.split(~r/\s+/, source)
  end

end
