defmodule HumanBeing do
  defstruct name: "", lastname: "", has_beard: false

  def is_a_lumberjack?(human_being) do
    human_being.has_beard && (human_being.lastname == 'Lumberjack' || human_being.name == 'Lumberjack')
  end
end