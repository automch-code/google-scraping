require 'rails_helper'

RSpec.describe Keyword, type: :model do
  describe 'Fields' do
    it { should have_db_column(:word).of_type(:string) }
    it { should have_db_column(:adwords).of_type(:integer) }
    it { should have_db_column(:links).of_type(:integer) }
    it { should have_db_column(:results).of_type(:integer) }
    it { should have_db_column(:speed).of_type(:decimal) }
    it { should have_db_column(:rep_adwords).of_type(:string) }
    it { should have_db_column(:rep_links).of_type(:string) }
    it { should have_db_column(:rep_results).of_type(:string) }
    it { should have_db_column(:rep_speed).of_type(:string) }
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should have_one_attached(:html_file) }
  end
end
