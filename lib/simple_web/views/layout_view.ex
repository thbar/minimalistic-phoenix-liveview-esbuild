defmodule SimpleWeb.LayoutView do
  use Phoenix.View,
    root: "lib/simple_web/templates",
    namespace: SimpleWeb

  # Use all HTML functionality (forms, tags, etc)
  use Phoenix.HTML

  alias SimpleWeb.Router.Helpers, as: Routes
end
