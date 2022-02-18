require "rails_helper"

RSpec.describe SearchesController, type: :controller do
  describe "GET #show" do
    let(:service) { double "Search" }
    let(:query) { "MyQuery" }
    let(:resources) { %w[answer user] }
    let(:results) { double "Results of search" }
    let(:service) { double "Search" }

    before do
      allow(Search).to receive(:new).and_return(service)
      allow(service).to receive(:call).and_return(results)
    end

    context "when no query param" do
      it "renders show view" do
        get :show
        expect(response).to render_template :show
      end

      it "doesn't call Search service" do
        expect(Search).not_to receive(:new)
        expect(service).not_to receive(:call)
        get :show
      end
    end

    context "when no resources params" do
      subject { get :show, params: { query: query } }

      it "renders show view" do
        subject
        expect(response).to render_template :show
      end

      it "does not initializes and call Search service" do
        expect(Search).not_to receive(:new)
        expect(service).not_to receive(:call)
        subject
      end
    end

    context "when params present" do
      subject { get :show, params: { query: query, resources: resources } }

      it "renders show view" do
        subject
        expect(response).to render_template :show
      end

      it "sends query and resources params to Search service and calls it" do
        expect(Search).to receive(:new).with(query, resources).and_return(service)
        expect(service).to receive(:call)
        subject
      end

      it "initializes records instance var with results" do
        subject
        expect(assigns(:records)).not_to be_nil
      end
    end
  end
end
