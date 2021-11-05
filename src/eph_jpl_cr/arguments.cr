module EphJplCr
  module Arguments
    extend self

    def self.check_args(target : Int32, center : Int32, jd : Float64, km : Bool)
      check_target(target)
      check_center(center)
      check_jd(jd)
      check_target_center(target, center)
    end

    private def check_target(target)
      unless (1..15).includes?(target)
        raise Const::MSG_ERR_3
      end
    end

    private def check_center(center)
      unless (0..13).includes?(center)
        raise Const::MSG_ERR_4
      end
    end

    private def check_jd(jd)
      unless Const::EPOCH_PERIOD.includes?(jd)
        raise Const::MSG_ERR_7
      end
    end

    private def check_target_center(target, center)
      case
      when target == center
        raise Const::MSG_ERR_5
      when target < 14 && center == 0,
           target > 13 && center != 0
        raise Const::MSG_ERR_6
      end
    end
  end
end
