class StaticRender < ActionController::Base

  def self.render_template(template, layout, locals)
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    class << view
      include ApplicationHelper
    end
    view.render(template: "#{template}", locals: locals, layout: layout)
  end

  def self.render_partial(template, layout, locals)
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    class << view
      include Rails.application.routes.url_helpers
      include ApplicationHelper

      def protect_against_forgery?
        false
      end
    end

    view.render(partial: "#{template}", locals: locals, layout: layout)
  end

end
