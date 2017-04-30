if Rails.env.in?(%w(staging production))
  PumaWorkerKiller.enable_rolling_restart
end
