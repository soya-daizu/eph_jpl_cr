module EphJplCr
  class Session
    @bin_file : File
    @ephemeris : Ephemeris?

    def initialize(bin_path : String)
      raise Const::MSG_ERR_2 unless File.exists?(bin_path)
      @bin_file = File.open(bin_path, "rb")
    end

    def set_args(target : Int32, center : Int32, jd : Float64, km : Bool = Const::KM)
      Arguments.check_args(target, center, jd, km)
      bin = Binary.new(@bin_file, target, center, jd)
      @ephemeris = Ephemeris.new(target, center, jd, bin, km)
    end

    def calc
      raise Const::MSG_ERR_10 unless @ephemeris
      @ephemeris.not_nil!.calc
    end
  end
end