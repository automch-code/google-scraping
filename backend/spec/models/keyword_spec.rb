require 'rails_helper'

RSpec.describe Keyword, type: :model do
  describe 'Fields' do
    it { should have_db_column(:word).of_type(:string) }
    it { should have_db_column(:adwords).of_type(:integer) }
    it { should have_db_column(:links).of_type(:integer) }
    it { should have_db_column(:results).of_type(:decimal) }
    it { should have_db_column(:speed).of_type(:decimal) }
    it { should have_db_column(:rep_adwords).of_type(:string) }
    it { should have_db_column(:rep_links).of_type(:string) }
    it { should have_db_column(:rep_results).of_type(:string) }
    it { should have_db_column(:rep_speed).of_type(:string) }
    it { should have_db_column(:html_text).of_type(:text) }
    it { should have_db_index(:user_id) }
  end

  describe 'Associations' do
    it { should belong_to(:user) }
  end
end
