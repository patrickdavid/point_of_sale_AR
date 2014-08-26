require 'spec_helper'

describe Sale do
  it { should have_many :purchases }
  it { should have_many(:products).through(:purchases) }
  it { should belong_to :cashier }
  it { should belong_to :customer }
end
