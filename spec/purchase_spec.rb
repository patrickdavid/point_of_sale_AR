require 'spec_helper'

describe Purchase do
  it { should have_one :product }
end
