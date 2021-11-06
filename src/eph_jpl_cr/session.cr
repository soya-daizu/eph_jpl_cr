module EphJplCr
  class Session
    @bin_io : IO
    @ephemeris : Ephemeris?

    def initialize(bin_path : String, use_memory_io : Bool)
      raise Const::MSG_ERR_2 unless File.exists?(bin_path)
      bin_file = File.open(bin_path, "rb")
      @bin_io = if use_memory_io
        IO::Memory.new(bin_file.gets_to_end)
      else
        bin_file
      end
    end

    def set_args(target : Int32, center : Int32, jd : Float64, km : Bool = Const::KM)
      Arguments.check_args(target, center, jd, km)
      bin = Binary.new(@bin_io.as(File | IO::Memory), target, center, jd)
      @ephemeris = Ephemeris.new(target, center, jd, bin, km)
    end

    def calc
      raise Const::MSG_ERR_10 unless @ephemeris
      @ephemeris.not_nil!.calc
    end
  end
end