require 'net/http'
require 'uri'

class  CdrBilling < Pgq::ConsumerGroup
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

    send_events_to_external group
  end

  private

  def send_events_to_external(group)
    group.map { |event| send_event_to_external event }
  end

  def send_event_to_external(event)
    logger.info "Sending cdr #{event.try :id}"

    uri = URI sysconfig['external_crd_endpoint']

    response = Net::HTTP.start(uri.host, uri.port) do |http|
      request =  Net::HTTP::Post.new uri, 'Content-Type': 'application/json'
      request.body = self.coder.dump event
      http.request request
    end

    log_response response
  end

  def log_response(response)
    if response.code.to_i >= 400
      logger.error "Request failed #{response.code} #{response.body}"
    else
      logger.info "Success #{response.code} #{response.body}"
    end

    response
  end
end
