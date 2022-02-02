require "rails_helper"

RSpec.describe FilesAttachmentController, type: :controller do
  describe "DELETE #destroy" do
    let!(:question) { create(:question) }

    before do
      file = Rack::Test::UploadedFile.new("spec/rails_helper.rb")
      question.files.attach(file)
    end

    context "User is the author of file" do
      let (:user) { question.author }

      before { login(user) }

      it "deletes the file" do
        expect { delete :destroy, params: { id: question.files.first } }.to change(question.files, :count).by(-1)
      end

      it "redirect to the same page" do
        delete :destroy, params: { id: question.files.first }
        expect(response).to redirect_to question.files.first.record
      end
    end

    context "User is not the author of file" do
      let (:user) { create(:user) }

      before { login(user) }

      it "file was not deleted" do
        expect { delete :destroy, params: { id: question.files.first } }.to_not change(question.files, :count)
      end

      it "should display flash notice" do
        delete :destroy, params: { id: question.files.first }
        expect(flash[:notice]).to be_present
      end
    end
  end
end
