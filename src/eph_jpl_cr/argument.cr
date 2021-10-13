module EphJplCr
  class Argument
    def initialize(@bin_path : String, @target : Int32, @center : Int32, @jd : Float64, @km : Bool = Const::KM)
    end

    def get_args
      check_target
      check_center
      check_jd
      check_bin_path
      check_target_center
      return {@bin_path, @target, @center, @jd, @km}
    end

    private def check_target
      unless (1..15).includes?(@target)
        raise Const::MSG_ERR_3
      end
    end

    private def check_center
      unless (0..13).includes?(@center)
        raise Const::MSG_ERR_4
      end
    end

    private def check_jd
      unless Const::EPOCH_PERIOD.includes?(@jd)
        raise Const::MSG_ERR_7
      end
    end

    private def check_target_center
      case
      when @target == @center
        raise Const::MSG_ERR_5
      when @target < 14 && @center == 0,
           @target > 13 && @center != 0
        raise Const::MSG_ERR_6
      end
    end

    private def check_bin_path
      raise Const::MSG_ERR_2 unless File.exists?(@bin_path)
    end
  end
end
