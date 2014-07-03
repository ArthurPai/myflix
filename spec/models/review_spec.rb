require 'spec_helper'

describe Review do
  it { should belong_to(:video) }
  it { should belong_to(:user) }

  it { should respond_to(:rating) }
  it { should respond_to(:content) }

  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:rating) }
  it { should validate_numericality_of(:rating).only_integer.is_greater_than(0).is_less_than_or_equal_to(5) }
end