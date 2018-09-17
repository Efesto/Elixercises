defprotocol Caesar do
  def encrypt(string, shift)
  def rot13(string)
end

defimpl Caesar, for: List do
  def encrypt(string, shift) do
    Enum.map(string, fn e -> e + shift end)
  end

  def rot13(string) do
    encrypt(string, 13)
  end
end
