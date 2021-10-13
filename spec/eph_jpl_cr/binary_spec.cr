require "../spec_helper"

describe EphJplCr::Binary do
  context %Q{.new("#{BIN_PATH}", 11, 3, 2457465.5) } do
    b = EphJplCr::Binary.new(BIN_PATH, 11, 3, 2457465.5)

    context "object" do
      it { b.should be_a EphJplCr::Binary }
    end

    context ".get_binary" do
      binary = b.get_binary
      
      it do
        binary.should be_a EphJplCr::Binary::BinaryData 
        binary[:jdepoc].should eq 2440400.5
      end

      context "[:ttl]" do
        it { binary[:ttl].should match(/^JPL Planetary Ephemeris DE430/) }
      end
      
      context "[:cnams]" do
        it do
          binary[:cnams][0,10].should eq([
            "DENUM", "LENUM", "TDATEF", "TDATEB", "JDEPOC",
            "CENTER", "CLIGHT", "BETA", "GAMMA", "AU"
          ])
        end
      end

      context "[:sss]" do
        it { binary[:sss].should eq [2287184.5, 2688976.5, 32.0] }
      end
      
      context "[:ncon]" do
        it { binary[:ncon].should eq 572 }
      end

      context "[:au]" do
        it { binary[:au].should eq 149597870.7 }
      end

      context "[:emrat]" do
        it { binary[:emrat].should eq(81.30056907419062) }
      end

      context "[:ipts]" do
        it do
          binary[:ipts].should eq([
            [  3, 14, 4], [171, 10, 2], [231, 13, 2], [309, 11, 1], [342,  8, 1],
            [366,  7, 1], [387,  6, 1], [405,  6, 1], [423,  6, 1], [441, 13, 8],
            [753, 11, 2], [819, 10, 4], [899, 10, 4]
          ])
        end
      end

      context "[:numde]" do
        it { binary[:numde].should eq 430 }
      end

      context "[:cvals]" do
        it do
          binary[:cvals][0,12].should eq([
            430.0, 430.0, 20130329200438.0, 20130329191007.0, 2440400.5,
            0.0, 299792.458, 1.0, 1.0, 149597870.7,
            81.30056907419062, 4.91248045036476e-11
          ])
        end
      end

      context "[:coeffs]" do
        it do
          binary[:coeffs][0][0][0][0,5].should eq([
            45504893.24150742,
            7731834.965392029,
            -776090.8071882643,
            -41121.3443020638,
            -503.7461853424133
          ])
        end
      end
      
      context "[:jds_cheb]" do
        it { binary[:jds_cheb].should eq([2457456.5, 2457488.5]) }
      end
    end
  end
end
