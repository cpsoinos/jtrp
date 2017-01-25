class PassthroughController < ApplicationController

  def index
    if current_user.try(:internal?)
      redirect_to dashboard_path
    else
      redirect_to landing_page_path
    end
  end

  def sitemap
    redirect_to "https://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com/sitemaps/sitemap.xml.gz"
  end

end
