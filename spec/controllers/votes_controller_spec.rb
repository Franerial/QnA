require "rails_helper"

RSpec.describe VotesController, type: :controller do
  describe "POST #create" do
    let(:question) { create :question }
    let(:user) { create :user }

    describe "Authenticated user" do
      before { login(user) }

      context "votes for a first time" do
        it "creates new vote for question" do
          expect { post :create, params: { votable: "Question", votable_id: question.id, status: :like }, format: :json }.to change(question.votes, :count).by(1)
        end

        it "returns vote in json with created status" do
          post :create, params: { votable: "Question", votable_id: question.id, status: :like }, format: :json

          expect(response).to have_http_status(:created)

          parsed_body = JSON.parse(response.body)

          expect(parsed_body["vote"]["status"]).to eq "like"
          expect(parsed_body["rating"]).to be_present
        end
      end

      context "tries to vote twice" do
        before { question.votes.create!(user: user, status: :like) }

        it "doesn't change question votes count" do
          expect { post :create, params: { votable: "Question", votable_id: question.id, status: :like }, format: :json }.to_not change(question.votes, :count)
        end

        it "returns array of errors in json with unprocessable entity status" do
          post :create, params: { votable: "Question", votable_id: question.id, status: :like }, format: :json

          expect(response).to have_http_status(:unprocessable_entity)
          errors = JSON.parse(response.body)["errors"]
          expect(errors).to eq ["User has already been taken"]
        end
      end

      context "tries to create vote with invalid params" do
        it "doesn't create vote" do
          expect { post :create, params: { votable: "Question", votable_id: question.id }, format: :json }.to_not change(Vote, :count)
        end

        it "returns array of errors in json with unprocessable entity status" do
          post :create, params: { votable: "Question", votable_id: question.id }, format: :json

          expect(response).to have_http_status(:unprocessable_entity)
          errors = JSON.parse(response.body)["errors"]
          expect(errors).to eq ["Status can't be blank"]
        end
      end
    end

    describe "Unauthenticated user" do
      it "does not create new vote" do
        expect { post :create, params: { votable: "Question", votable_id: question.id }, format: :json }.to_not change(Vote, :count)
      end

      it "returns unauthorized status" do
        post :create, params: { votable: "Question", votable_id: question.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE #destroy" do
    let(:question) { create :question }
    let(:user) { create :user }
    let!(:vote1) { create(:vote, status: :like, user: user, votable: question) }
    let!(:vote2) { create(:vote, status: :like, votable: question) }

    describe "Authenticated user" do
      before { login(user) }

      context "when user is the author of vote" do
        it "delete vote" do
          expect { delete :destroy, params: { id: vote1 }, format: :json }.to change { question.votes.count }.by(-1)
        end

        it "returns vote with ok status" do
          delete :destroy, params: { id: vote1 }, format: :json

          expect(response).to have_http_status(:ok)

          parsed_body = JSON.parse(response.body)

          expect(parsed_body["votable_id"]).to eq vote1.votable.id
          expect(parsed_body["rating"]).to eq question.rating
        end
      end

      context "when user is not the author of vote" do
        it "doesn't delete vote" do
          expect { delete :destroy, params: { id: vote2 }, format: :json }.to_not change(question.votes, :count)
        end

        it "returns forbidden status" do
          delete :destroy, params: { id: vote2 }, format: :json

          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    describe "Unauthenticated user" do
      it "doesn't delete vote" do
        expect { delete :destroy, params: { id: vote2 }, format: :json }.to_not change(question.votes, :count)
      end

      it "returns unauthorized status" do
        delete :destroy, params: { id: vote2 }, format: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
