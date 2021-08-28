defmodule SimpleWeb.LayoutView do
  use Phoenix.View,
    root: "lib/simple_web/templates",
    namespace: SimpleWeb

  use Phoenix.HTML
  alias SimpleWeb.Router.Helpers, as: Routes
end
