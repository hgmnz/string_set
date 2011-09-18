require 'string_set'

shared_context 'interacting with another set' do
  let(:another_set) { StringSet.new }
  before do
    another_set.add 'awesome'
    another_set.add 'fantastic'
    subject.add 'awesome'
    subject.add 'super'
  end
end

describe StringSet do
  subject { StringSet.new }

  it { should be_empty }

  context 'knows how many strings it contains' do
    before do
      2.times { |i| subject.add(i.to_s) }
    end
    its(:size) { should == 2 }
  end

  context 'adding a string' do
    it 'can be added a string' do
      subject.add 'awesome'
      subject.size.should == 1
    end

    it 'only adds it if it does not already have it' do
      subject.add 'awesome'
      subject.add 'awesome'
      subject.size.should == 1
    end

    it 'can receive many strings to add' do
      subject.add('awesome', 'fantastic', 'awesome')
      subject.size.should == 2
      subject.should include('awesome')
      subject.should include('fantastic')
    end
  end

  context 'checking contents' do
    before do
      subject.add 'awesome'
    end

    it { should include('awesome') }
    it { should_not include('not so awesome') }
  end

  context 'removing a string' do
    before { subject.add 'awesome' }
    it 'removes it if it exists' do
      subject.remove 'awesome'
    end

    it 'does not raise if it does not exist' do
      expect { subject.remove 'not awesome' }.to_not raise_error
    end
  end

  context 'enumerating the set' do
    before do
      subject.add('awesome')
      subject.add('fantastic')
    end

    it 'yields each element in the set' do
      yielded = []
      subject.each do |string|
        begin
          raise string
        rescue => e
          yielded << e.message
          next
        end
      end
      yielded.should include('awesome')
      yielded.should include('fantastic')
      yielded.should have(2).strings
    end
  end

  context 'as an array' do
    before do
      subject.add('awesome')
      subject.add('fantastic')
    end

    its(:to_a) { should == %w(awesome fantastic) }
  end

  context 'equality' do
    let(:another_set) { StringSet.new }

    before do
      another_set.add('awesome')
      another_set.add('fantastic')
      subject.add('awesome')
    end

    it 'equals another set if it has the same items' do
      subject.add('fantastic')
      subject.should be == another_set
    end

    it 'does not equal another set if the items do not match' do
      subject.add('super')
      subject.should_not be == another_set
    end
  end

  context 'the union of two sets' do
    include_context 'interacting with another set'

    it 'gives a new set with all items from both sets' do
      union = subject.union(another_set)
      union.size.should == 3
      union.should include('awesome')
      union.should include('fantastic')
      union.should include('super')
      union.should be_kind_of StringSet
    end
  end

  context 'the intersection of two sets' do
    include_context 'interacting with another set'
    it 'gives a new set with the common set members' do
      intersection = subject.intersect(another_set)
      intersection.size.should == 1
      intersection.to_a.should == ['awesome']
      intersection.should be_kind_of StringSet
    end
  end

  context 'clearing it' do
    before do
      subject.add 'awesome'
      subject.add 'fantastic'

      subject.clear
    end
    its(:size) { should be_zero }
  end
end
