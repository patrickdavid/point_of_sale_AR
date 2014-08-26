require 'spec_helper'

describe Cashier do
  it { should have_many :sales }
  it { should have_and_belong_to_many :customers }
end
