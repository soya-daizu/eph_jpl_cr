module EphJplCr
  module Const
    MSG_ERR_2    = "Binary file is not found!"
    MSG_ERR_3    = "TARGET is invalid!"
    MSG_ERR_4    = "CENTER is invalid!"
    MSG_ERR_5    = "TARGET == CENTER ?"
    MSG_ERR_6    = "TARGET or CENTER is invalid!"
    MSG_ERR_7    = "JD is invalid!"
    MSG_ERR_8    = "KM flag is invalid!"
    MSG_ERR_9    = "This library is supporting only DE430!"
    EPOCH_PERIOD = 2287184.5..2688976.5
    KSIZE        = 2036
    RECL         = 4
    ASTRS        = [
      "Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus",
      "Neptune", "Pluto", "Moon", "Sun", "Solar system Barycenter",
      "Earth-Moon barycenter", "Earth Nutations", "Lunar mantle Librations"
    ]
    KIND         = 2
    BARY         = true
    KM           = false
  end
end
