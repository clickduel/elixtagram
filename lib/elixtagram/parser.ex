defmodule Elixtagram.Parser do

  def parse_media(object) do
    struct(Elixtagram.Model.Media, object)
  end

  def parse_user(object) do
    struct(Elixtagram.Model.User, object)
  end

  @doc """
  Parse request parameters for the API.
  """
  def parse_request_params(options, accepted) do
    Enum.filter_map(options, fn({k,_}) -> Enum.member?(accepted, k) end, fn({k,v}) -> [to_string(k), to_string(v)] end)
  end
end
