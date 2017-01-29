def set_clover_headers
  # { "CONTENT_TYPE" => "application/json", "X-Clover-Auth Code" => "sample-clover-auth-code" }
  @request.env['X-Clover-Auth Code'] = ENV['CLOVER_WEBHOOK_AUTH_CODE'] || 'sample-clover-auth-code'
end
