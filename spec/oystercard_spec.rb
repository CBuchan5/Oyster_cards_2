require "Oystercard"

describe Oystercard do
it {is_expected.to respond_to :balance}
it {is_expected.to respond_to(:top_up).with(1).argument}
# it {is_expected.to respond_to(:deduct).with(1).argument}
# it {is_expected.to respond_to :touch_in}
# it {is_expected.to respond_to :in_journey?}
let (:station) { double :station }
  describe "#balance" do
    it "should check a card has a balance" do
      expect(subject.balance).to eq 0 
    end
  end

  describe "#top_up" do
    it "should top up money on an oyster card" do 
      expect{ subject.top_up(1)}.to change{ subject.balance }.by 1
    end

    it "should raise error if top up amount > 90" do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      subject.top_up maximum_balance
      expect{ subject.top_up(1) }.to raise_error "Maximum balance #{maximum_balance} exceeded"
    end
  end

  # describe "#deduct" do
  #   it "should deduct money from my card" do
  #     subject.top_up(20)
  #     expect { subject.deduct(5)}. to change { subject.balance}.by -5
  #   end
  # end
  

  describe "#in_journey" do
    it "is initially not in a journey" do
      expect(subject).not_to be_in_journey
    end
  end 

  describe '#touch_in' do 
    it "can touch in" do
      subject.top_up(1)
      subject.touch_in(station)
      expect(subject).to be_in_journey
    end
    
    it "gives error message if below minimum amount" do
      expect{subject.touch_in(station)}.to raise_error "minimum amount needed, £1"
    end
    it 'stres the entry station' do
      subject.top_up(1)
      expect {subject.touch_in(station)}.to change {subject.entry_station}.to(station)
     # expect(subject.entry_station).to eq station
    end

    describe '#touch_out' do
    it "can touch out" do
      subject.top_up(1)
      subject.touch_in(station)
      subject.touch_out
      expect(subject).not_to be_in_journey
      end

    it "checks a charge is made on touch out" do 
      subject.top_up(1)
      subject.touch_in(station)
      subject.touch_out
      expect{ subject.touch_out}.to change {subject.balance}.by(-Oystercard::MINIMUM_BALANCE)
      end
    
      it "checks that entry station is set to nil after touch out" do
        subject.top_up(1)
        subject.touch_in(station)
        expect {subject.touch_out}.to change {subject.entry_station}.to nil 
      end

     end
  end



end

# In order to get through the barriers.
# As a customer
# I need to touch in and out.
