require "oystercard"
describe OysterCard do

  before do
    @oc = OysterCard.new
  end

  describe "#initialize" do
    it "Should initialize balance to 0.00" do
      expect(subject.balance).to eq 0.00
    end
  end
  describe "#balance" do
    it { is_expected.to respond_to :balance }
  end

  describe "#top_up" do
    it { is_expected.to respond_to(:top_up).with(1).argument }
    it "Increments balance by argument passed to top_up" do
      topup_amount = 1.20
      expect { subject.top_up(topup_amount) }.to change{ subject.balance }.by topup_amount
    end
    it "Raises an error if top up amount will cause balance to exceed maximum limit" do
      topup_amount = 95.00
      expect { subject.top_up(topup_amount) }.to raise_error("Balance cannot exceed #{OysterCard::MAXIMUM_LIMIT}")
    end
  end

  describe "#deduct" do
    it { is_expected.to respond_to(:deduct).with(1).argument }
    it "Reduces the balance by argument passed to deduct" do
      fare = 15.00
      expect { subject.deduct(fare) }.to change{ subject.balance }.by -(fare)
    end
  end

  describe "#in_journey?" do
    it { is_expected.to respond_to :in_journey? }
    it "initializes as false" do
      expect(subject).not_to be_in_journey
    end
    context "Has minimum fare" do
      before do
        @oc.top_up(30.00)
      end
      it "returns a boolean" do
        expect(@oc.in_journey?).to be(true).or be(false)
        subject.touch_out
        expect(@oc.in_journey?).to be(true).or be(false)
      end
    end
  end

  describe "#touch_in" do
    it { is_expected.to respond_to :touch_in }
    it "Raises an error if balance is not greater than the minimum fare" do
      expect { subject.touch_in }.to raise_error("You must have a minimum balance of #{OysterCard::MINIMUM_FARE} before touching in")
    end
    context "Has minimum fare" do
      before do
        @oc.top_up(30.00)
      end
      it "Changes in_journey to true" do
        @oc.touch_in
        expect(@oc).to be_in_journey
      end
    end
  end

  describe "#touch_out" do
    it { is_expected.to respond_to :touch_out }
    context "Has minimum fare" do
      before do
        @oc.top_up(30.00)
      end
      it "Changes in_journey to false" do
        @oc.touch_in
        @oc.touch_out
        expect(@oc).not_to be_in_journey
      end
    end
  end
end
