require "../spec_helper"

describe EphJplCr::Argument do
  # Edit BIN_PATH to fit your environment!

  context %Q{.new("#{BIN_PATH}", 11, 3, 2457465.5) } do
    a = EphJplCr::Argument.new(BIN_PATH, 11, 3, 2457465.5)

    context "object" do
      it { a.should be_a EphJplCr::Argument }
    end

    context ".get_args" do
      it { a.get_args.should eq({BIN_PATH, 11, 3, 2457465.5, false}) }
    end

    context ".check_bin_path" do
      it { a.check_bin_path.should be_nil }
    end

    context ".check_target" do
      it { a.check_target.should be_nil }
    end

    context ".check_center" do
      it { a.check_center.should be_nil }
    end

    context ".check_jd" do
      it { a.check_jd.should be_nil }
    end
  end

  context %Q{.new("#{BIN_DUMMY}", 11, 3, 2457465.5) } do
    a = EphJplCr::Argument.new(BIN_DUMMY, 11, 3, 2457465.5)

    context ".check_bin_path" do
      it do
        expect_raises(Exception, EphJplCr::Const::MSG_ERR_2) do
          a.check_bin_path
        end
      end
    end
  end

  context %Q{.new("#{BIN_PATH}", 11, 11, 2457465.5) } do
    a = EphJplCr::Argument.new(BIN_PATH, 11, 11, 2457465.5)

    context ".check_target_center" do
      it do
        expect_raises(Exception, EphJplCr::Const::MSG_ERR_5) do
          a.check_target_center
        end
      end
    end
  end

  context %Q{.new("#{BIN_PATH}", 11, 0, 2457465.5) } do
    a = EphJplCr::Argument.new(BIN_PATH, 11, 0, 2457465.5)

    context ".check_target_center" do
      it do
        expect_raises(Exception, EphJplCr::Const::MSG_ERR_6) do
          a.check_target_center
        end
      end
    end
  end

  context %Q{.new("#{BIN_PATH}", 14, 3, 2457465.5) } do
    a = EphJplCr::Argument.new(BIN_PATH, 14, 3, 2457465.5)

    context ".check_target_center" do
      it do
        expect_raises(Exception, EphJplCr::Const::MSG_ERR_6) do
          a.check_target_center
        end
      end
    end
  end

  context %Q{.new("#{BIN_PATH}", 16, 3, 2457465.5) } do
    a = EphJplCr::Argument.new(BIN_PATH, 16, 3, 2457465.5)

    context "get_args" do
      it do
        expect_raises(Exception, EphJplCr::Const::MSG_ERR_3) do
          a.get_args
        end
      end
    end

    context ".check_target" do
      it do
        expect_raises(Exception, EphJplCr::Const::MSG_ERR_3) do
          a.check_target
        end
      end
    end
  end

  context %Q{.new("#{BIN_PATH}", 11, 0, 2457465.5) } do
    a = EphJplCr::Argument.new(BIN_PATH, 11, 17, 2457465.5)

    context ".get_args" do
      it do
        expect_raises(Exception, EphJplCr::Const::MSG_ERR_4) do
          a.get_args
        end
      end
    end

    context ".check_center" do
      it do
        expect_raises(Exception, EphJplCr::Const::MSG_ERR_4) do
          a.check_center
        end
      end
    end
  end

  context %Q{.new("#{BIN_PATH}", 11, 3, 2000000.5) } do
    a = EphJplCr::Argument.new(BIN_PATH, 11, 3, 2000000.5)

    context ".get_args" do
      it do
        expect_raises(Exception, EphJplCr::Const::MSG_ERR_7) do
          a.get_args
        end
      end
    end

    context ".check_jd" do
      it do
        expect_raises(Exception, EphJplCr::Const::MSG_ERR_7) do
          a.check_jd
        end
      end
    end
  end
end
