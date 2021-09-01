defmodule SayHiComponentWeb.SayHi do
  use SayHiComponentWeb, :live_component
  require Logger

  @impl true
  def mount(socket) do
    {:ok, socket |> assign(name: nil)}
  end

  @impl true
  def render(assigns) do
    ~L"""
      <div>
      <button type="button" phx-click="say_hi" phx-target="<%= @myself %>"
      class="bg-primary-200 p-2 text-white block px-4 py-2 text-sm leading-5 hover:bg-primary-300 focus:outline-none focus:bg-gray-100 focus:text-gray-900"
      >Say hi!!</button>
      <p><%= if @name != nil, do: @name %></p>
      </div>
    """
  end

  @impl true
  def handle_event("say_hi", _, socket) do
    Logger.debug("Evento disparado para saludar")

    {:noreply,
     socket
     |> assign(:name, "Julio")}
  end
end
