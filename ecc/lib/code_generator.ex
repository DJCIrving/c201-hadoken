defmodule CodeGenerator do
  @moduledoc false
  def generate_code(ast) do
    salida = post_order(ast)
    salida
  end

  def post_order(ast) do
    case node do
      nil ->
        nil
      node ->
        fragment = post_order(node.left_node)
        post_order(node.right_node)
        generate_fragment(node.id, fragment, node.value)
    end
  end

  def generate_fragment(:program, fragment, _) do
    """

        .section    __TEXT,__text,regular,pure_instructions
        .p2align    4, 0x90
    """ <>
    fragment
  end

  def generate_fragment(:function, fragment, :main) do
    """

        .globl  _main     ## --Begin fuction main
    _main:                ## @main
    """<>
    fragment
  end

  def generate_fragment(:return, fragment, _) do
    """

        movl #{fragment}, %eax
        ret
    """
  end

  def generate_fragment(:constant, fragment, value) do
    "$#{value}"
  end

  #Para cualquier funcion que no sea la principal
  #def generateFragment(:function, fragment, name) do
  # """
  #
  #        .globl  _#{name}    ## --Begin fuction #{name}
  #    _#{name}:                ## @#{name}
  #    """<>
  #    fragment
  #end
end
