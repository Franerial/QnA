require "rails_helper"

RSpec.describe LinksController, type: :controller do
  describe "DELETE #destroy" do
    let!(:question) { create(:question) }
    let!(:link) { create(:link, name: "link1", url: "https://www.google.ru/", linkable: question) }

    context "User is the author of link" do
      let (:user) { question.author }

      before { login(user) }

      it "deletes the link" do
        expect { delete :destroy, params: { id: link } }.to change(question.links, :count).by(-1)
      end

      it "redirect to linkable" do
        delete :destroy, params: { id: link }
        expect(response).to redirect_to link.linkable
      end
    end

    context "User is not the author of link" do
      let (:user) { create(:user) }

      before { login(user) }

      it "link was not deleted" do
        expect { delete :destroy, params: { id: link } }.to_not change(question.links, :count)
      end

      it "redirect to linkable with notice" do
        delete :destroy, params: { id: link }
        expect(response).to redirect_to link.linkable
        expect(flash[:notice]).to be_present
      end
    end
  end
end
