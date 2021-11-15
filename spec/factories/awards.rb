FactoryBot.define do
  factory :award do
    name { "Test award" }
    association :question, factory: :question
    image { Rack::Test::UploadedFile.new("public/test-badge.png") }
  end
end
