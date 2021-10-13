require "./eph_jpl_cr/*"

module EphJplCr
  VERSION = "0.1.2"

  def self.new(bin_path : String, target : Int32, center : Int32, jd : Float64, km : Bool = Const::KM)
    bin_path, target, center, jd, km = Argument.new(bin_path, target, center, jd, km).get_args
    bin = Binary.new(bin_path, target, center, jd).get_binary
    return EphJplCr::Ephemeris.new(target, center, jd, bin, km)
  end
end
