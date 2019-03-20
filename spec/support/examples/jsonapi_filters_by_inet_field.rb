# frozen_string_literal: true

RSpec.shared_examples :jsonapi_filters_by_inet_field do |attr_name|
  describe "by #{attr_name}" do
    include_context :ransack_filter_setup

    let!(:suitable_record) { create_record attr_name => '0.0.0.0' }
    let!(:other_record) { create_record attr_name => '1.1.1.1' }

    context 'start operator' do
      let(:filter_key) { "#{attr_name}_start" }
      let(:filter_value) { '0.0' }

      before { subject_request }

      it { is_expected.to include suitable_record.id.to_s }
      it { is_expected.not_to include other_record.id.to_s }
    end

    context 'end operator' do
      let(:filter_key) { "#{attr_name}_end" }
      let(:filter_value) { '.0' }

      before { subject_request }

      it { is_expected.to include suitable_record.id.to_s }
      it { is_expected.not_to include other_record.id.to_s }
    end

    context 'cont operator' do
      let(:filter_key) { "#{attr_name}_cont" }
      let(:filter_value) { '.0.' }

      before { subject_request }

      it { is_expected.to include suitable_record.id.to_s }
      it { is_expected.not_to include other_record.id.to_s }
    end

    context 'equal operator' do
      let(:filter_key) { "#{attr_name}_eq" }
      let(:filter_value) { '0.0.0.0' }

      before { subject_request }

      it { is_expected.to include suitable_record.id.to_s }
      it { is_expected.not_to include other_record.id.to_s }
    end

    context 'not equal operator' do
      let(:filter_key) { "#{attr_name}_not_eq" }
      let(:filter_value) { '1.1.1.1' }

      before { subject_request }

      it { is_expected.to include suitable_record.id.to_s }
      it { is_expected.not_to include other_record.id.to_s }
    end
  end
end
