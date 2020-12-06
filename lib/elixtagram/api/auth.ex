defmodule Elixtagram.API.Auth do
  @moduledoc """
  Provides access to the `/users/` area of the Instagram API (for internal use).
  """
  import Elixtagram.API.Base
  import Elixtagram.Parser
  alias Elixtagram.Config

  @doc """
  Fetches a list of recent media posted by a user
  """
  def get_long_lived_token!(token \\ :global) do
    params = [["grant_type", "ig_exchange_token"], ["client_secret", Config.get.client_secret]]
    get("/access_token", token, params)
      |> parse_long_lived_response
  end

  def refresh_long_lived_token!(token \\ :global) do
    params = [["grant_type", "ig_exchange_token"], ["client_secret", Config.get.client_secret]]
    get("/refresh_access_token", token, params)
      |> parse_long_lived_response
  end

  defp parse_long_lived_response(%{
    access_token: long_lived_token,
    token_type: "bearer",
    expires_in: expires_in
  } = body) do
    Elixtagram.Config.set(:access_token, long_lived_token)
    body
  end

  defp parse_long_lived_response(%{
    error: error,
  } = body) do
    body
  end
end
