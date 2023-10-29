require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Fields' do
    it { should have_db_column(:email).of_type(:string).with_options(null: false) }
    it { should have_db_column(:encrypted_password).of_type(:string).with_options(null: false) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }

    context 'uniqueness' do
      before do
        @user = FactoryBot.create(:user)
      end
      subject { @user }

      it { should validate_uniqueness_of(:email).case_insensitive }
    end

    it { should validate_length_of(:email).is_at_most(255) }
    it { should validate_length_of(:password).is_at_least(6).is_at_most(128) }

    it { should allow_value('xxx@yyy.co.th').for(:email) }
    it { should allow_value('xxx@yyy.com').for(:email) }

    it { should_not allow_value('invalid@email').for(:email) }
    it { should_not allow_value('xxxyyy').for(:email) }
    it { should_not allow_value('xxx.com').for(:email) }
  end

  describe 'Associations' do
    it { should have_many(:access_tokens)
      .class_name('Doorkeeper::AccessToken')
      .with_foreign_key(:resource_owner_id)
      .dependent(:delete_all)
    }
    it { should have_many(:import_histories) }
    it { should have_many(:keywords) }
  end

  describe 'Method' do
    let!(:user1)            { FactoryBot.create(:user) }
    let!(:user2)            { FactoryBot.create(:user, confirmed_at: nil) }
    let!(:admin_role)       { User.roles[:admin] }
    let!(:user_role)        { User.roles[:user] }

    describe 'self.authenticate' do
      it 'should authenticated' do
        user = User.authenticate(user1.email, user1.password)
        expect(user).to eq(user1)
      end

      it 'should not authenticate with invalid password' do
        user = User.authenticate(user1.email, 'password')
        expect(user).to eq(nil)
      end

      it 'should not authenticate with invalid email' do
        user = User.authenticate('email', 'password')
        expect(user).to eq(nil)
      end

      it 'should not authenticate with unconfirmed user' do
        user = User.authenticate(user2.email, user2.password)
        expect(user).to eq(nil)
      end
    end

    describe 'admin?' do
      it 'should return true if user is admin' do
        expect(user1.admin?).to eq(true)
      end

      it 'should return false if user is not admin' do
        user3 = FactoryBot.create(:user, role: user_role)
        expect(user3.admin?).to eq(false)
      end
    end

    describe 'user?' do
      it 'should return true if user is user role' do
        user3 = FactoryBot.create(:user, role: user_role)
        expect(user3.user?).to eq(true)
      end

      it 'should return false if user is not user role' do
        expect(user1.user?).to eq(false)
      end
    end
  end
end
