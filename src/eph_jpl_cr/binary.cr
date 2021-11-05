module EphJplCr
  struct Binary
    getter ttl : String
    getter cnams : Array(String)
    getter sss : Array(Float64)
    getter ncon : UInt32
    getter au : Float64
    getter emrat : Float64
    getter numde : UInt32
    getter ipts : Array(Array(UInt32))
    getter cvals : Array(Float64)
    getter jdepoc : Float64
    getter coeffs : Array(Array(Array(Array(Float64))))
    getter jds_cheb : Array(Float64)

    def initialize(@file : File, @target : Int32, @center : Int32, @jd : Float64)
      @pos = 0
      @ttl    = get_ttl            # TTL
      @cnams  = get_cnams          # CNAM
      @sss    = get_sss            # SS
      @ncon   = get_ncon           # NCON
      @au     = get_au             # AU
      @emrat  = get_emrat          # EMRAT
      @ipts   = get_ipts           # IPT
      @numde  = get_numde          # NUMDE
      @ipts  << get_ipts_13        # IPT(Month's libration)
      @cnams += get_cnams_2(ncon)  # CNAM(>400)
      @cvals  = get_cvals(ncon)    # CVAL（定数値）
      @jdepoc = cvals[4]           # JDEPOC
      @coeffs, @jds_cheb = get_coeffs(sss, ipts)  # Coefficient, JDs(for Chebyshev polynomial)
    end

    private def get_ttl
      recl = 84

      begin
        ttl = (0..2).map do |i|
          @file.read_at(@pos + recl * i, recl) do |io|
            io.read_string(recl).strip
          end
        end.join("\n")
        @pos += recl * 3
        return ttl
      rescue e
        raise e
      end
    end

    private def get_cnams
      recl = 6

      begin
        cnams = (0..399).map do |i|
          @file.read_at(@pos + recl * i, recl) do |io|
            io.read_string(recl).strip
          end
        end
        @pos += recl * 400
        return cnams
      rescue e
        raise e
      end
    end

    private def get_sss
      recl = 8

      begin
        sss = (0..2).map do |i|
          @file.read_at(@pos + recl * i, recl) do |io|
            io.read_bytes(Float64, IO::ByteFormat::LittleEndian)
          end
        end
        @pos += recl * 3
        return sss
      rescue e
        raise e
      end
    end

    private def get_ncon
      recl = 4

      begin
        ncon = @file.read_at(@pos, recl) do |io|
          io.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
        end
        @pos += recl
        return ncon
      rescue e
        raise e
      end
    end

    private def get_au
      recl = 8

      begin
        au = @file.read_at(@pos, recl) do |io|
          io.read_bytes(Float64, IO::ByteFormat::LittleEndian)
        end
        @pos += recl
        return au
      rescue e
        raise e
      end
    end

    private def get_emrat
      recl = 8

      begin
        emrat = @file.read_at(@pos, recl) do |io|
          io.read_bytes(Float64, IO::ByteFormat::LittleEndian)
        end
        @pos += recl
        return emrat
      rescue e
        raise e
      end
    end

    private def get_ipts
      recl = 4

      begin
        ipts = (0..11).map do |i|
          ary = (0..2).map do |j|
            @file.read_at(@pos + recl * j, recl) do |io|
              io.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
            end
          end
          @pos += recl * 3
          ary
        end
        return ipts
      rescue e
        raise e
      end
    end

    private def get_numde
      recl = 4

      begin
        numde = @file.read_at(@pos, recl) do |io|
          io.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
        end
        raise Const::MSG_ERR_8 unless numde == 430
        @pos += recl
        return numde
      rescue e
        raise e
      end
    end

    private def get_ipts_13
      recl = 4

      begin
        ipts = (0..2).map do |i|
          @file.read_at(@pos + recl * i, recl) do |io|
            io.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
          end
        end
        @pos += recl * 3
        return ipts
      rescue e
        raise e
      end
    end

    private def get_cnams_2(ncon : UInt32)
      recl = 6

      begin
        cnams = (0..(ncon - 400 - 1)).map do |i|
          @file.read_at(@pos + recl * i, recl) do |io|
            io.read_string(recl).strip
          end
        end
        @pos += recl * (ncon - 400)
        return cnams
      rescue e
        raise e
      end
    end

    private def get_cvals(ncon : UInt32)
      pos = Const::KSIZE * Const::RECL
      recl = 8

      begin
        return (0..ncon - 1).map do |i|
          @file.read_at(pos + recl * i, recl) do |io|
            io.read_bytes(Float64, IO::ByteFormat::LittleEndian)
          end
        end
      rescue e
        raise e
      end
    end

    private def get_coeffs(sss : Array(Float64), ipts : Array(Array(UInt32)))
      idx = ((@jd - sss[0]) / sss[2]).to_i  # レコードインデックス
      pos = Const::KSIZE * Const::RECL * (2 + idx)
      recl = 8
      coeffs = Array(Array(Array(Array(Float64)))).new

      begin
        items = (0..(Const::KSIZE / 2) - 1).map do |i|
          @file.read_at(pos + recl * i, recl) do |io|
            io.read_bytes(Float64, IO::ByteFormat::LittleEndian)
          end
        end
        jd_cheb = items.shift(2)
        ipts.each_with_index do |ipt, i|
          n = i == 11 ? 2 : 3  # 要素数
          ary_1 = Array(Array(Array(Float64))).new
          ipt[2].times do |j|
            ary_0 = Array(Array(Float64)).new
            n.times do |k|
              ary_0 << items.shift(ipt[1])
            end
            ary_1 << ary_0
          end
          coeffs << ary_1
        end
        return {coeffs, jd_cheb}
      rescue e
        raise e
      end
    end
  end
end
