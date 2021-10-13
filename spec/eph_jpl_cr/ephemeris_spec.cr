require "../spec_helper"

describe EphJplCr::Ephemeris do
  context %Q{.new(11, 3, 2457465.5, bin_object) } do
    b = EphJplCr::Binary.new(BIN_PATH, 11, 3, 2457465.5).get_binary
    e = EphJplCr::Ephemeris.new(11, 3, 2457465.5, b, false)

    context "object" do
      it { e.should be_a EphJplCr::Ephemeris }
    end

    context "@target" do
      it { e.@target.should eq 11 }
    end

    context "@center" do
      it { e.@center.should eq 3 }
    end

    context "@target_name" do
      it { e.@target_name.should eq "Sun" }
    end

    context "@center_name" do
      it { e.@center_name.should eq "Earth" }
    end

    context "@jd" do
      it { e.@jd.should eq 2457465.5 }
    end

    context "@bin" do
      it { e.@bin.should be_a EphJplCr::Binary::BinaryData }
    end

    context "@km" do
      it { e.@km.should be_false }
    end

    context "@list" do
      it { e.@list.should eq([0, 0, 2, 0, 0, 0, 0, 0, 0, 2, 0, 0]) }
    end

    context ".calc" do
      it do
        e.calc.should eq([
          0.99443659220701,
          -0.038162917689578336,
          -0.016551776709600584,
          0.000993337565612388,
          0.01582779844821734,
          0.0068618662767956536
        ])
      end
    end
  end

  context %Q{.new(11, 3, 2457465.5, bin_object, true) } do
    b = EphJplCr::Binary.new(BIN_PATH, 11, 3, 2457465.5).get_binary
    e = EphJplCr::Ephemeris.new(11, 3, 2457465.5, b, true)

    context "@km" do
      it { e.@km.should be_true }
    end
  end
end
