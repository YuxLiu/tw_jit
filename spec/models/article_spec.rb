require 'rails_helper'

RSpec.describe Article, type: :model do
  it { should belong_to(:author).with_foreign_key('author_id').required }
end
