require 'rest-client'

class  CdrBilling < Pgq::ConsumerGroup
  AVAILABLE_HTTP_METHODS = [:post, :put, :get, :patch]

  @consumer_name = 'cdr_billing'

  def perform_events(events)
    group = []
    events.each do |event|
      group << event.data
    end
    perform_group(group)
  end

  def perform_group(group)
    ::RoutingBase.execute_sp('SELECT * FROM billing.bill_cdr_batch(?, ?)', @batch_id, self.coder.dump(group))

    send_events_to_external group if need_send_external_request?
  end

  private
  def external_endpoint_config
    sysconfig['external_crd_endpoint']
  end

  def log_response(response)
    if response.code.to_i >= 400
      logger.error "Request failed #{response.code} #{response.body}"
    else
      logger.info "Success #{response.code} #{response.body}"
    end

    response
  end

  def make_request_params(data)
    if http_method == :get
      [{ params: data }]
    else
      [data.to_json, {content_type: :json, accept: :json}]
    end
  end

  def http_method
    external_endpoint_config['method'].downcase.to_sym
  end

  def need_send_external_request?
    external_endpoint_config.present?
  end

  def permit_field_for(event)
    permitted_field = external_endpoint_config['cdr_fields']

    if permitted_field == 'all' || permitted_field.nil?
      event.dup
    else
      event.select { |key, value| permitted_field.include? key.to_s }
    end
  end

  def send_event_to_external(event)
    method = http_method

    unless AVAILABLE_HTTP_METHODS.include? method
      raise ArgumentError.new 'external_crd_endpoint.method should be one of post, put, get patch'
    end

    logger.info "Sending cdr #{event.try :id}"

    response = RestClient.try(method, external_endpoint_config['url'], *make_request_params(permit_field_for(event)))

    log_response response

  rescue => e
    logger.error e.message
    logger.error e.backtrace.join "\n"
  end

  def send_events_to_external(group)
    group.map { |event| send_event_to_external event }
  end
end
