module Character.Player where

type alias Player =
  { name : String,
    stats : PlayerStats,
    health : Int
  }

type alias PlayerStats =
  { attack : Int,
    intelligence : Int,
    defence : Int
  }

daveHardbrainStats : PlayerStats
daveHardbrainStats =
  { attack = 15,
    intelligence = 5,
    defence = 6
  }

daveHardbrain : Player
daveHardbrain =
  { name = "Dave Hardbrain",
    stats = daveHardbrainStats,
    health = 150
  }