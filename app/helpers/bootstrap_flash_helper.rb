module BootstrapFlashHelper
  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      type = :success if type == :notice
      type = :error   if type == :alert
      text = content_tag :div, :class => "alert fade in alert-#{type}" do
        link_to("x", "#", :class => "close", "data-dismiss" => "alert") +
        message
      end
      flash_messages << text if message
    end
    flash_messages.join("\n").html_safe
  end
end
