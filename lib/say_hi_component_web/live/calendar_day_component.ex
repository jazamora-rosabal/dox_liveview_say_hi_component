defmodule SayHiComponentWeb.CalendarDay do
  use SayHiComponentWeb, :live_component
  use Timex

  alias Calendar.Helper

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:day_class, day_class(assigns))
    }
  end

  def render(assigns) do
    ~L"""
    <div
      id="<%= @id %>"
      phx-target="#<%= @parent_id %>"
      phx-click="pick-date"
      phx-value-date="<%= @day |> get_date() %>"
      phx-value-block="<%= is_block?(@day, @current_month, @max_date) %>"
      phx-value-mode="<%= @mode %>"
      x-data="{ startDate: <%= if @mode === :range && @start_date != nil do %> '<%= @start_date |> get_date_to_js() %>' <% else %> null <% end %>,
                endDate: <%= if @mode === :range && @end_date != nil do %> '<%= @end_date |> get_date_to_js() %>' <% else %> null <% end %>,
                mode: '<%= @mode |> Atom.to_string() %>',
                day: '<%= @day |> get_date_to_js() %>',
                parentId: '<%= @parent_id %>',
                showHoverClass() {
                  if(this.mode === 'range' && this.endDate === null && this.startDate != null){
                      let calendar = document.getElementById(this.parentId);
                      if(calendar != null){
                        available_days = calendar.getElementsByClassName('available-day');
                        for(i=0; i< available_days.length; i++){
                          element = document.getElementById(available_days[i].id)
                          dayId = available_days[i].id.split('month-')[1];
                          if(this.isAfterStartDate(dayId) && this.isBeforeThatDate(dayId, this.day)){
                            if(this.isEqualsStartDate(dayId)){
                              element.classList.add('bg-primary-200', 'text-white');
                            }else{
                              element.classList.add('bg-primary-300', 'text-white');
                              element.classList.remove('hover:bg-gray-200');
                            }
                          }else{
                            element.classList.remove('bg-primary-200','bg-primary-300', 'text-white');
                          }
                        }
                      }
                  }
                },
                getValueOfDate(dateString) { return new Date(dateString).valueOf() },
                isEqualsStartDate(day) { return this.getValueOfDate(day) == this.getValueOfDate(this.startDate) },
                isEqualsThatDate(day, hoverDate) { return this.getValueOfDate(day) == this.getValueOfDate(hoverDate)  },
                isAfterStartDate(day) { return this.getValueOfDate(day) >= this.getValueOfDate(this.startDate) },
                isBeforeThatDate(day, hoverDate) { return this.getValueOfDate(day) <= this.getValueOfDate(hoverDate) }
              }"
      @mouseover="showHoverClass()"
      class="text-xs text-center border p-2 w-full <%= @day_class %>"
    >
      <%= Timex.format!(@day, "%e", :strftime) %>
    </div>
    """
  end

  defp day_class(assigns) do
    cond do
      other_month?(assigns) ->
        "border-transparent text-gray-300 cursor-not-allowed"
      after_max_date?(assigns) ->
        "border-transparent text-gray-300 cursor-not-allowed line-through"
      start_date_or_end_date_or_current_date?(assigns) ->
        "border-transparent text-white bg-primary-200 cursor-pointer available-day"
      on_interval?(assigns) ->
        "border-transparent text-white bg-primary-300 cursor-pointer available-day"
      today?(assigns) ->
        "border-dashed border-gray-600 hover:bg-gray-200 cursor-pointer available-day"
      true ->
        "border-transparent text-black bg-white hover:bg-gray-200 cursor-pointer available-day"
    end
  end

  defp start_date_or_end_date_or_current_date?(assigns) do
    if assigns.mode === :range do
      (assigns.start_date !== nil && Map.take(assigns.day, [:year, :month, :day]) == Map.take(assigns.start_date, [:year, :month, :day])) ||
      (assigns.end_date !== nil && Map.take(assigns.day, [:year, :month, :day]) == Map.take(assigns.end_date, [:year, :month, :day]))
    else
      assigns.date !== nil && Map.take(assigns.day, [:year, :month, :day]) == Map.take(assigns.date, [:year, :month, :day])
    end
  end

  defp on_interval?(assigns) do
    if assigns.mode === :range && assigns.interval !== nil && other_month?(assigns) === false, do: assigns.day in assigns.interval, else: false
  end

  defp today?(assigns) do
    assigns.day |> Helper.today?(assigns.time_zone)
  end

  defp other_month?(assigns) do
    other_month?(assigns.day, assigns.current_month)
  end

  defp other_month?(day, current_month) do
    Map.take(day, [:year, :month]) != Map.take(current_month, [:year, :month])
  end

  defp after_max_date?(assigns) do
    after_max_date?(assigns.day, assigns.max_date)
  end

  defp after_max_date?(day, max_date) do
    if max_date !== nil, do: day |> Timex.after?(max_date), else: false
  end

  defp get_date(date) do
    Timex.format!(date, "%FT%T", :strftime)
  end

  defp get_date_to_js(date) do
    Timex.format!(date, "%m/%d/%Y", :strftime)
  end

  def is_block?(day, current_month, max_date) do
    after_max_date?(day, max_date) || other_month?(day, current_month)
  end
end
