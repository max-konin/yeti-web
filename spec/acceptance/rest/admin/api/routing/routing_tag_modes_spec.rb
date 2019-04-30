# frozen_string_literal: true

require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Routing RoutingTagMode' do
  include_context :acceptance_admin_user

  let(:collection) { Routing::RoutingTagMode.all }
  let(:record) { Routing::RoutingTagMode.take }

  include_context :acceptance_index_show, namespace: 'routing',
                                          type: 'routing-tag-modes',
                                          resource: Api::Rest::Admin::Routing::RoutingTagModeResource
end
