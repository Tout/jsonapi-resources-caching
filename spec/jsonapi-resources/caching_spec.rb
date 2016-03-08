require 'spec_helper'

class Test
  attr_accessor :attr_1, :attr_2
end

class TestResource < JSONAPI::Resource

end

class TestController < JSONAPI::ResourceController
  def initialize(params)

  end
end

describe JSONAPI::Caching do
  it 'has a version number' do
    expect(JSONAPI::Caching::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(true).to eq(true)
  end
end
