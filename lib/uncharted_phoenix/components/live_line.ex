defmodule UnchartedPhoenix.LiveLineComponent do
  @moduledoc """
  Line Chart Component
  """

  use Phoenix.LiveComponent

  def mount(socket) do
    {:ok, assign(socket, :show_table, false)}
  end

  def update(assigns, socket) do
    x_axis = assigns.chart.dataset.axes.x
    y_axis = assigns.chart.dataset.axes.y
    # Hardcode the number of steps to take as 5 for now
    x_grid_lines = x_axis.grid_lines.({x_axis.min, x_axis.max}, 5)
    x_grid_line_offsetter = fn grid_line -> 100 * grid_line / x_axis.max end

    y_grid_lines = y_axis.grid_lines.({y_axis.min, y_axis.max}, 5)
    y_grid_line_offsetter = fn grid_line -> 100 * (y_axis.max - grid_line) / y_axis.max end

    socket =
      socket
      |> assign(:chart, assigns.chart)
      |> assign(:points, Uncharted.LineChart.points(assigns.chart))
      |> assign(:lines, Uncharted.LineChart.lines(assigns.chart))
      |> assign(:x_grid_lines, x_grid_lines)
      |> assign(:x_grid_line_offsetter, x_grid_line_offsetter)
      |> assign(:x_axis, x_axis)
      |> assign(:y_grid_lines, y_grid_lines)
      |> assign(:y_grid_line_offsetter, y_grid_line_offsetter)
      |> assign(:y_axis, y_axis)
      |> assign(:show_gridlines, assigns.chart.dataset.axes.show_gridlines)
      |> assign(:always_show_table, assigns.always_show_table)
      |> assign(:width, assigns.chart.width || 700)
      |> assign(:height, assigns.chart.height || 400)

    {:ok, socket}
  end

  def render(assigns) do
    Phoenix.View.render(UnchartedPhoenix.ComponentView, "live_line.html", assigns)
  end

  def handle_event("show_table", _, socket) do
    {:noreply, assign(socket, :show_table, true)}
  end

  def handle_event("hide_table", _, socket) do
    {:noreply, assign(socket, :show_table, false)}
  end
end
