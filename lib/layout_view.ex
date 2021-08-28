defmodule SimpleWeb.LayoutView do
  use Phoenix.View,
    root: "lib/templates",
    namespace: SimpleWeb

  use Phoenix.HTML
  alias SimpleWeb.Router.Helpers, as: Routes
end
