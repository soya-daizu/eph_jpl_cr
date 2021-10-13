module EphJplCr
  class Ephemeris
    getter target : Int32
    getter center : Int32
    getter jd : Float64
    getter bin : Binary::BinaryData
    getter km : Bool
    getter target_name : String
    getter center_name : String
    getter unit : String
    @list : Array(Int32)

    def initialize(@target, @center, @jd, @bin, @km)
      @target_name = Const::ASTRS[@target - 1]
      @center_name = Const::ASTRS[@center - 1]
      @unit = @target > 13 ? "rad, rad/day" : @km ? "km, km/sec" : "AU, AU/day"
      @list = get_list
    end

    def calc
      pvs     = Array.new(11, Array.new(6, 0.0))  # for position, velocity
      pvs_tmp = Array.new(13, Array.new(6, 0.0))  # Temporary array for position, velocity of target and center
      rrds    = Array.new(6, 0.0)  # for calculated data (difference between target and center)

      begin
        # Interpolate (11:Sun)
        pv_sun = interpolate(11)
        # Interpolate (1:Mercury - 10:Moon)
        0.upto(9) do |i|
          next if @list[i] == 0
          pvs[i] = interpolate(i + 1)
          next if i > 8
          next if Const::BARY
          pvs[i] = pvs[i].map_with_index do |pv, j|
            pv - pv_sun[j]
          end
        end
        # Interpolate (14:Nutation)
        if @list[10] > 0 && @bin[:ipts][11][1] > 0
          p_nut = interpolate(14)
        end
        # Interpolate (15:Libration）
        if @list[11] > 0 && @bin[:ipts][12][1] > 0
          pvs[10] = interpolate(15)
        end

        # Difference between target and center
        case
        when @target == 14
          rrds = p_nut if @bin[:ipts][11][1] > 0
        when @target == 15
          rrds = pvs[10] if @bin[:ipts][12][1] > 0
        else
          0.upto(9) { |i| pvs_tmp[i] = pvs[i] }
          pvs_tmp[10] = pv_sun            if {@target, @center}.includes?(11)
          pvs_tmp[11] = Array.new(6, 0.0) if {@target, @center}.includes?(12)
          pvs_tmp[12] = pvs[2]            if {@target, @center}.includes?(13)
          if @target * @center == 30 || @target + @center == 13
            pvs_tmp[2] = Array.new(6, 0.0)
          else
            pvs_tmp[2] = pvs[2].map_with_index do |pv, i|
              pv - pvs[9][i] / (1.0 + @bin[:emrat])
            end unless @list[2] == 0
            pvs_tmp[9] = pvs_tmp[2].map_with_index do |pv, i|
              pv + pvs[9][i]
            end unless @list[9] == 0
          end
          0.upto(5) do |i|
            rrds[i] = pvs_tmp[@target - 1][i] - pvs_tmp[@center - 1][i]
          end
        end
        return rrds.as(Array(Float64))
      rescue e
        raise e
      end
    end

    private def get_list
      list = Array.new(12, 0)

      begin
        if @target == 14
          list[10] = Const::KIND if @bin[:ipts][11][1] > 0
          return list
        end
        if @target == 15
          list[11] = Const::KIND if @bin[:ipts][12][1] > 0
          return list
        end
        {@target, @center}.each do |k|
          list[k - 1] = Const::KIND if k <= 10
          list[2]     = Const::KIND if k == 10
          list[9]     = Const::KIND if k ==  3
          list[2]     = Const::KIND if k == 13
        end
        return list
      rescue e
        raise e
      end
    end

    private def interpolate(astr : Int32)
      pvs = Array(Float64).new

      begin
        tc, idx_sub = norm_time(astr)
        n_item = astr == 14 ? 2 : 3  # 要素数
        i_ipt  = astr > 13 ? astr - 3 : astr - 1
        i_coef = astr > 13 ? astr - 3 : astr - 1
  
        # 位置
        ary_p = [1, tc]
        2.upto(@bin[:ipts][i_ipt][1] - 1) do |i|
          ary_p << 2 * tc * ary_p[-1] - ary_p[-2]
        end  # 各項
        0.upto(n_item - 1) do |i|
          val = 0
          0.upto(@bin[:ipts][i_ipt][1] - 1) do |j|
            val += @bin[:coeffs][i_coef][idx_sub][i][j] * ary_p[j]
          end
          val /= @bin[:au] if !@km && astr < 14
          pvs << val.to_f64
        end  # 値
  
        # 速度
        ary_v = [0, 1, 2 * 2 * tc]
        3.upto(@bin[:ipts][i_ipt][1] - 1) do |i|
          ary_v << 2 * tc * ary_v[-1] + 2 * ary_p[i - 1] - ary_v[-2]
        end  # 各項
        0.upto(n_item - 1) do |i|
          val = 0
          0.upto(@bin[:ipts][i_ipt][1] - 1) do |j|
            val += @bin[:coeffs][i_coef][idx_sub][i][j] * ary_v[j] * 2 * @bin[:ipts][i_ipt][2] / @bin[:sss][2].to_f
          end
          if astr < 14
            val /= @bin[:au] unless @km
            val /= 86400.0 if @km
          end
          pvs << val.to_f64
        end  # 値
  
        return pvs
      rescue e
        raise e
      end
    end

    private def norm_time(astr : Int32)
      idx = astr > 13 ? astr - 2 : astr
      jd_start = @bin[:jds_cheb][0]
      tc = (@jd - jd_start) / @bin[:sss][2].to_f
      temp = tc * @bin[:ipts][idx - 1][2]
      idx = (temp - tc.to_i).to_i          # サブ区間のインデックス
      tc = (temp % 1.0 + tc.to_i) * 2 - 1  # チェビシェフ時間
      return {tc, idx}
    rescue e
      raise e
    end
  end
end

