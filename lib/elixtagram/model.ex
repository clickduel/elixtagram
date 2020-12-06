defmodule Elixtagram.Model.ClientConfig do
  defstruct client_id: nil, client_secret: nil, redirect_uri: nil, access_token: nil
end

defmodule Elixtagram.Model.Response do
  defstruct data: nil
end

# defmodule Elixtagram.Model.Tag do
#   defstruct name: nil, media_count: nil
# end

# caption
# The Media's caption text. Not returnable for Media in albums.
# id
# The Media's ID.
# media_type
# The Media's type. Can be IMAGE, VIDEO, or CAROUSEL_ALBUM.
# media_url
# The Media's URL.
# permalink
# The Media's permanent URL. Will be omitted if the Media contains copyrighted material, or has been flagged for a copyright violation.
# thumbnail_url
# The Media's thumbnail image URL. Only available on VIDEO Media.
# timestamp
# The Media's publish date in ISO 8601 format.
defmodule Elixtagram.Model.Media do
  defstruct caption: nil, id: nil, media_type: nil, media_url: nil, permalink: nil, thumbnail_url: nil, timestamp: nil, username: nil
end

# defmodule Elixtagram.Model.Location do
#   defstruct id: nil, name: nil, latitude: nil, longitude: nil
# end

defmodule Elixtagram.Model.User do
  defstruct id: nil, username: nil, account_type: nil, media_count: nil
end

# defmodule Elixtagram.Model.UserSearchResult do
#   defstruct id: nil, username: nil, full_name: nil, profile_picture: nil
# end

# defmodule Elixtagram.Model.Comment do
#   defstruct id: nil, created_time: nil, text: nil, from: nil
# end

# defmodule Elixtagram.Model.Relationship do
#   defstruct incoming_status: nil, outgoing_status: nil, target_user_is_private: nil
# end
