defmodule Elixtagram.API.Users do
  @moduledoc """
  Provides access to the `/users/` area of the Instagram API (for internal use).
  """
  import Elixtagram.API.Base
  import Elixtagram.Parser

  @doc """
  Fetches a list of recent media posted by a user
  """
  def recent_media(user_id, params \\ [], token \\ :global) do
    get("/#{user_id}/media", token, params).data |> Enum.map(&parse_media(&1))
  end

  @doc """
  Fetches a list of recent media posted by a user
  """
  def user(user_id, params \\ [["fields", "account_type,id,media_count,username"]], token \\ :global) do
    get("/#{user_id}", token, params) |> parse_user
  end
end
