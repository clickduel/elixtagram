defmodule Elixtagram do
  @moduledoc """
  Provides access to the Instagram API.
  """

  @doc """
  Initialises and configures Elixtagram with a `client_id`,
  `client_secret` and `redirect_uri`. If you're not doing
  anything particularly interesting here, it's better to
  set them as environment variables and use `Elixtagram.configure/0`

  ## Example
      iex(1)> Elixtagram.configure("XXXX", "XXXX", "localhost:4000")
      {:ok, []}
  """
  defdelegate configure(client_id, client_secret, redirect_uri), to: Elixtagram.Config, as: :configure

  @doc """
  Initialises Elixtagram with system environment variables.
  For this to work, set `INSTAGRAM_CLIENT_ID`, `INSTAGRAM_CLIENT_SECRET`
  and `INSTAGRAM_REDIRECT_URI`.

  ## Example
      INSTAGRAM_CLIENT_ID=XXXX INSTAGRAM_CLIENT_SECRET=XXXX INSTAGRAM_REDIRECT_URI=localhost iex
      iex(1)> Elixtagram.configure
      {:ok, []}
  """
  defdelegate configure, to: Elixtagram.Config, as: :configure

  @doc """
  Sets a global user authentication token, this is useful for scenarios
  where your app will only ever make requests on behalf of one user at
  a time.

  ## Example
      iex(1)> Elixtagram.configure(:global, "MY-TOKEN")
      :ok
  """
  defdelegate configure(scope, token), to: Elixtagram.Config, as: :configure

  @doc """
  Returns the url you will need to redirect a user to for them to authorise your
  app with their Instagram account. When they log in there, you will need to
  implement a way to catch the code in the request url (they will be redirected back
  to your `INSTAGRAM_REDIRECT_URI`).

  **Note: This method authorises only 'basic' scoped permissions [(more on this)](https://instagram.com/developer/authentication).**

  ## Example
      iex(8)> Elixtagram.authorize_url!
      "https://api.instagram.com/oauth/authorize/?client_id=XXX&redirect_uri=localhost%3A4000&response_type=code"
  """
  defdelegate authorize_url!, to: Elixtagram.OAuthStrategy, as: :authorize_url!

  @doc """
  Returns the url to redirect a user to when authorising your app to use their
  account. Takes a list of permissions scopes as `atom` to request from Instagram.

  Available options: `:comments`, `:relationships` and `:likes`

  ## Example
      iex(1)> Elixtagram.authorize_url!([:comments, :relationships])
      "https://api.instagram.com/oauth/authorize/?client_id=XXX&redirect_uri=localhost%3A4000&response_type=code&scope=comments+relationships"
  """
  defdelegate authorize_url!(scope), to: Elixtagram.OAuthStrategy, as: :authorize_url!

  @doc """
  Returns the url to redirect a user to when authorising your app to use their
  account. Takes a list of permissions scopes as `atom` to request from Instagram, as well as
  a 'state', this is an optional query param that will be passed back to your application's
  callback url.

  Available scopes: `:comments`, `:relationships` and `:likes`

  ## Example
      iex(1)> Elixtagram.authorize_url!([:comments, :relationships], "somevalue")
      "https://api.instagram.com/oauth/authorize/?client_id=XXX&redirect_uri=localhost%3A4000&response_type=code&scope=comments+relationships&state=somevalue"
  """
  defdelegate authorize_url!(scope, state), to: Elixtagram.OAuthStrategy, as: :authorize_url!

  @doc """
  Takes a `keyword list` containing the code returned from Instagram in the redirect after
  login and returns a `{:ok, access_token}` for making authenticated requests.
  If you pass an incorrect code, it will return you an `{:error, reason}`

  ## Example
      iex(1)> Elixtagram.get_token!(code: code)
      {:ok, "XXXXXXXXXXXXXXXXXXXX"}
  """
  def get_token!(code) do
    case Elixtagram.OAuthStrategy.get_token!(code) do
      %{token: %{other_params: %{"code" => 400, "error_message" => error_message}}} ->
        {:error, error_message}
      %{token: %{access_token: access_token}} ->
        {:ok, access_token}
      _ ->
        {:error, "Something went wrong fetching the token..."}
    end
  end

  @doc """
  Requests a long lived token from instagram

  ## Example
      iex(1)> Elixtagram.get_long_lived_token!()
      {:ok, "XXXXXXXXXXXXXXXXXXXX"}
  """
  defdelegate get_long_lived_token!(token), to: Elixtagram.API.Auth, as: :get_long_lived_token!

  @doc """
  Refreshes a long lived token from instagram

  ## Example
      iex(1)> Elixtagram.get_long_lived_token!()
      {:ok, "XXXXXXXXXXXXXXXXXXXX"}
  """
  defdelegate refresh_long_lived_token!(token), to: Elixtagram.API.Auth, as: :refresh_long_lived_token!

  ## ---------- Media

  @doc """
  Takes a media id and returns a `%Elixtagram.Model.Media`

  ## Example
      iex(1)> Elixtagram.media("XXXXXXXXXXXXXXXXXXXX")
      %Elixtagram.Model.Media{...}
  """
  defdelegate media(media_id), to: Elixtagram.API.Media, as: :media

  @doc """
  Takes a media id and an access token, returns a `%Elixtagram.Model.Media`

  ## Example
      iex(1)> Elixtagram.media("XXXXXXXXXXXXXXXXXXXX", token)
      %Elixtagram.Model.Media{...}
  """
  defdelegate media(media_id, token), to: Elixtagram.API.Media, as: :media

  ## ---------- Users

  @doc """
  Takes a user id and returns a `%Elixtagram.Model.User`.

  ## Examples
      iex(1)> Elixtagram.user(35822824)
      %Elixtagram.Model.User{bio: "🌷 Whole Food Plant Based Nutrition\n🏂 Powerful Functional Strength & Fitness\n🌏 Digital Nomad\n🐈 Animal Lover\n😸Berlin♨️Chiang Mai🇦🇺Brisbane",
      counts: %{followed_by: 3966, follows: 4915, media: 613}, full_name: "Zen Savona", id: "35822824", profile_picture: "https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-19/s150x150/11856601_1483869585265582_942748740_a.jpg", username: "zenm8", website: "http://zen.id.au"}
  """
  defdelegate me(token), to: Elixtagram.API.Users, as: :user

  @doc """
  Takes a user id and returns a `%Elixtagram.Model.User`.

  ## Examples
      iex(1)> Elixtagram.user(35822824)
      %Elixtagram.Model.User{bio: "🌷 Whole Food Plant Based Nutrition\n🏂 Powerful Functional Strength & Fitness\n🌏 Digital Nomad\n🐈 Animal Lover\n😸Berlin♨️Chiang Mai🇦🇺Brisbane",
      counts: %{followed_by: 3966, follows: 4915, media: 613}, full_name: "Zen Savona", id: "35822824", profile_picture: "https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-19/s150x150/11856601_1483869585265582_942748740_a.jpg", username: "zenm8", website: "http://zen.id.au"}
  """
  defdelegate user(user_id), to: Elixtagram.API.Users, as: :user

  @doc """
  Takes a user id or `:self` and an access token (or `:global`, if a global access token has been set with `Elixtagram.configure(:global, token)`) and returns a `%Elixtagram.Model.User`.


  ## Examples
      iex(1)> Elixtagram.user(35822824, token)
      %Elixtagram.Model.User{bio: "🌷 Whole Food Plant Based Nutrition\n🏂 Powerful Functional Strength & Fitness\n🌏 Digital Nomad\n🐈 Animal Lover\n😸Berlin♨️Chiang Mai🇦🇺Brisbane",
      counts: %{followed_by: 3966, follows: 4915, media: 613}, full_name: "Zen Savona", id: "35822824", profile_picture: "https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-19/s150x150/11856601_1483869585265582_942748740_a.jpg", username: "zenm8", website: "http://zen.id.au"}

      iex(2)> Elixtagram.user(:self, token)
      %Elixtagram.Model.User{...}

      iex(3)> Elixtagram.user(:self, :global)
      %Elixtagram.Model.User{...}
  """
  defdelegate user(id, params, token), to: Elixtagram.API.Users, as: :user

  @doc """
  Takes a user id and a params Map, returns a List of media as `%Elixtagram.Model.Media`

  Search params:

  * count
  * min_id
  * max_id
  * min_timestamp
  * max_timestamp

  ## Example
      iex(1)> Elixtagram.user_recent_media(35822824, %{count: 2})
      [%Elixtagram.Model.Media{...}, %Elixtagram.Model.Media{...}]
  """
  defdelegate user_recent_media(user_id, params), to: Elixtagram.API.Users, as: :recent_media

  @doc """
  Takes a user id (or `:self`, to get media for the user associated with the token) a params Map and access token (or `:global` if a global token has been configured).
  Returns a List of media as `%Elixtagram.Model.Media`.

  Search params:

  * count
  * min_id
  * max_id
  * min_timestamp
  * max_timestamp

  ## Example
      iex(1)> Elixtagram.user_recent_media(35822824, %{count: 2}, :global)
      [%Elixtagram.Model.Media{...}, %Elixtagram.Model.Media{...}]
  """
  defdelegate user_recent_media(user_id, params, token), to: Elixtagram.API.Users, as: :recent_media

  @doc """
  Takes a user id ( or `:self`, to get media for the user associated with the token) a params Map and access token ( or `:global` if a global token has been configured).
  Returns a Map with `:data` that contains a List of `%Elixtagram.Model.Media` and `:pagination' Map with the following keys:
   `:next_url` - A url to retrieve the next page of results
   `:next_max_id` - the `:max_id` to be used to retrieve the next page of results

   # Optional params:
     * count
     * min_id
     * max_id
     * min_timestamp
     * max_timestamp

   ## Example
       iex(1)> Elixtagram.user_recent_media_with_pagination(35822824, %{count: 128}, :global)
       %{data: [%Elixtagram.Model.Media{...}, %Elixtagram.Model.Media{...}], pagination: %{next_url: "https://api.instagram.com...", next_max_id: "1285565194378201229_1480448198"}}
  """
  defdelegate user_recent_media_with_pagination(user_id, params, token), to: Elixtagram.API.Users, as: :recent_media_with_pagination

    @doc """
    Takes a user id ( or `:self`, to get media for the user associated with the token) a params Map
    Returns a Map with `:data` that contains a List of `%Elixtagram.Model.Media` and `:pagination' Map with the following keys:
     `:next_url` - A url to retrieve the next page of results
     `:nex_max_id` - the `:max_id` to be used to retrieve the next page of results

    # Optional params:
      * count
      * min_id
      * max_id
      * min_timestamp
      * max_timestamp

     ## Example
         iex(1)> Elixtagram.user_recent_media_with_pagination(35822824, %{count: 128})
         %{data: [%Elixtagram.Model.Media{...}, %Elixtagram.Model.Media{...}], pagination: %{next_url: "https://api.instagram.com...", next_max_id: "1285565194378201229_1480448198"}}
    """
    defdelegate user_recent_media_with_pagination(user_id, params), to: Elixtagram.API.Users, as: :recent_media_with_pagination
end
