require 'spec_helper'

describe Fellowship do
  it { should belong_to(:followed_user).class_name('User') }
  it { should belong_to(:follower).class_name('User') }

  it { should validate_uniqueness_of(:followed_user_id).scoped_to(:follower_id) }
end