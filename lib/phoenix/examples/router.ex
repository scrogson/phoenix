defmodule Router do
  use Phoenix.Router, port: 4000

  use Phoenix.Plugs.CodeReloader
  use Phoenix.Plugs.Logger

  get "pages/:page", Controllers.Pages, :show, as: :page
  get "files/*path", Controllers.Files, :show, as: :file
  get "profiles/user-:id", Controllers.Users, :show

  resources "users", Controllers.Users do
    resources "comments", Controllers.Comments
  end
end
