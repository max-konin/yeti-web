require 'spec_helper'
require File.join(File.dirname(__FILE__), '../../consumers/cdr_billing')

RSpec.describe CdrBilling do

  let(:cdrs) do
    [
        { id: 1 },
        { id: 2 }
    ]
  end

  let(:logger) { double('Logger::Syslog') }

  let(:config) do
    YAML.load File.read(File.join(File.dirname(__FILE__), '../../../config/cdr_billing.yml'))
  end

  before :each do
    allow(::RoutingBase).to receive(:execute_sp)
    stub_request :post, config['external_crd_endpoint']
    allow(logger).to receive(:info)
    allow(logger).to receive(:error)
    subject
  end

  subject { CdrBilling.new(logger, nil).perform_group cdrs }

  it { expect(WebMock).to have_requested(:post, config['external_crd_endpoint']).with(body: { id: 1 }.to_json) }
  it { expect(WebMock).to have_requested(:post, config['external_crd_endpoint']).with(body: { id: 2 }.to_json) }
end