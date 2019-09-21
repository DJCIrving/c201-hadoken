defmodule Reorganizer do
  def alister(tokens) when tokens != [] do
    #Se organiza como dijo el profesor
    header = hd(tokens)
    footer = tl(tokens)

    if is_list(header) do
      header
    else
      alister(footer)
    end
  end

  def alister(_tokens) do
    []
  end
end
