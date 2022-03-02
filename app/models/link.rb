class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true, touch: true

  validates :name, :url, presence: true
  validates :url, format: URI::regexp(%w[http https])

  def gist?
    url&.match?(%r{^https://gist.github.com/\w+/\w{32}$})
  end
end
