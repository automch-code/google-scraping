require 'rails_helper'

RSpec.describe ImportHistory, type: :model do
  describe 'Fields' do
    it { should have_db_column(:filename).of_type(:string).with_options(null: true) }
    it { should have_db_index(:user_id) }
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should have_one_attached(:file) }
  end
end
