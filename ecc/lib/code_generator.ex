defmodule CodeGenerator do
  @moduledoc false
  def generateCode(ast) do
    salida = postOrder(ast)
    salida
  end

  def postOrder(ast) do
    case node do
      nil ->
        nil
      node ->
        fragment = postOrder(node.leftNode)
        postOrder(node.rightNode)
        generateFragment(node.id, fragment, node.value)
    end
  end

  def generateFragment(:program, fragment, _) do
    """

        .section    __TEXT,__text,regular,pure_instructions
        .p2align    4, 0x90
    """ <>
    fragment
  end

  def generateFragment(:function, fragment, :main) do
    """

        .globl  _main     ## --Begin fuction main
    _main:                ## @main
    """<>
    fragment
  end

  def generateFragment(:return, fragment, _) do
    """

        movl #{fragment}, %eax
        ret
    """
  end

  def generateFragment(:constant, fragment, value) do
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
