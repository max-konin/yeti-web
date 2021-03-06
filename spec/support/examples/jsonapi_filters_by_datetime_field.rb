# frozen_string_literal: true

RSpec.shared_examples :jsonapi_filters_by_datetime_field do |attr_name|
  describe "by #{attr_name}" do
    include_context :ransack_filter_setup

    let(:greater_value) { Date.today }
    let(:smaller_value) { Date.yesterday }

    context 'equal operator' do
      let(:filter_key) { "#{attr_name}_eq" }
      let(:filter_value) { smaller_value }
      let!(:suitable_record) { create_record attr_name => smaller_value }
      let!(:other_record) { create_record attr_name => greater_value }

      before { subject_request }

      it { is_expected.to include suitable_record.id.to_s }
      it { is_expected.not_to include other_record.id.to_s }
    end

    context 'not equal operator' do
      let(:filter_key) { "#{attr_name}_not_eq" }
      let(:filter_value) { smaller_value }
      let!(:suitable_record) { create_record attr_name => greater_value }
      let!(:other_record) { create_record attr_name => smaller_value }

      before { subject_request }

      it { is_expected.to include suitable_record.id.to_s }
      it { is_expected.not_to include other_record.id.to_s }
    end

    context 'less then operator' do
      let(:filter_key) { "#{attr_name}_lt" }
      let(:filter_value) { greater_value }
      let!(:suitable_record) { create_record attr_name => smaller_value }
      let!(:other_record) { create_record attr_name => greater_value }

      before { subject_request }

      it { is_expected.to include suitable_record.id.to_s }
      it { is_expected.not_to include other_record.id.to_s }
    end

    context 'less then or equal operator' do
      let(:filter_key) { "#{attr_name}_lteq" }
      let(:filter_value) { smaller_value }
      let!(:suitable_record) { create_record attr_name => smaller_value }
      let!(:other_record) { create_record attr_name => greater_value }

      before { subject_request }

      it { is_expected.to include suitable_record.id.to_s }
      it { is_expected.not_to include other_record.id.to_s }
    end

    context 'greater then operator' do
      let(:filter_key) { "#{attr_name}_gt" }
      let(:filter_value) { smaller_value }
      let!(:suitable_record) { create_record attr_name => greater_value }
      let!(:other_record) { create_record attr_name => smaller_value }

      before { subject_request }

      it { is_expected.to include suitable_record.id.to_s }
      it { is_expected.not_to include other_record.id.to_s }
    end

    context 'greater then or equal operator' do
      let(:filter_key) { "#{attr_name}_gteq" }
      let(:filter_value) { greater_value }
      let!(:suitable_record) { create_record attr_name => greater_value }
      let!(:other_record) { create_record attr_name => smaller_value }

      before { subject_request }

      it { is_expected.to include suitable_record.id.to_s }
      it { is_expected.not_to include other_record.id.to_s }
    end

    context 'in operator' do
      let(:filter_key) { "#{attr_name}_in" }
      let(:filter_value) { "#{greater_value},#{DateTime.now}" }
      let!(:suitable_record) { create_record attr_name => greater_value }
      let!(:other_record) { create_record attr_name => smaller_value }

      before { subject_request }

      it { is_expected.to include suitable_record.id.to_s }
      it { is_expected.not_to include other_record.id.to_s }
    end

    context 'not_in operator' do
      let(:filter_key) { "#{attr_name}_not_in" }
      let(:filter_value) { "#{smaller_value},#{DateTime.now}" }
      let!(:suitable_record) { create_record attr_name => greater_value }
      let!(:other_record) { create_record attr_name => smaller_value }

      before { subject_request }

      it { is_expected.to include suitable_record.id.to_s }
      it { is_expected.not_to include other_record.id.to_s }
    end
  end
end
